#! /usr/bin/env perl

use strict;
use LWP::Simple;
use XML::LibXML;
use XML::LibXSLT;

# Always return valid XML
print "Content-type:  text/xml\n\n";

# Base URL of NCBI E-utilities
my $eutilsBase = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';

# The complete set of allowed scripts
my @scripts = qw( einfo elink esummary efetch );


(my $scriptName = $ENV{SCRIPT_NAME}) =~ s|.*/(.*?)\.cgi|$1|;
if (!grep(/$scriptName/, @scripts)) {
    # Error
    # FIXME:  Write a generic error handling subroutine
    # FIXME:  Set an HTTP error status here (which one?)
    print "<response status='error'>Script not supported: " .
          $scriptName . "</response>\n";
    exit 0;
}

# Compute the URI of the real E-utilities, and make the request
# FIXME:  Need to do some error handling here
my $qs = $ENV{QUERY_STRING};
my $eutilsUri = $eutilsBase . $scriptName . '.fcgi' . ($qs ? '?' . $qs : '');
my $eutilsResponse = get $eutilsUri;
my $eutilsXml = XML::LibXML->load_xml(string => $eutilsResponse);

# FIXME:  Only pass the results through an XSLT if the retmode=rdf query
# string parameter was given.  Right now it does it regardless.

# Read and initialize the XSLT stylesheet
# FIXME:  need error handling
my $xsltProcessor = XML::LibXSLT->new();
my $xsltDoc = XML::LibXML->load_xml(
    # FIXME:  right now this only does einfo
    location => 'einfo.xsl', 
    no_cdata => 1
);
my $xslt = $xsltProcessor->parse_stylesheet($xsltDoc);
my $eutilsRdf = $xslt->transform($eutilsXml);

print $eutilsRdf->serialize();

# For debugging:
#foreach my $k (keys %ENV) {
#    print "$k: $ENV{$k}\n";
#}
