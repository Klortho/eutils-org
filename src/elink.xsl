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
	  	<xsl:when test="eLinkResult/ERROR">
	  		<response status='error'>
	  			<xsl:text>Error response from NCBI: </xsl:text>
	  			<xsl:value-of select='eLinkResult/ERROR'/>
	  		</response>
	  	</xsl:when>
  		<!-- Check for a "batch mode" response, because we can't handle those -->
  		<xsl:when test='eLinkResult/LinkSet[count(IdList/Id) > 1]'>
  			<response status='error'>
  				<xsl:text>Can't translate elink batch mode responses</xsl:text>
  			</response>
  		</xsl:when>
  		<xsl:when test="eLinkResult">
	  		<xsl:apply-templates/>
	  	</xsl:when>
	  	<xsl:otherwise>
	  		<response status='error'>
	  			<xsl:text>Unexpected results from NCBI</xsl:text>
	  		</response>
	  	</xsl:otherwise>
  	</xsl:choose>
  </xsl:template>
	
	<xsl:template match='eLinkResult'>
    <rdf:RDF>
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>

  <!-- 
  	Set of triples from the links.  Note that not every LinkSet has a child LinkSetDb;
  	ignore those that don't.
  -->
	<xsl:template match='LinkSet[LinkSetDb]'>
  	<!-- The subject of this set of link triples -->
  	<entrez:DbRecord rdf:about='&entrez;{DbFrom}/{IdList/Id}'>
  		
  		<xsl:variable name='linkname' select='string(LinkSetDb/LinkName)'/>
  		<xsl:variable name='dbto' select='string(LinkSetDb/DbTo)'/>
  		
  		<xsl:for-each select="LinkSetDb/Link">
  			<!-- The predicate is based on the link name -->
  			<xsl:element namespace="&entrez;link/" name="{$linkname}">
  				
  				<!-- The object URI is constructed from the DbTo and the Id -->
  				<xsl:attribute name='rdf:resource'>
  					<xsl:value-of select='concat("&entrez;", $dbto, "/", Id)'/>
  				</xsl:attribute>
  			</xsl:element>
  			
  		</xsl:for-each>
  	</entrez:DbRecord>
  </xsl:template>

  <!-- Throw away whitespace and other random stuff -->
  <xsl:template match='text()'/>
</xsl:stylesheet>

