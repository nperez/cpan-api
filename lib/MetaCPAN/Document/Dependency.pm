package MetaCPAN::Document::Dependency;
use Moose;
use ElasticSearchX::Model::Document;
use MetaCPAN::Util;

has [qw(phase relationship module version)] => ( is => 'ro', required => 1 );
has version_numified =>
    ( is => 'ro', required => 1, isa => 'Num', lazy_build => 1 );

sub _build_version_numified {
    return MetaCPAN::Util::numify_version( shift->version );
}

__PACKAGE__->meta->make_immutable;
