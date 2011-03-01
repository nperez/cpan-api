use Test::Most;
use strict;
use warnings;
use MetaCPAN::Util;
use CPAN::Meta;

is( MetaCPAN::Util::numify_version(1),        1.000 );
is( MetaCPAN::Util::numify_version('010'),    10.000 );
is( MetaCPAN::Util::numify_version('v2.1.1'), 2.001001 );
is( MetaCPAN::Util::numify_version(undef),    0.000 );
is( MetaCPAN::Util::numify_version('LATEST'), 0.000 );
is( MetaCPAN::Util::numify_version('0.20_8'), 0.208 );

lives_ok { is(version("2a"), 2) };
lives_ok { is(version("V0.01"), 0.01) };
lives_ok { is(version('0.99_1'), '0.99_1') };
lives_ok { is(version('0.99.01'), '0.99.01') };

sub version {
    CPAN::Meta->new(
                     { name    => 'foo',
                       license => 'unknown',
                       version => MetaCPAN::Util::fix_version(shift) } )->version;
}

done_testing;
