package Acme::Magpie;
use strict;
use vars qw/$VERSION %Nest/;
$VERSION = 0.03;

use Devel::Symdump;

sub import {
    my $self = shift;
    for my $sym ( sort Devel::Symdump->rnew('main')->functions() ) {
        next if $sym =~ /^Acme::Magpie/;

        if ( $self->shiny($sym) ) {
            my ($pkg, $name) = $sym =~ /^(.*::)(.*)$/;
            our %symtab;
            {
                no strict 'refs';
                *symtab = \%{ $pkg };
            }
            $Nest{ $sym } = delete $symtab{ $name };
        }
    }
}

sub unimport {
   for my $sym (sort keys %Nest) {
       my ($pkg, $name) = $sym =~ /^(.*::)(.*)$/;
       our %symtab;
       {
           no strict 'refs';
           *symtab = \%{ $pkg };
       }
       $symtab{ $name } = delete $Nest{ $sym };
   }
}


sub shiny {
    return rand > 0.95;
}

1;
__END__

=head1 NAME

Acme::Magpie - steals shiny things

=head1 SYNOPSIS

 use Acme::Magpie;
 # oh no, some of the shiny methods have gone away

 no Acme::Magpie;
 # phew, they're back now

=head1 DISCUSSION

The Magpie is a bird known for stealing shiny things to build its nest
from, Acme::Magpie attempts to be a software emulation of this
behaviour.

When invoked Acme::Magpie scans the symbol tables of your program and
stores attractive (shiny) methods in the %Acme::Magpie::Nest hash.

Shinyness is determined by the return value of the shiny method
this can be redefined by child classes:

 package Acme::Magpie::l33t;
 use strict;
 use base qw(Acme::Magpie);

 sub shiny {
     ($_) = $_[1] =~ /.*::(.*)/;
     return tr/[0-9]// > tr/[a-z][A-Z]//;;
 }
 1;
 __END__

This magpie considers identifiers with more numbers than letters as
shiny.  The code is installed with this distribution.

=head1 BUGS

Acme::Magpie will cause most of the code you use it in to die because
the subroutines it tries to execute just won't be there.  This is
considered a feature.

=head1 AUTHOR

=head1 HISTORY


=item revision 0.03 2002-05-22

Rewrote tests to eliminate heisenbug caused by randomly tweaking
symbol tables.


=item revision 0.02 2002-05-22

Bugfix release, includes spelling correction to pod.  Thanks go to
Jonathan Paton for catching this.

=item revision 0.01 2002-05-01

Initial CPAN release

=over

=back

Richard Clamp E<lt>richardc@unixbeard.netE<gt>, original idea by Tom
Hukins

=head1 COPYRIGHT

       Copyright (C) 2002 Richard Clamp.
       All Rights Reserved.

       This module is free software; you can redistribute it
       and/or modify it under the same terms as Perl itself.

=cut
