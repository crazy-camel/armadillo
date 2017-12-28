#!/usr/bin/env perl

use v5.14;
use strict;
use warnings FATAL => 'all';

use Env;
use lib $ARAMADILLO_PERLLIB;

use Armadillo::Application;

my $caravan = Armadillo::Application->new();

print $caravan->query->header();
print $caravan->render(
	template => 'view.tmpl',
	parameters => $parameters
	);
