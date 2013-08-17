<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
  <!ENTITY owl "http://www.w3.org/2002/07/owl#">
  <!ENTITY dc "http://purl.org/dc/elements/1.1/">
  <!ENTITY dct "http://purl.org/dc/terms/">
  <!ENTITY bibo "http://purl.org/ontology/bibo/">
  <!ENTITY biotea "http://biotea.idiginfo.org/pubmedOpenAccess/rdf/">
  <!ENTITY doi "http://dx.doi.org/">
  <!ENTITY foaf "http://xmlns.com/foaf/0.1/">
  
  <!ENTITY ncbi "http://rdf.ncbi.nlm.nih.gov/">
  <!ENTITY entrez "&ncbi;entrez/">
  <!ENTITY gene "&ncbi;gene/">
  <!ENTITY nuccore "&ncbi;nuccore/">
  <!ENTITY pmc "&ncbi;pmc/">
  <!ENTITY pubmed "&ncbi;pubmed/">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="&rdf;"
                xmlns:rdfs="&rdfs;"
                xmlns:owl="&owl;"
                xmlns:dc="&dc;"
                xmlns:dct="&dct;"
                xmlns:bibo="&bibo;"
                xmlns:biotea="&biotea;"
                xmlns:doi="&doi;"
                xmlns:foaf="&foaf;"
                xmlns:ncbi="&ncbi;"
                xmlns:entrez="&entrez;"
                xmlns:gene="&gene;"
                xmlns:nuccore="&nuccore;"
                xmlns:pmc="&pmc;"
                version='1.0'>
	
  <xsl:output method='xml' indent='yes'/>
  <xsl:param name="db"/>

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
  	  <xsl:when test='$db != "pmc"'>
  	    <response status='error'>
  	      <xsl:text>Error: So far I only know about PMC docsums, sorry!</xsl:text>
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
  
  <xsl:template match='DocumentSummarySet'>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match='DocumentSummary'>
    <xsl:variable name='pmc-rdf-id'
      select='concat("&pmc;articles/PMC", @uid)'/>
    <rdf:Description rdf:about="{$pmc-rdf-id}">
      <rdf:type rdf:resource="&bibo;Document"/>
      <!-- The following probably is not right in every case; probably depends on the
        document type -->
      <rdf:type rdf:resource="&bibo;AcademicArticle"/>
      
      <dct:identifier>
        <xsl:value-of select='$pmc-rdf-id'/>
      </dct:identifier>
      <owl:sameAs rdf:resource="&biotea;PMC{@uid}"/>

      <rdfs:seeAlso>
        <xsl:value-of select='concat(
            "http://www.ncbi.nlm.nih.gov/pmc/articles/PMC", @uid, "/" 
          )'/>
      </rdfs:seeAlso>
      
      <xsl:apply-templates/>

    </rdf:Description>
  </xsl:template>

  <xsl:template match='ArticleId'>
    <xsl:choose>
      <!-- PMID -->
      <xsl:when test="IdType = 'pmid'">
        <bibo:pmid>
          <xsl:value-of select='Value'/>
        </bibo:pmid>
        
        <!-- Give the pubmed URI with the rdf.ncbi domain, despite the 
          widespread use of the www.ncbi domain in the wild -->
        <dct:identifier>
          <xsl:value-of select='concat("&pubmed;", Value)'/>
        </dct:identifier>
        
        <rdfs:seeAlso>
          <xsl:value-of select='concat("http://www.ncbi.nlm.nih.gov/pubmed/", Value)'/>
        </rdfs:seeAlso>
      </xsl:when>
      
      <!-- DOI -->
      <xsl:when test="IdType = 'doi'">
        <bibo:doi>
          <xsl:value-of select='Value'/>
        </bibo:doi>
        <dct:identifier>
          <xsl:value-of select='concat("doi:", Value)'/>
        </dct:identifier>
        <owl:sameAs rdf:resource="&doi;{Value}"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='Title'>
    <dct:title>
      <xsl:value-of select='.'/>
    </dct:title>
  </xsl:template>

  <xsl:template match='Issue'>
    <bibo:issue><xsl:value-of select='.'/></bibo:issue>
  </xsl:template>
  
  <xsl:template match='Volume'>
    <bibo:volume><xsl:value-of select='.'/></bibo:volume>
  </xsl:template>
  
  <!-- FIXME:  this only handles values in the rigid form "start-end" -->
  <xsl:template match='Pages'>
    <xsl:if test='contains(., "-")'>
      <bibo:pageStart><xsl:value-of select='substring-before(., "-")'/></bibo:pageStart>
      <bibo:pageEnd><xsl:value-of select='substring-after(., "-")'/></bibo:pageEnd>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match='FullJournalName'>
    <dct:isPartOf>
      <bibo:Journal>
        <dct:title>
          <xsl:value-of select='.'/>
        </dct:title>
      </bibo:Journal>
    </dct:isPartOf>
  </xsl:template>

  <xsl:template match='PubDate'>
    <dct:date>
      <xsl:value-of select='.'/>
    </dct:date>
  </xsl:template>
  

  <xsl:template match='Authors'>
    <bibo:authorList rdf:parseType="Collection">
      <xsl:apply-templates/>
    </bibo:authorList>
  </xsl:template>
  
  <xsl:template match='Author'>
    <rdf:Description>
      <foaf:name>
        <xsl:value-of select='Name'/>
      </foaf:name>
    </rdf:Description>
  </xsl:template>
  
  <!-- Throw away whitespace and other random stuff -->
  <xsl:template match='text()'/>
</xsl:stylesheet>

