package MetaCPAN::Server::Controller::Package;
use Moose;
BEGIN { extends 'MetaCPAN::Server::Controller::File' }

has '+type' => ( default => 'file' );

sub index : Chained('/') : PathPart('package') : CaptureArgs(0) {
}

sub get : Chained('index') : PathPart('') : Args(1) {
    my ( $self, $c, $module ) = @_;

    my %search = (
        type   => 'file',
        size   => 1,
        query  => { match_all => {} },
        filter => {
            "and" => [
                {   "nested" => {
                        "path"  => "module",
                        "query" => {
                            "bool" => {
                                "must" => [
                                    {   "term" => { "module.name" => $module }
                                    },
                                    {   "term" =>
                                            { "module.indexed" => 'true' }
                                    },
                                    {   "term" =>
                                            { "module.authorized" => 'true' }
                                    }
                                ]
                            }
                        }
                    }
                },
                { "term" => { "file.status" => "latest" } }
            ]
        }
    );

    eval {
        my $results = $c->model( 'CPAN::File' )->es->search( %search );
        $c->stash( $results->{hits}->{hits}->[0]->{_source} );
    } or $c->detach( '/not_found' );
}

1;
