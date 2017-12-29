#!/usr/bin/env perl

use v5.14;
use strict;
use warnings FATAL => 'all';

use Env;
use lib $ARMADILLO_PERLLIB;
use Armadillo::Application;
use Path::Tiny;

my $armadillo = Armadillo::Application->new();

if ( defined $ENV{ARMADILLO_INSTALLED} )
{
	print $armadillo->redirect( "home" );
	exit(0);
}

my $query = $armadillo->query;

# ================================================== -->
# Step 1 - Clear out the Database
# ================================================== -->
unlink( $ARMADILLO_ROOT . "/database.sqlite" );
path( $ARMADILLO_ROOT . "/database.sqlite"  )->spew();

my $dbh = $armadillo->load('database');
# ================================================== -->
# Step 2 - Create the base tables
# ================================================== -->
foreach my $migration ( path( $ARMADILLO_ROOT .  "/migrations/install"  )->children( qr/\.sql$/ ) )
{
	my @sql = path( $migration )->lines();
	$dbh->do( $_ ) for ( @sql );
}
# ================================================== -->
# Welcome User
# ================================================== -->
print $armadillo->query->header( -charset => 'utf-8' );
print $armadillo->render( template => 'view.tmpl' );


