<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
  <!ENTITY owl "http://www.w3.org/2002/07/owl#">
  <!ENTITY dc "http://purl.org/dc/elements/1.1/">
  <!ENTITY ncbi "http://rdf.ncbi.nlm.nih.gov/">
  <!ENTITY entrez "&ncbi;entrez/">
  
  <!ENTITY gene "&ncbi;gene/">
  <!ENTITY nuccore "&ncbi;nuccore/">
  <!ENTITY pmc "&ncbi;pmc/">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="&rdf;"
                xmlns:rdfs="&rdfs;"
                xmlns:owl="&owl;"
                xmlns:dc="&dc;"
                xmlns:ncbi="&ncbi;"
                xmlns:entrez="&entrez;"
                xmlns:gene="&gene;"
                xmlns:nuccore="&nuccore;"
                xmlns:pmc="&pmc;"
                version='1.0'>
	
  <xsl:output method='xml' indent='yes'/>

  <xsl:template match='/'>
  	<!-- Validate the response a bit -->
  	<xsl:choose>
  		<xsl:when test="eSummaryResult/ERROR">
	  		<response status='error'>
	  			<xsl:text>Error response from NCBI: </xsl:text>
	  			<xsl:value-of select='eSummaryResult/ERROR'/>
	  		</response>
	  	</xsl:when>
  		<!-- Version 1 results are no good -->
  		<xsl:when test='eSummaryResult/DocSum'>
  			<response status='error'>
  				<xsl:text>Error: I am not crazy about version 1 esummary results</xsl:text>
  			</response>
  		</xsl:when>
  		<xsl:when test="eSummaryResult">
	  		<xsl:apply-templates/>
	  	</xsl:when>
	  	<xsl:otherwise>
	  		<response status='error'>
	  			<xsl:text>Unexpected results from NCBI</xsl:text>
	  		</response>
	  	</xsl:otherwise>
  	</xsl:choose>
  </xsl:template>
	
	<xsl:template match='eSummaryResult'>
    <rdf:RDF>
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>


  <!-- Throw away whitespace and other random stuff -->
  <xsl:template match='text()'/>
</xsl:stylesheet>

