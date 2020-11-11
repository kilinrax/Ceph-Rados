use strict;
use warnings;

use Test::More tests => 14;
use Test::Exception;
use Ceph::Rados;
use Data::Dump qw/dump/;
use FindBin qw/$Bin/;

my @rnd = ('a'..'z',0..9);

my $pool = $ENV{CEPH_POOL} || 'test_' . join '', map { $rnd[rand @rnd] } 0..9;

my $client = $ENV{CEPH_CLIENT} || 'admin';

my $huge_file = "$Bin/test_huge_file";
if (-e $huge_file && -s $huge_file < 90 * 1024 * 1024) {
    warn "$huge_file was truncated, removing";
    unlink $huge_file;
}
if (!-e $huge_file) {
    diag "creating $huge_file";
    system "dd if=/dev/zero of=$huge_file count=120M iflag=count_bytes"
}

my %files;
{
    open my $HUGE, "$Bin/test_huge_file" or die "Cannot open $Bin/test_huge_file: $!";
    binmode $HUGE;
    undef $/;
    $files{test_huge} = <$HUGE>;
    close $HUGE;
}

my $pool_created_p = system "ceph osd pool create $pool 1"
    unless $ENV{CEPH_POOL};
SKIP: {
    skip "Can't create $pool pool", 13 if $pool_created_p;

    my ($cluster, $io, $list);
    ok( $cluster = Ceph::Rados->new($client), "Create cluster handle" );
    ok( $cluster->set_config_file, "Read config file" );
    ok( $cluster->set_config_option(keyring => "/etc/ceph/ceph.client.$client.keyring"),
        "Set config option 'keyring'" );
    ok( $cluster->connect, "Connect to cluster" );
    ok( $io = $cluster->io($pool), "Open rados pool" );

    while (my ($filename, $content) = each %files) {
        ok( $io->write($filename, $content), "Write $filename object" );
        my $length = length($content);
        ok( my $stored_data = $io->read($filename, $length),
            "Read $length bytes from $filename object" );
        unless (
            ok( $stored_data eq $content, "Get back $filename\'s content ok" )
        ) {
            my $rej_file = "$filename.rej";
            diag "Writing saved content to $rej_file";
            open my $REJ, ">$rej_file" or die "Cannot open $rej_file: $!";
            print $REJ $stored_data;
            close $REJ;
        };
        ok( $list = $io->list, "Opened list context" );
        my $match = 0;
        while (my $entry = $list->next) {
            #diag "Found $entry";
            $match = 1 if $entry eq $filename;
        }
        ok( $match, "List contains written file $filename" );
        ok( $io->remove($filename), "Remove $filename object" );
    }

    lives_ok { undef $list } "Closed list context";
    lives_ok { undef $io } "Closed rados pool";
    lives_ok { undef $cluster } "Disconnected from cluster";

    system "ceph osd pool delete $pool $pool --yes-i-really-really-mean-it"
        unless $ENV{CEPH_POOL};
}
