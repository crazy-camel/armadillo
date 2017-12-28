#!/usr/bin/env perl

use v5.14;
use strict;
use warnings FATAL => 'all';

use Env;
use lib $CARAVAN_PERLLIB;

use Caravan::Application;

my $caravan = Caravan::Application->new();

my $parameters = {
	caravan_root => $CARAVAN_ROOT 
};
# -- ######  ############ -- 
print $caravan->query->header();
print $caravan->render(
	template => 'view.tmpl',
	parameters => $parameters
	);
