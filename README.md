EutilsRDF
=========

NCBI E-utilities in RDF for the Semantic Web.

This is installed to my staff directory at NCBI, at
[http://www.ncbi.nlm.nih.gov/staff/maloneyc/eutilsrdf/]().

Documentation, including instructions on how to use the service, and a [to do
list](https://github.com/Klortho/EutilsRDF/wiki/To-do) is on
[the wiki](https://github.com/Klortho/EutilsRDF/wiki).  This README page
describes implementation and deployment details.

To discuss or send suggestions, please join the [EutilsRDF Google
group](https://groups.google.com/d/forum/eutilsrdf) (mailing list).

This project is registered with BioPortal
[here](http://bioportal.bioontology.org/projects/257).

## Installation

To install this to a web server, clone the repository to a Unix machine,
and then put a softlink somewhere in your server's URI space to the `src`
directory here.  For example, in [my server's](http://chrismaloney.org)
document root, I have the softlink

    eutils -> ~/git/Klortho/EutilsRDF/src

The scripts use a goofy, NCBI-specific shebang line:

    #!/opt/perl-5.8.8/bin/perl

So, to get it to work on another machine, put a softlink from `/opt/perl-5.8.8`
to `/usr`.

## Testing / debugging

To turn on debugging mode, just set the `$debug` variable to 1.  This causes
it to always return a "text/plain" response, with a dump of environment variables
and other messages.

To test this from the command line, do something like this:

    SCRIPT_NAME=/eutils/einfo.cgi \
    QUERY_STRING=retmode=rdf \
    ./einfo.cgi retmode=rdf


