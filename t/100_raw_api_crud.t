use strictures;

use Test::More tests => 14;
use Test::Exception;
use Ceph::Rados;
use Data::Dump qw/dump/;

my @rnd = ('a'..'z',0..9);

my $pool = 'test_' . join '', map { $rnd[rand @rnd] } 0..9;
my $filename = 'test_file';
my $content = 'test';

my $pool_created_p = system "ceph osd pool create $pool 1";
SKIP: {
    skip "Can't create $pool pool", 14 if $pool_created_p;

    my ($cluster, $io, $list);
    ok( $cluster = Ceph::Rados->new('admin'), "Create cluster handle" );
    ok( $cluster->set_config_file, "Read config file" );
    ok( $cluster->set_config_option(keyring => "/etc/ceph/ceph.client.admin.keyring"),
        "Set config option 'keyring'" );
    ok( $cluster->connect, "Connect to cluster" );
    ok( $io = $cluster->io($pool), "Open rados pool" );
    ok( $io->write($filename, $content), "Write object" );
    my $length = length($content);
    ok( my $stored_data = $io->read($filename, $length), "Read $length bytes from object" );
    is( $stored_data, $content, "Get back content ok" );
    ok( $list = $io->list, "Opened list context" );
    my $match = 0;
    while (my $entry = $list->next) {
        diag "Found $entry";
        $match = 1 if $entry eq $filename;
    }
    ok( $match, "List contains written file" );
    ok( $io->remove($filename), "Remove object" );
    lives_ok { undef $list } "Closed list context";
    lives_ok { undef $io } "Closed rados pool";
    lives_ok { undef $cluster } "Disconnected from cluster";

    system "ceph osd pool delete $pool $pool --yes-i-really-really-mean-it";
}
