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
      <xsl:when test="eInfoResult/ERROR">
        <response status='error'>
          <xsl:text>Error response from NCBI: </xsl:text>
          <xsl:value-of select='eInfoResult/ERROR'/>
        </response>
      </xsl:when>
      <xsl:when test="eInfoResult">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <response status='error'>
          <xsl:text>Unexpected results from NCBI</xsl:text>
        </response>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match='eInfoResult'>
    <rdf:RDF>
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>

  <!--
    einfo database list response
  -->
  <xsl:template match='DbList'>
    <xsl:apply-templates select='DbName'/>
  </xsl:template>
  
  <xsl:template match='DbList/DbName'>
    <entrez:Db rdf:about='&entrez;db/{.}'>
      <entrez:dbName>
        <xsl:value-of select='.'/>
      </entrez:dbName>
    </entrez:Db>
  </xsl:template>

  <!--
    einfo dbinfo (information about a specific database) response
  -->
  <xsl:template match='DbInfo'>
    <xsl:variable name='name' select='DbName'/>
    <entrez:Db rdf:about='&entrez;db/{$name}'>
      <entrez:dbName>
        <xsl:value-of select='$name'/>
      </entrez:dbName>
      <xsl:apply-templates>
        <xsl:with-param name="dbname" select='$name'/>
      </xsl:apply-templates>
    </entrez:Db>
  </xsl:template>
  
  <xsl:template match='MenuName'>
    <entrez:menuName>
      <xsl:value-of select='.'/>
    </entrez:menuName>
  </xsl:template>
  
  <xsl:template match='Description'>
    <entrez:description>
      <xsl:value-of select='.'/>
    </entrez:description>
  </xsl:template>
  
  <xsl:template match='DbBuild'>
    <entrez:dbBuild>
      <xsl:value-of select='.'/>
    </entrez:dbBuild>
  </xsl:template>
  
  <xsl:template match='Count'>
    <entrez:count>
      <xsl:value-of select='.'/>
    </entrez:count>
  </xsl:template>
  
  <xsl:template match='LastUpdate'>
    <!-- FIXME:  convert this into a proper date format -->
    <entrez:lastUpdated>
      <xsl:value-of select='.'/>
    </entrez:lastUpdated>
  </xsl:template>
  
  <xsl:template match='FieldList'>
    <xsl:param name='dbname'/>
    <xsl:apply-templates>
      <xsl:with-param name='dbname' select='$dbname'/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match='Field'>
    <xsl:param name='dbname'/>
    <xsl:variable name='fieldname' select='Name'/>
    <entrez:hasField>
      <entrez:Field rdf:about='&entrez;db/{$dbname}/fields/{$fieldname}'>
        <xsl:apply-templates/>
      </entrez:Field>
    </entrez:hasField>
  </xsl:template>  

  <xsl:template match='FullName'>
    <entrez:fullName>
      <xsl:value-of select="."/>
    </entrez:fullName>
  </xsl:template>

  <!-- non-negative integer -->
  <xsl:template match='TermCount'>
    <entrez:termCount>
      <xsl:value-of select="."/>
    </entrez:termCount>
  </xsl:template>
  
  <!-- boolean "N" or "Y" -->
  <xsl:template match='IsDate'>
    <entrez:isDate>
      <xsl:value-of select="."/>
    </entrez:isDate>
  </xsl:template>
  
  <!-- boolean "N" or "Y" -->
  <xsl:template match='IsNumerical'>
    <entrez:isNumerical>
      <xsl:value-of select="."/>
    </entrez:isNumerical>
  </xsl:template>
  
  <!-- boolean "N" or "Y" -->
  <xsl:template match='SingleToken'>
    <entrez:singleToken>
      <xsl:value-of select="."/>
    </entrez:singleToken>
  </xsl:template>
  
  <!-- boolean "N" or "Y" -->
  <xsl:template match='Hierarchy'>
    <entrez:isHierarchy>
      <xsl:value-of select="."/>
    </entrez:isHierarchy>
  </xsl:template>
  
  <!-- boolean "N" or "Y" -->
  <xsl:template match='IsHidden'>
    <entrez:isHidden>
      <xsl:value-of select="."/>
    </entrez:isHidden>
  </xsl:template>
  
  <xsl:template match='LinkList'>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match='Link'>
    <xsl:variable name='linkname' select='Name'/>
    <entrez:hasLink>
      <entrez:Link rdf:about='&entrez;link/{$linkname}'>
        <xsl:apply-templates/>
      </entrez:Link>
    </entrez:hasLink>
  </xsl:template>  
  
  <!-- Throw away whitespace and other random stuff -->
  <xsl:template match='text()'/>

</xsl:stylesheet>

