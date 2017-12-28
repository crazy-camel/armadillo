#!/usr/bin/env perl

use v5.14;
use strict;
use warnings FATAL => 'all';

use Env;
use lib $CARAVAN_PERLLIB;
use Caravan::Application;

my $caravan = Caravan::Application->new();

if ( defined $ENV{CARAVAN_INSTALLED} )
{
	print $caravan->redirect( "home" );
	exit(0);
}

my $query = $caravan->query;
my $parameters = {
	caravan_root => $CARAVAN_ROOT 
};

print $query->header();
print $caravan->render(
	template => 'view.tmpl',
	parameters => $parameters
	);

print $caravan->setEnviromentVariable( 'CARAVAN_INSTALLED', 1 );

# Lets clean up the files once we are done
