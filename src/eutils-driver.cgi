#! /usr/bin/env perl

use strict;
use LWP::Simple;

# Always return valid XML
print "Content-type:  text/xml\n\n";

# Base URL of NCBI E-utilities
my $eutilsBase = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';

# Allowed scripts
my @scripts = qw( einfo elink esummary efetch );


(my $scriptName = $ENV{SCRIPT_NAME}) =~ s|.*/(.*?)\.cgi|$1|;
if (!grep(/$scriptName/, @scripts)) {
    # Error
    print "<reponse status='error'>not found: $scriptName</response>\n";
    exit 0;
}

my $qs = $ENV{QUERY_STRING};

my $eutilsUri = $eutilsBase . $scriptName . '.fcgi' . ($qs ? '?' . $qs : '');

# Read the stuff from the specified URL
my $content = get $eutilsUri;

print $content;

# For debugging:
#foreach my $k (keys %ENV) {
#    print "$k: $ENV{$k}\n";
#}