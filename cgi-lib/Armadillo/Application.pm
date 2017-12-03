package Application 1.00;

use strict;
use warnings FATAL => 'all';
use Data::Dump qw/dump/;
use CGI;

use Armadillo::Session;


##################################################
## the object constructor                        ##
##################################################
sub new {

    my $self = {
        docroot => $ENV{DOCUMENT_ROOT},
        cgi => CGI->new()
    };

    bless $self, $_[0];

    # Initialize some basic variables for the session

    $self->_init();

    # return the Application Object
    return $self;
}

sub _init
{
    # Lets check if we have a session
    $_[0]->{session} = Session->new( $_[0]->{cgi} );

    print $_[0]->{cgi}->header(-type => 'text/html', -charset => 'utf-8');

}


sub debug
{
    print dump $_[0];
}

1;