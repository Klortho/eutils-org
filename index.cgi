#! /usr/bin/env perl

use strict;
use XML::LibXML;
use XML::LibXSLT;


open my $fh, '<', '../test/tests.xml';
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


