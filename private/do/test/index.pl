#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use Env;
use File::Basename;
use File::Spec;

use lib File::Spec->catdir( dirname( $DOCUMENT_ROOT ) , "cgi-lib" );
use Armadillo::Application;

# ##################################################################
# # Initialization                                                 #
# ##################################################################

my $app = Application->new();

print "<h1>Private</h1><br/>";
print $DOCUMENT_ROOT."<br/>";
print File::Spec->catdir( dirname( $DOCUMENT_ROOT ) , "cgi-lib" );

$app->debug;