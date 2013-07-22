#! /usr/bin/env perl

use strict;
use LWP::Simple;
use XML::LibXML;
use XML::LibXSLT;

# Always return valid XML
# but return text right now, for debugging
print "Content-type:  text/plain\n\n";

# Base URL of NCBI E-utilities
my $eutilsBase = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';

# Allowed scripts
my @scripts = qw( einfo elink esummary efetch );


(my $scriptName = $ENV{SCRIPT_NAME}) =~ s|.*/(.*?)\.cgi|$1|;
if (!grep(/$scriptName/, @scripts)) {
    # Error
    print "<response status='error'>not found: $scriptName</response>\n";
    exit 0;
}

my $qs = $ENV{QUERY_STRING};

my $eutilsUri = $eutilsBase . $scriptName . '.fcgi' . ($qs ? '?' . $qs : '');

# Read the stuff from the specified URL
my $content = get $eutilsUri;
my $eutilsXml = XML::LibXML->load_xml(string => $content);

print "Instantiating xslt\n";
my $xsltProcessor = XML::LibXSLT->new();
my $xsltDoc = XML::LibXML->load_xml(
    location => 'einfo.xsl', 
    no_cdata => 1
);
my $xslt = $xsltProcessor->parse_stylesheet($xsltDoc);
my $results = $xslt->transform($eutilsXml);

print "\n\nresults:\n";
print $results->serialize();
print "\n\ncontent:\n";
print $content;

# For debugging:
#foreach my $k (keys %ENV) {
#    print "$k: $ENV{$k}\n";
#}
