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

# ================================================== -->
# Welcome User
# ================================================== -->
print $armadillo->query->header( -charset => 'utf-8' );
print $armadillo->render( template => 'view.tmpl' );
