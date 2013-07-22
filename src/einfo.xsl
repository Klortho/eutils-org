<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY ncbi "http://rdf.ncbi.nlm.nih.gov/">
  <!ENTITY entrez "http://rdf.ncbi.nlm.nih.gov/entrez/">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
                xmlns:entrez='&entrez;'
                version='1.0'>

  <xsl:output method='xml' indent='yes'/>
  
  <xsl:template match='/eInfoResult'>
    <rdf:RDF>
      <xsl:apply-templates select='DbList'/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match='DbList'>
    <xsl:apply-templates select='DbName'/>
  </xsl:template>
  
  <xsl:template match='DbName'>
    <entrez:db rdf:about='&entrez;db/{.}'>
      <rdfs:label>
        <xsl:value-of select='.'/>
      </rdfs:label>
    </entrez:db>
  </xsl:template>

  <!-- Throw away whitespace and other random stuff -->
  <xsl:template match='text()'/>
<!--
  <xsl:template match='@*|node()'>
    <xsl:copy>
      <xsl:apply-templates select='@*|node()'/>
    </xsl:copy>
  </xsl:template>
-->
</xsl:stylesheet>

