package Session;

use strict;
use warnings FATAL => 'all';

use CGI::Session;

sub new
{
    my $self = {
        docroot => $ENV{DOCUMENT_ROOT}
    };

    my $session = CGI::Session->load();

    if ( $session->is_expired ) {
        $_[0]->gotoLogin( $_[1] );
        die;
    }

    if ( $session->is_empty ) {
        $session = $session->new();
    }

    $self->{session} = $session;

    return bless $self, $_[0];
}

sub gotoLogin
{
    print $_[1]->redirect( "/login.html" );
    die;
}


1;