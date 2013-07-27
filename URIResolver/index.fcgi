#!/opt/perl-5.8.8/bin/perl -w
# This is the URIResolver script, as specified here:
# https://confluence.ncbi.nlm.nih.gov/x/Ew9iAQ

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use aliased 'PMC::RDF::UriResolver';

my $resolver = UriResolver->new;
$resolver->run;

