#!perl -w
use strict;
use Test::More tests => 7;

# Yes this is written a bit quirkily, if we don't do this then the
# Magpie steals the testsuite

require_ok('Acme::Magpie');

Acme::Magpie->import;

my %nest;
$nest{before} = { %Acme::Magpie::Nest };

my ($missing) = keys %Acme::Magpie::Nest;
my ($pkg, $name) = $missing =~ /^(.*::)(.*)$/;

eval { $pkg->$name() };
my $reallygone = $@;

Acme::Magpie->unimport;

$nest{after} = { %Acme::Magpie::Nest };

ok(1, "Everything ran");
ok(scalar keys %{ $nest{before} },   "Stole some things");
ok($reallygone,                      "They were really gone");
is(scalar keys %{ $nest{after} }, 0, "Put them back again");

sub f00 {}
require_ok('Acme::Magpie::l33t');
Acme::Magpie::l33t->import;

is_deeply( [ sort keys %Acme::Magpie::Nest ], [ "f00" ], "Stole f00");


