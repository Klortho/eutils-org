EutilsRDF
=========

Project to produce RDF output for some NCBI E-utilities

This is a project being done for the class [The Semantic
Web](https://apps.ep.jhu.edu/course-homepages/3394-605-443-the-semantic-web-cost), at Johns Hopkins,
Summer, 2013.  The following is the project proposal, as recently submitted.

Documentation will on [the GitHub wiki here](https://github.com/Klortho/EutilsRDF/wiki).

To discuss or send suggestions, please join the [EutilsRDF Google
group](https://groups.google.com/d/forum/eutilsrdf).

----

The NCBI E-utilities are a set of APIs that provide programmatic search-and-
retrieval access to
a large set of NCBI databases, including nucleotide and protein sequence
databases (including GenBank), scientific journal article abstract, citation, and
full-text databases (PubMed and PMC), and many others (52 at the time of this
writing).  Currently, E-utilities provides output in a few different formats,
including text and XML, but not in RDF.

## Core idea

In this project, we will create a framework for the enhancement of NCBI
E-utilities to provide an RDF response format.  In this format,
the data from the
NCBI databases will be presented as RDF triples, using a mixture of a
standardized NCBI vocabulary (new URI patterns) and existing
ontologies.

To demonstrate the results, we will create a simple Perl CGI server
that will proxy HTTP requests that mimic the calling convention
(CGI parameters) of E-utilities, send them to NCBI E-utilities to
retrieve XML results, and then pass those results through an XSLT
transformation, to produce RDF.  This is illustrated in the following
figure.

![Block diagram](SemWebProject.png)

Since the E-utilities, and the databases behind them, are vast and
complicated, the scope of this project will be limited to providing the
framework and a small set of samples.

## Scope

In the initial part of this project (already begun) we will work with
people inside and outside of NCBI to develop some simple standards for
RDF URIs for NCBI Entrez database entities (which will be used as
RDF subjects and objects) and Entrez filters and links (which will be
used as RDF predicates).  We will develop these in accordance with current
best practices; for example, those described in "Cool URIs for the
Semantic Web" (2008) and "Linked Data: Evolving the Web into a Global
Data Space" (Heath and Bizer, 2011).

As mentioned above, the scope will be limited to a small set of samples:
at least two, and more if time permits.

* The first sample will be the "by id" variant of the ELink utility (see the
  E-utilities Quick Start,
  [Finding Related Data Through Entrez
  Links](http://www.ncbi.nlm.nih.gov/books/NBK25500/#_chapter1_Finding_Related_Data_Through_En_)),
  for example, [this
  query](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=nuccore&db=gene&id=312836839&id=24475906).
  Note that the "batch mode" response from ELink (for example,
  [here](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=nuccore&db=gene&id=312836839,24475906))
  would not lend itself to conversion to RDF, because, while the response
  indicates a list of "objects" (in the RDF sense), there is no indication
  of which object is associated with which of possibly many subjects.
  This illustrates an important limitation of this project:  that not every
  E-utility request/response is amenable to conversion into RDF.

* The second sample will be the PMC ESummary result, for example, [this
  query](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pmc&id=3159421&version=2.0).
  The ESummary service provides "document summaries", or "docsums" of an entry
  within any Entrez database.  For PMC, the entry is a full-text journal article,
  and the docsum comprises detailed bibliographic information about that article.
  Within the scope of this project will be to transform the PMC docsum output
  into RDF, using, where appropriate, established, standard ontologies, such as
  [Dublin Core](http://dublincore.org/) and [SPAR](http://sempublishing.sourceforge.net/).

Finally, we will deploy a web service, implemented as a Perl CGI script, that
mimics the E-utilities API, and provides valid RDF data for the samples
described above.  It will be extensible, in that others could contribute XSLT
stylesheets for other E-utilities responses, in the form of pull requests on
GitHub, and, if accepted, they would be available in the proxy service.

## Strategy

Here's the plan:

1.  Work with stakeholders to standardize the forms for the relevant
  newly-defined NCBI RDF URIs.  This work has already begun.

2.  Implement and deploy the Entrez proxy / transformer Perl CGI.
  During the development of this project, we’ll be using a continuous
  integration methodology, and so the deployment of the proxy server
  will happen first. Initially, the service will simply reverse-proxy
  most E-utilities requests.  It will also include a simple URL
  dispatching system, to map specific types of E-utilities requests
  to specific XSLT transformations, and an error response handler,
  if the request for an RDF format can’t be fulfilled, because no XSLT
  mapping yet exists for that request.

3.  Provide a transformation of ELink XML into RDF.

4.  Provide a transformation from PMC ESummary into RDF.  This will involve
  identifying ontologies that would be appropriate for use
  with this data.

Insofar as time permits, the following additional steps will also be done:

5.  Integrate this work with outside resources,
  such as (if appropriate) freebase, identifiers.org, BioPortal, and/or
  Bio2RDF, for easier discovery and greater interoperability.

6.  Provide transformations for other types of responses.

## References

* NCBI.  [Entrez Programming Utilities Help](http://www.ncbi.nlm.nih.gov/books/NBK25501/). 2010.

* W3C.  [Cool URIs for the Semantic Web](http://www.w3.org/TR/cooluris/). 2008.

* Heath, Tom and Bizer, Christian (2011).
  [Linked Data: Evolving the Web into a Global Data Space](http://linkeddatabook.com/editions/1.0/)
  Accessed: 2013-06-09. ([WebCite](http://www.webcitation.org/6HFldFSR6))

*  Berners-Lee, Tim (2006). [Linked Data - Design Issues](http://www.w3.org/DesignIssues/LinkedData.html).
  Accessed: 2013-06-09. ([WebCite](http://www.webcitation.org/6HFgSl1S7))

* [Biohackathon 2013 Wiki pages](https://github.com/dbcls/bh13/wiki) (on GitHub)

* [Identifiers.org](http://identifiers.org/)