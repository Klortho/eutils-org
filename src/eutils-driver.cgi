#! /usr/bin/env perl

use strict;
use LWP::Simple;
use XML::LibXML;
use XML::LibXSLT;
use CGI;

# Base URL of NCBI E-utilities
my $eutilsBase = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';

# Set this to 1 to turn on debugging.
my $debug = 0;
if ($debug) {
    print "Content-type: text/plain\n\n";
    print "Environment:\n";
    foreach my $env (sort keys %ENV) {
        print "    " . $env . ": '" . $ENV{$env} . "'\n";
    }
    print "\n";
}

# Get the CGI params I care about
my $q = CGI->new();
my $retmode = $q->param('retmode');
if ($debug) {
    print "CGI parameters:\n";
    print "    retmode: '$retmode'\n";
}


# Check retmode.  It must be 'rdf'
if ($retmode ne 'rdf') {
}

# Figure out what Eutilities script we are emulating
# The complete set of allowed scripts
my @scripts = qw( einfo elink esummary );

my $scriptPath = $ENV{SCRIPT_NAME};                       # E.g. /eutils/einfo.cgi

# If we can't decipher the URL at all, then 404
if ($scriptPath !~ m{.*/.+\.f?cgi$}) {
    error404("Can't find a script name in '$scriptPath'");
}

(my $scriptName = $scriptPath) =~ s|.*/(.+?)\.f?cgi$|$1|;  # E.g. einfo

# Figure out the NCBI E-utilities URL corresponding to this request
my $eutilsUriPath = $eutilsBase . $scriptName . '.fcgi';
my $qs = $ENV{QUERY_STRING};

# If the request is not for rdf, then do a 303 redirect to NCBI, with no munging of the
# query string
if ($retmode ne 'rdf') {
    my $eutilsUri = $eutilsUriPath . ($qs ? '?' . $qs : '');
    redirect303("Format not supported", $eutilsUri);
}

# Now we know that the user is requesting RDF, so for any other problems, do a 404.

# If the script is not supported, do a 404
if (!grep(/$scriptName/, @scripts)) {
    error404("Script not supported:  $scriptName");
}

# Replace retmode=rdf with retmode=xml in the query string, and construct the NCBI
# E-utilities URL
(my $newQs = $qs) =~ s/retmode=rdf/retmode=xml/;
$newQs .= "&tool=eutilsrdf&email=voldrani\@gmail.com";
my $eutilsUri = $eutilsUriPath . ($newQs ? '?' . $newQs : '');




# Make the request to NCBI
# FIXME:  Need to do some error handling here
my $eutilsResponse = get $eutilsUri;
if (!defined $eutilsResponse) {
    error502("Bad response from NCBI E-utilities");
}
if ($debug) {
    print "NCBI E-utilities response:\n" . $eutilsResponse . "\n\n";
}
my $eutilsXml = XML::LibXML->load_xml(string => $eutilsResponse);

# Read and initialize the XSLT stylesheet
# No extra error handling here.  If this fails, the user should get a 500 Internal
# server error, because that's what happened.
my $xsltProcessor = XML::LibXSLT->new();
my $xsltDoc = XML::LibXML->load_xml(
    location => $scriptName . '.xsl',
    no_cdata => 1,
);

my $xslt = $xsltProcessor->parse_stylesheet($xsltDoc);
my $eutilsRdf = $xslt->transform($eutilsXml);

my $docElem = $eutilsRdf->documentElement();
my $status = $docElem->getAttribute('status');
if ($status eq 'error') {
    error404($docElem->textContent())
}



print contentType() . "\n" .
      $eutilsRdf->serialize();


#------------------------------------------------------------------
# This just prints the first line, content-type, of the header.  The caller
# can add more header lines after this.

sub contentType
{
    my $h = '';
    if ($debug) {
        $h .= "------------------------------------\n";
    }
    $h .= "Content-type:  text/xml\n";
    return $h;
}

#------------------------------------------------------------------
# Call this when there's a 404 error
sub error404
{
    my $msg = shift;

    print contentType() .
          "Status: 404 Not found\n\n";
    print errorDocument('error', $msg);
    exit 0;
}

#------------------------------------------------------------------
sub redirect303
{
    my ($msg, $uri) = @_;

    print contentType() .
          "Status: 303 See other\n" .
          "Location: $uri\n\n";
    print errorDocument('redirect', $msg);
    exit 0;
}

#------------------------------------------------------------------
sub error502
{
    my $msg = shift;

    print contentType() .
          "Status: 502 Bad gateway\n\n";
    print errorDocument('error', $msg);
    exit 0;
}



#------------------------------------------------------------------
# errorDocument
# This uses XML::LibXML to create an XML document for output.  It is only called
# when needed (like for error handlers) because normally, the XML output is generated
# directly with the XML::LibXSLT transform.  The root element of this is always
# "response".

sub errorDocument
{
    my ($status, $msg) = @_;

    my $doc = XML::LibXML::Document->new('1.0', 'utf-8');
    my $response = $doc->createElement('response');
    $doc->setDocumentElement($response);
    $response->setAttribute('status', $status);
    $response->appendText($msg);
    return $doc->toString();
}
