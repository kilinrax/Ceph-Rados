use strict;
use warnings;

use Test::More tests => 2;
use Test::Exception;
use Test::SharedFork;

use Ceph::Rados;
use Data::Dump qw/dump/;
use Fcntl qw/:flock/;
use POSIX ":sys_wait_h";

use Config;
defined $Config{sig_name} || die "No sigs?";
my $i = 0;
my @signame;
foreach my $name (split(' ', $Config{sig_name})) {
    $signame[$i++] = $name;
}

my @rnd = ('a'..'z',0..9);

my $filename = 'test_' . join '', map { $rnd[rand @rnd] } 0..9;;
my $content = "Hello world.\n";

my $pool = $ENV{CEPH_POOL} || $filename;
my $client = $ENV{CEPH_CLIENT} || 'admin';

sub make_io {
    my ($cluster, $io);
    ok( $cluster = Ceph::Rados->new($client), "Create cluster handle" );
    ok( $cluster->set_config_file, "Read config file" );
    ok( $cluster->set_config_option(keyring => "/etc/ceph/ceph.client.$client.keyring"),
        "Set config option 'keyring'" );
    ok( $cluster->connect, "Connect to cluster" );
    ok( $io = $cluster->io($pool), "Open rados pool '$pool'" );
    return $io;
}

sub make_list {
    my ($io, $list);
    $io = make_io;
    ok( $list = $io->list, "Opened list context" );
    return $list;
}

sub fork_and_check {
    my $callback = shift;
    my $pid = fork;
	if (!defined $pid) {
		die "Fork failed: $!";
    } elsif ($pid == 0) { # child
        subtest fork => $callback;
        exit;
    }
    my $i = 0;
    while ($i++ < 60 and !waitpid($pid, WNOHANG)) {
        diag "Waiting for $pid";
        sleep(10);
    }
    if ($?) {
        my $err = $? == -1 ? $! : $? & 127 ?
            (sprintf "received signal %s%s", $signame[$? & 127],
					$? & 128 ? ' and dumped core' : '') :
            sprintf("exit value %d", $? >> 8);
        diag "Fork died: $err";
        return 0;
    }
    return 1;
}

my $pool_created_p = system "ceph osd pool create $pool 1"
    unless $ENV{CEPH_POOL};
SKIP: {
    skip "Can't create $pool pool", 21 if $pool_created_p;

    ok( fork_and_check( sub {
        my ($io, $list);
        ok( $io = make_io(), 'make_io()' );

        ok( $io->write($filename, $content), "Write object" );
        ok( $io->mtime($filename), "Get file mod time" );
        my $length;
        ok( $length = $io->size($filename), "Get file size" );
        is( $length, length($content), "Get correct size" );
        $length = length($content); # just to be sure following tests don't fail if above does
        ok( my $stored_data = $io->read($filename, $length), "Read $length bytes from object" );
        is( $stored_data, $content, "Get back content ok" );
        ok( my $stored_data2 = $io->read($filename), "Read unknown bytes from object" );
        is( $stored_data2, $content, "Get back content ok without read size" );
        ok( my ($stat_size, $stat_mtime) = $io->stat($filename), "Stat object" );
        is( $stat_size, $length, "Stat size is same as content length" );
    
        ok( $list = make_list(), 'make_list()' );
        my $match = 0;
        while (my $entry = $list->next) {
            #diag "Found $entry";
            $match = 1 if $entry eq $filename;
        }
        ok( $match, "List contains written file" );
        ok( $io->remove($filename), "Remove object" );
        lives_ok { undef $list } "Closed list context";
        lives_ok { undef $io } "Closed rados pool";
    } ), 'segfault check' ) or fail "This test is unrecoverable";

    system "ceph osd pool delete $pool $pool --yes-i-really-really-mean-it"
        unless $ENV{CEPH_POOL};
}
