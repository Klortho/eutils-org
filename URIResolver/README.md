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

## Testing

Verify that each of these works as expected

* curl -v -L -H "Accept: application/rdf+xml" -o CID2244.rdf \
  http://rdf.ncbi.nlm.nih.gov/pubchem/compound/CID2244

* curl -v -L -H "Accept: text/html" -o CID2244.html \
  http://rdf.ncbi.nlm.nih.gov/pubchem/compound/CID2244 

* curl -v -L -H "Accept: text/turtle" -o CID2244.ttl \
  http://rdf.ncbi.nlm.nih.gov/pubchem/compound/CID2244 
 
* curl -v -L -H "Accept: application/json" -o CID2244.json \
  http://rdf.ncbi.nlm.nih.gov/pubchem/compound/CID2244 

* curl -v -L -H "Accept: text/plain" -o CID2244.ntriples \
  http://rdf.ncbi.nlm.nih.gov/pubchem/compound/CID2244
 
The default is RDF/XML:
 
* curl -v -L -o CID2244 \
  http://rdf.ncbi.nlm.nih.gov/pubchem/compound/CID2244 

