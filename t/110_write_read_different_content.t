use strictures;

use Test::More tests => 14;
use Test::Exception;
use Ceph::Rados;
use Data::Dump qw/dump/;

my @rnd = ('a'..'z',0..9);

my $pool = 'test_' . join '', map { $rnd[rand @rnd] } 0..9;
my %files;
$files{test_short} = 'wargleblarg';
$files{test_medium} = <<EOF;
There is the theory of Möbius. A twist in the fabric of space where time becomes a loop.
EOF
$files{test_long} = join '\n', <DATA>;

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

    while (my ($filename, $content) = each %files) {
        ok( $io->write($filename, $content), "Write $filename object" );
        my $length = length($content);
        ok( my $stored_data = $io->read($filename, $length),
            "Read $length bytes from $filename object" );
        is( $stored_data, $content, "Get back $filename\'s content ok" );
        ok( $list = $io->list, "Opened list context" );
        my $match = 0;
        while (my $entry = $list->next) {
            diag "Found $entry";
            $match = 1 if $entry eq $filename;
        }
        ok( $match, "List contains written file $filename" );
        ok( $io->remove($filename), "Remove $filename object" );
    }

    lives_ok { undef $list } "Closed list context";
    lives_ok { undef $io } "Closed rados pool";
    lives_ok { undef $cluster } "Disconnected from cluster";

    system "ceph osd pool delete $pool $pool --yes-i-really-really-mean-it";
}

__DATA__
 Verdaustig war's, und glaße Wieben
 rotterten gorkicht im Gemank.
 Gar elump war der Pluckerwank,
 und die gabben Schweisel frieben.

 »Hab acht vorm Zipferlak, mein Kind!
 Sein Maul ist beiß, sein Griff ist bohr.
 Vorm Fliegelflagel sieh dich vor,
 dem mampfen Schnatterrind.«

 Er zückt' sein scharfgebifftes Schwert,
 den Feind zu futzen ohne Saum,
 und lehnt' sich an den Dudelbaum
 und stand da lang in sich gekehrt.

 In sich gekeimt, so stand er hier,
 da kam verschnoff der Zipferlak
 mit Flammenlefze angewackt
 und gurgt' in seiner Gier.

 Mit Eins! und Zwei! und bis auf's Bein!
 Die biffe Klinge ritscheropf!
 Trennt' er vom Hals den toten Kopf,
 und wichernd sprengt' er heim.

 »Vom Zipferlak hast uns befreit?
 Komm an mein Herz, aromer Sohn!
 Oh, blumer Tag! Oh, schlusse Fron!«
 So kröpfte er vor Freud'.

 Verdaustig war's, und glaße Wieben
 rotterten gorkicht im Gemank.
 Gar elump war der Pluckerwank,
 und die gabben Schweisel frieben.
