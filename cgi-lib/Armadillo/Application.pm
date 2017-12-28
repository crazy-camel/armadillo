package Armadillo::Application;

use Env;
use Object::Tiny qw( query );
use YAML::Tiny;
use Path::Tiny;

use HTML::Template;
use CGI;
use CGI::Session::SQLite;
use Data::Dumper;

# ===================================== ->
# Initialization variables
# ===================================== ->
sub new {
   my $class = shift;
   my $self  = $class->SUPER::new( @_ );
   # parameters
   $self->{query} = CGI->new();
   # properties
   $self->{properties} = YAML::Tiny->new( $CARAVAN_ROOT . "/properties.yml" );
   return $self;
}

sub check {
        my ($self, $session, $cgi) = @_; # receive two args

        if ( $session->param("~logged-in") ) {
            return 1;  # if logged in, don't bother going further
        }

        my $lg_name = $cgi->param("lg_name") or return;
        my $lg_psswd=$cgi->param("lg_password") or return;

        # if we came this far, user did submit the login form
        # so let's try to load his/her profile if name/psswds match
        if ( my $profile = _load_profile($lg_name, $lg_psswd) ) {
            $session->param("~profile", $profile);
            $session->param("~logged-in", 1);
            $session->clear(["~login-trials"]);
            return 1;

        }

        # if we came this far, the login/psswds do not match
        # the entries in the database
        my $trials = $session->param("~login-trials") || 0;
        return $session->param("~login-trials", ++$trials);
    }

 sub _load_profile {
        my ($self, $lg_name, $lg_psswd) = @_;

        local $/ = "\n";
        unless (sysopen(PROFILE, "profiles.txt", O_RDONLY) ) {
            die "Couldn't open profiles.txt: $!");
        }
        while ( <PROFILES> ) {
            /^(\n|#)/ and next;
            chomp;
            my ($n, $p, $e) = split "\s+";
            if ( ($n eq $lg_name) && ($p eq $lg_psswd) ) {
                my $p_mask = "x" . length($p);
                return {username=>$n, password=>$p_mask, email=>$e};

            }
        }
        close(PROFILE);

        return undef;
}
sub setEnviromentVariable
{
  my( $self, $name, $value ) = @_;
  my $statement = "RewriteRule ^ - [env=".$name.":".$value."]\n\t\t#####CARAVANPLACEHOLDER#######";
  my $htaccess = path( $DOCUMENT_ROOT."/.htaccess" );
  my $guts = $htaccess->slurp;
  $guts =~ s/#####CARAVANPLACEHOLDER#######/$statement/i;
  $htaccess->spew_raw( $guts );
  return $statement ;
}

sub render
{
  my ( $self, $args ) = ( shift(@_), { @_ } );

  my $template = HTML::Template->new( filename => $args->{template}, die_on_bad_params => 0, associate => $self->query );
  
  if ( $args->{parameters} )
  {
  	$template->param( $args->{parameters} );
  }
  
  return $template->output();
}

sub index
{
	return ( $_[0]->{properties}->[0]->{ $_[1] } ) ?  $_[0]->{properties}->[0]->{ $_[1] } : "/" ;
}

sub redirect
{
  return $_[0]->{query}->redirect( $_[0]->index( $_[1] ) );
}

1;