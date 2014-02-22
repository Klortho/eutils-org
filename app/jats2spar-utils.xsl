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
  <!ENTITY prism "http://prismstandard.org/namespaces/basic/2.0/">
  <!ENTITY pro "http://purl.org/spar/pro/">
  <!ENTITY prov "http://www.w3.org/ns/prov#">
  <!ENTITY pso "http://purl.org/spar/pso/">
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
  xmlns:prism="&prism;" 
  xmlns:pro="&pro;"
  xmlns:prov="&prov;"
  xmlns:pso="&pso;" 
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
  exclude-result-prefixes="xs f xlink" 
  version="2.0">
  
  <xsl:param name='base-uri' select='"http://rdf.ncbi.nlm.nih.gov/"'/>
  
  <!--
    The full URI of the Semantic Web resource that this JATS document is a representation of,
    if known.  This should be the URI of the FRBR *expression*, which corresponds to, for example,
    a specific article *version*.
    The default is to use a 'blank node', and this option is signalled by using the "_:" prefix
    followed by a text string.  This is translated into the @rdf:nodeID attribute (instead of
    @rdf:about) on <rdf:Description> elements.
  -->
  <xsl:param name="this-expression" select='"_:this-expression"'/>
  
  <!--
    Similarly, this is the URI of the FRBR work, if known.
  -->
  <xsl:param name="this-work" select='"_:this-work"'/>

  <xsl:variable name="prefixes"
    select='tokenize("biro cito co datacite dc dcterms deo dqm fabio foaf frapo frbr literal 
    lmm mediatypes owl prism pro prov pso pwo rdf rdfs scoro skos swanrel 
    swc swrc trait tvc vcard xsd", "\s+")'/>
  
  <xsl:variable name='article' select='//article[1]'/>
  <xsl:variable name='journal-meta' select='$article/front/journal-meta'/>

  <xsl:variable name='journal'>
    <xsl:choose>
      <xsl:when test="$journal-meta/journal-id[@journal-id-type='nlm-journal-id']">
        <xsl:value-of select='concat($base-uri, "nlmcatalog/", 
          $journal-meta/journal-id[@journal-id-type="nlm-journal-id"])'/>
      </xsl:when>
      <xsl:when test='$journal-meta/issn'>
        <xsl:value-of select='concat($this-expression, "/journal/issn/", 
          $journal-meta/issn[1])'/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select='concat($this-expression, "/journal/name/",
          f:makeSlug($journal-meta//journal-title[1]))'/>
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:variable>

  <!-- 
    This function makes a slug from a string, suitable for inserting into a newly
    minted URI.  It converts everything to lowercase, then replaces all special characters
    with spaces, normalizes spaces, converts spaces to '-'.
  -->
  <xsl:function name='f:makeSlug' as='xs:string'>
    <xsl:param name='orig' as='xs:string'/>
    <xsl:value-of select='translate(normalize-space(lower-case(
      replace($orig, "[^A-Za-z0-9]", " ")
      )), " ", "-")'/>
  </xsl:function>
  
  
  
</xsl:stylesheet>