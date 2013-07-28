# NCBI RDF URI Resolver

## Configuring / adding redirect rules

Edit the `config.xml` file to add redirect rules.  They are based on
regular expression matches of the URL, and should be self-explanatory.

The `example` project contains some examples:

* [http://rdf.ncbi.nlm.nih.gov/example/1/1234]() redirects to
  [http://rdf.ncbi.nlm.nih.gov/example/target/1.html?id=1234]().
* [http://rdf.ncbi.nlm.nih.gov/example/2/1234]() redirects similarly, but
  the file extension of the target file depends on the http accept header.

## Deploying

Push this to the target directory with 
 
    rsync -av --delete ./ \
      /net/mwebdev2/export/home/web/public/htdocs/rdf

