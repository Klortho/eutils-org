<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY biro "http://purl.org/spar/biro/">
  <!ENTITY cito "http://purl.org/spar/cito/">
  <!ENTITY co "http://purl.org/co/">
  <!ENTITY datacite "http://purl.org/spar/datacite/">
  <!ENTITY dc "http://purl.org/dc/elements/1.1/">
  <!ENTITY dcterms "http://purl.org/dc/terms/">
  <!ENTITY deo "http://purl.org/spar/deo/">
  <!ENTITY dqm "http://purl.org/dqm-vocabulary/v1/dqm#">
  <!ENTITY fabio "http://purl.org/spar/fabio/">
  <!ENTITY foaf "http://xmlns.com/foaf/0.1/">
  <!ENTITY frapo "http://purl.org/cerif/frapo/">
  <!ENTITY frbr "http://purl.org/vocab/frbr/core#">
  <!ENTITY lmm "http://ontologydesignpatterns.org/ont/lmm/LMM_L2.owl">
  <!ENTITY literal "http://www.essepuntato.it/2010/06/literalreification/">
  <!ENTITY mediatypes "http://purl.org/NET/mediatypes/">
  <!ENTITY owl "http://www.w3.org/2002/07/owl#">
  <!ENTITY pmc "http://rdf.ncbi.nlm.nih.gov/pmc/vocabulary#">
  <!ENTITY prism "http://prismstandard.org/namespaces/basic/2.0/">
  <!ENTITY pro "http://purl.org/spar/pro/">
  <!ENTITY prov "http://www.w3.org/ns/prov#">
  <!ENTITY pso "http://purl.org/spar/pso/">
  <!ENTITY pubmed "http://rdf.ncbi.nlm.nih.gov/pubmed/vocabulary#">
  <!ENTITY pwo "http://purl.org/spar/pwo/">
  <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
  <!ENTITY scoro "http://purl.org/spar/scoro/">
  <!ENTITY skos "http://www.w3.org/2004/02/skos/core#">
  <!ENTITY swanrel "http://purl.org/swan/2.0/discourse-relationships/">
  <!ENTITY swc "http://data.semanticweb.org/ns/swc/ontology#">
  <!ENTITY swrc "http://swrc.ontoware.org/ontology#">
  <!ENTITY trait "http://contextus.net/ontology/ontomedia/ext/common/trait#">
  <!ENTITY tvc "http://www.essepuntato.it/2012/04/tvc/">
  <!ENTITY vcard "http://www.w3.org/2006/vcard/ns#">
  <!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"

  xmlns:biro="&biro;" 
  xmlns:cito="&cito;"
  xmlns:co="&co;" 
  xmlns:datacite="&datacite;" 
  xmlns:dc="&dc;"
  xmlns:dcterms="&dcterms;"
  xmlns:deo="&deo;" 
  xmlns:dqm="&dqm;" 
  xmlns:fabio="&fabio;" 
  xmlns:foaf="&foaf;"
  xmlns:frapo="&frapo;" 
  xmlns:frbr="&frbr;" 
  xmlns:literal="&literal;" 
  xmlns:lmm="&lmm;"
  xmlns:mediatypes="&mediatypes;" 
  xmlns:owl="&owl;" 
  xmlns:pmc="&pmc;" 
  xmlns:prism="&prism;" 
  xmlns:pro="&pro;"
  xmlns:prov="&prov;"
  xmlns:pso="&pso;" 
  xmlns:pubmed="&pubmed;"
  xmlns:pwo="&pwo;" 
  xmlns:rdf="&rdf;" 
  xmlns:rdfs="&rdfs;"
  xmlns:scoro="&scoro;" 
  xmlns:skos="&skos;" 
  xmlns:swanrel="&swanrel;" 
  xmlns:swc="&swc;"
  xmlns:swrc="&swrc;" 
  xmlns:trait="&trait;" 
  xmlns:tvc="&tvc;" 
  xmlns:vcard="&vcard;"
  xmlns:xsd="&xsd;" 
  xmlns:f="http://www.essepuntato.it/xslt/function/"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  exclude-result-prefixes="xs f xlink xd"
  version="2.0">
  

  <xsl:import href='jats2spar-utils.xsl'/>


</xsl:stylesheet>