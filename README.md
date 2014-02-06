Eutils.org Service
=================

NCBI E-utilities, as a RESTful API, and providing RDF for the Semantic Web.

This service is deployed as a proof-of-concept to
[http://eutils.org](http://eutils.org).

Documentation, including instructions on how to use the service, is on the site itself.
This README page describes implementation and deployment details.

This project is registered with BioPortal
[here](http://bioportal.bioontology.org/projects/257).


## To do

See [GitHub issues](https://github.com/Klortho/eutils-org/issues).


## Installation

This is installed to a MarkLogic Server instance, version 7.0, on an Amazon
Machine Instance (AMI).


## Outstanding API design issues

* All of the WebEnv/query_key stuff has been left out. We can do that later if we want.
* Also left out epost
* For queries that would result in URLs longer than 2k, use the "POST/Create/Redirect"
  pattern
* Interaction with user's query history
* EPOST equivalent
* Handling resources with > 1 object type (like dbGaP)
* Is search technology an implementation detail? (rather than /entrez, maybe
  /data/gene/?term=cat&amp;search=entrez|solr, etc.)



## References

* NCBI.  [Entrez Programming Utilities Help](http://www.ncbi.nlm.nih.gov/books/NBK25501/). 2010.

* Biotea: RDFizing PubMed Central in Support for the Paper as an Interface to the Web of Data,
  Garcia Castro, L J; McLaughlin, C; Garcia, A. 2012.

* [From Markup to Linked Data: Mapping NISO JATS v1.0 to RDF using the SPAR (Semantic Publishing
  and Referencing) Ontologies](http://www.ncbi.nlm.nih.gov/books/NBK100491/), Peroni S,
  Lapeyre DA, Shotton D., 2012

* W3C.  [Cool URIs for the Semantic Web](http://www.w3.org/TR/cooluris/). 2008.

* Heath, Tom and Bizer, Christian (2011).
  [Linked Data: Evolving the Web into a Global Data Space](http://linkeddatabook.com/editions/1.0/)
  Accessed: 2013-06-09. ([WebCite](http://www.webcitation.org/6HFldFSR6))

* Berners-Lee, Tim (2006). [Linked Data - Design Issues](http://www.w3.org/DesignIssues/LinkedData.html).
  Accessed: 2013-06-09. ([WebCite](http://www.webcitation.org/6HFgSl1S7))

* [Biohackathon 2013 Wiki pages](https://github.com/dbcls/bh13/wiki) (on GitHub)

* [Identifiers.org](http://identifiers.org/)

* [Resource description framework technologies in
  chemistry](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3118380/) -
  paper by Egon Willighagen


## Archives

There is a paper that describes the first incarnation of the service, the rationale
behind it, and details about how it worked:
[EutilsRDF Web Service: an RDF interface to NCBI Entrez
Utilities](https://github.com/Klortho/eutils-org/raw/master/docs/EutilsRDFWebService.docx).


