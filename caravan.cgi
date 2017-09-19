#!/usr/bin/env perl

use v5.14;

use warnings;
use strict;

use File::Basename;
use Env;


use CGI;
use CGI::Carp qw(fatalsToBrowser);

# Get parameters
# =========================================== ->

my $q = CGI->new();

my $base = dirname( $DOCUMENT_ROOT );
my $repo = $q->param('idx');

my $properties = base( ".caravan", $repo, "properties.ini" );

print $q->header('application/json');

print "[ {\"idx\" : \"$repo\"} ]";


# Functions
# ========================================================== ->
sub base {
    return ( scalar(@_) ) ? File::Spec->catfile( $base, @_ ) : $base;
}

