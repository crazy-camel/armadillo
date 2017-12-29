package Armadillo::Application;

use Env;
use Object::Tiny qw( query database );
use YAML::Tiny;
use Path::Tiny;

use HTML::Template;
use CGI '-utf8';
#use CGI::Session::SQLite;
use Data::Dumper;
use DBI;

# ===================================== ->
# Initialization variables
# ===================================== ->
sub new {
   my $class = shift;
   my $self  = $class->SUPER::new( @_ );
   # parameters
   $self->{query} = CGI->new;
   # properties
   $self->{properties} = YAML::Tiny->new( $ARMADILLO_ROOT . "/properties.yml" );
   # database load
   $self->load('database');
   return $self;
}

sub load
{
  if ( $_[1] eq 'database' )
  {
    $_[0]->{database} = DBI->connect("dbi:SQLite:uri=file:".$ARMADILLO_ROOT."/database.sqlite"."?mode=rwc","","");
    return $_[0]->{database};
  }
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

sub property
{
	return ( $_[0]->{properties}->[0]->{ $_[1] } ) ?  $_[0]->{properties}->[0]->{ $_[1] } : "/" ;
}

sub redirect
{
  return $_[0]->{query}->redirect( $_[0]->index( $_[1] ) );
}

1;