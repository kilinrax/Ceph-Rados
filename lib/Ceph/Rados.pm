package Ceph::Rados;

use 5.014002;
use strict;
use warnings;
use Carp;

use Ceph::Rados::IO;

our @ISA = qw();

our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Ceph::Rados::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Ceph::Rados', $VERSION);

# Preloaded methods go here.

sub new {
    my ($class, $id, %args) = @_;
    my $obj = create($id);
    bless $obj, $class;

    while( my ($key, $value) = each %args ) {
        my $method = "set_${key}";
        if( $obj->can($method) ) {
            $obj->$method($value);
        } else {
            Carp::carp "Invalid setting '$key'";
        }
    }
    return $obj;
}

sub io {
    my ($self, $pool_name) = @_;
    croak "usage: ->io(pool_name)" unless defined $pool_name;
    Ceph::Rados::IO->new($self, $pool_name);
}

sub DESTROY {
    my $self = shift;
    $self->shutdown;
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Ceph::Rados - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Ceph::Rados;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Ceph::Rados, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Alex, E<lt>alex@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Alex

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
