EutilsRDF
=========

NCBI E-utilities in RDF for the Semantic Web.

Documentation, including instructions on how to use the service, and a [to do
list](https://github.com/Klortho/EutilsRDF/wiki/To-do) is on
[the wiki](https://github.com/Klortho/EutilsRDF/wiki).  This README page
describes implementation and deployment details.

To discuss or send suggestions, please join the [EutilsRDF Google
group](https://groups.google.com/d/forum/eutilsrdf).

This project is registered with BioPortal
[here](http://bioportal.bioontology.org/projects/257).

# Installation

To install this to a web server, clone the repository to a Unix machine,
and then put a softlink somewhere in your server's URI space to the `src`
directory here.  For example, in [my server's](http://chrismaloney.org)
document root, I have the softlink

    eutils -> ~/git/Klortho/EutilsRDF/src
