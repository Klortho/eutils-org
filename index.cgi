#!/opt/perl-5.8.8/bin/perl

use strict;
use warnings;

use FindBin;
use XML::LibXML;
use XML::LibXSLT;


open my $fh, '<', "$FindBin::Bin/tests.xml";
binmode $fh; # drop all PerlIO layers possibly created by a use open pragma
my $testXml = XML::LibXML->load_xml(IO => $fh);

my $xsltProcessor = XML::LibXSLT->new();
my $xsltDoc = XML::LibXML->load_xml(
    location => 'index.xsl',
    no_cdata => 1,
);
my $xslt = $xsltProcessor->parse_stylesheet($xsltDoc);
my $output = $xslt->transform($testXml);

print "Content-type:  text/xml\n\n" .
      $output->serialize();
