<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright (c) 2010-2013, Silvio Peroni <essepuntato@gmail.com>
  
  Permission to use, copy, modify, and/or distribute this software for any
  purpose with or without fee is hereby granted, provided that the above
  copyright notice and this permission notice appear in all copies.
  
  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-->
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
  <!ENTITY xd "http://www.oxygenxml.com/ns/doc/xsl">
  <!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:xd="&xd;"

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
  
  <xsl:import href="jats2spar-utils.xsl"/>
  <xsl:import href="jats2spar-meta.xsl"/>
  <xsl:output encoding="UTF-8" indent="yes"/>

  <doc xmlns='&xd;'>
    <desc>
      <h1>Some notes on the architecture of this stylesheet.</h1>
      <p>Parameters and variables that are global are defined in jats2spar-utils.xsl.</p>
      <p>Any values that can change depending on the context are sent through the
        templates as tunnelling parameters.  This includes, for example, $work, even
        though it might seem that there would only ever be one work per JATS document.
        In fact, each sub-article will have it's own work (although, I'm not sure this 
        is the correct way to do it).</p>
    </desc>
  </doc>
  
  <xsl:template match="/">
    <xsl:variable name='content'>
      <xsl:call-template name="goahead">
        <xsl:with-param name="work" select="$this-work" tunnel="yes"/>
        <xsl:with-param name="e" select="$this-expression" tunnel="yes"/>
        <xsl:with-param name="m" select='"_:manifestation"' tunnel="yes"/>
        <xsl:with-param name="issue" select="'periodical-issue'" tunnel="yes"/>
        <xsl:with-param name="collection" select="'conceptual-papers-collection'" tunnel="yes"/>
        <xsl:with-param name="volume" select="$volume" tunnel="yes"/>
        <xsl:with-param name="journal" select="$journal" tunnel="yes"/>
        <xsl:with-param name="s" select="''" tunnel="yes"/>
        <xsl:with-param name="p" select="''" tunnel="yes"/>
        <xsl:with-param name="o" select="''" tunnel="yes"/>
        <xsl:with-param name="p2" select="''" tunnel="yes"/>
        <xsl:with-param name="o2" select="''" tunnel="yes"/>
        <xsl:with-param name="lang" select="''" tunnel="yes"/>
      </xsl:call-template>
    </xsl:variable>
    
    <rdf:RDF>
<!--      <xsl:copy-of select='$content'/>-->
      <xsl:for-each-group select="$content/rdf:Description" group-by="concat(@rdf:about, @rdf:nodeID)">
        <xsl:text>&#10;&#10;</xsl:text>
        <rdf:Description>
          <xsl:choose>
            <xsl:when test="current-group()[1][@rdf:about]">
              <xsl:attribute name='rdf:about'>
                <xsl:value-of select='current-group()[1]/@rdf:about'/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name='rdf:nodeID'>
                <xsl:value-of select='current-group()[1]/@rdf:nodeID'/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select='current-group()/*' mode='group-content'/>
        </rdf:Description>
      </xsl:for-each-group>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match='@*|node()' mode='group-content'>
    <xsl:copy>
      <xsl:apply-templates select='@*|node()' mode='group-content'/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="element()">
    <xsl:call-template name="goahead"/>
  </xsl:template>

  <xsl:template match="text() | attribute() | body | abstract"/>

  <!-- BEGIN - Mapping elements -->
  <xsl:template match="abbrev-journal-title[not(@abbrev-type)]">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasShortTitle'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="$lang" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="address">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:variable name="contact-info" select="concat('contact-info-',$s)"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples" select="($s, 
        'tvc:hasValueInTime', '',
        'rdf:type', '&tvc;ValueInTime',
        'tvc:withinContext', $work,
        'tvc:withValue', $contact-info)"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$contact-info" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&vcard;VCard'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$contact-info" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="addr-line">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="address" select="concat('address-',$s)"/>
    <xsl:if test="not(following-sibling::addr-line)">
      <xsl:variable name="lines" as="xs:string">
        <xsl:value-of select="(., preceding-sibling::addr-line)" separator=", "/>
      </xsl:variable>
      <xsl:call-template name="single">
        <xsl:with-param name="p" select="'vcard:address'" tunnel="yes"/>
        <xsl:with-param name="o" select="$address" tunnel="yes"/>
      </xsl:call-template>
      <xsl:call-template name="single">
        <xsl:with-param name="s" select="$address" tunnel="yes"/>
        <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
        <xsl:with-param name="o" select="'&vcard;Address'" tunnel="yes"/>
      </xsl:call-template>
      <xsl:call-template name="attribute">
        <xsl:with-param name="s" select="$address" tunnel="yes"/>
        <xsl:with-param name="p" select="'vcard:label'" tunnel="yes"/>
        <xsl:with-param name="o" select="$lines" tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- This to prevent affiliations outside contrib will be executed -->
  <xsl:template match="aff | aff-alternatives"/>

  <xsl:template match="xref[@ref-type = 'aff']">
    <xsl:variable name="type" select="@rid"/>
    <xsl:apply-templates select="//aff[@id = $type]" mode="xref"/>
  </xsl:template>

  <xsl:template match="aff[parent::contrib or parent::aff-alternatives]">
    <xsl:call-template name="affiliation"/>
  </xsl:template>

  <xsl:template match="aff-alternatives[parent::contrib]">
    <xsl:call-template name="goahead"/>
  </xsl:template>

  <xsl:template match="aff" mode="xref">
    <xsl:call-template name="affiliation"/>
  </xsl:template>

  <xsl:template match="aff-alternatives" mode="xref">
    <xsl:call-template name="goahead"/>
  </xsl:template>

  <xsl:template name="affiliation">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:variable name="organization" select="concat('organization-', generate-id())"/>
    <xsl:variable name="current-affiliation" 
      select="concat('affiliation-', $organization, '-', $s)"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:withRole', 'scoro:affiliate',
          'pro:relatesToOrganization', $organization,
          'pro:relatesToDocument', $work,
          'dcterms:description', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>

    <xsl:variable name="contact-info" select="concat('contact-info-', $organization)"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($organization,
          'tvc:hasValueInTime', '',
          'rdf:type', '&tvc;ValueInTime',
          'tvc:withinContext', $work,
          'tvc:withValue', $contact-info)"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$contact-info" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&vcard;VCard'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="institution">
        <xsl:call-template name="goahead">
          <xsl:with-param name="s" select="$contact-info" tunnel="yes"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="assert">
          <xsl:with-param name="triples"
            select="($contact-info,
              'vcard:org', '',
              'rdf:type', '&vcard;Organization',
              'vcard:organization-name', 
                concat('&quot;', ., '&quot;', if (@xml:lang) then @xml:lang else ''))"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="alt-title">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'prism:alternateTitle'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="$lang" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="anonymous">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'foaf:name'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="article">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:param name="i" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e, 
          'rdf:type', '&fabio;Expression', 
          'frbr:realizationOf', $work)"/>
    </xsl:call-template>
    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="article-id[not(@pub-id-type)]">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dcterms:identifier'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="goahead"/>
  </xsl:template>

  <xsl:template match="article-title|journal-title">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dcterms:title'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="if (@xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="award-id">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:variable name="agent" select="f:getBlankChildLabel($s, 'funding-agent')"/>
    <xsl:variable name="award" select="f:getBlankChildLabel($s, 'award')"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$agent" tunnel="yes"/>
      <xsl:with-param name="p" select="'frapo:awards'" tunnel="yes"/>
      <xsl:with-param name="o" select="$award" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($award,
          'rdf:type', '&frapo;Grant',
          'frapo:hasGrantNumber', concat('&quot;', ., '&quot;'),
          'frapo:funds',$s)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="award-group">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="investigation"
      select="concat('_:investigation-', count(preceding-sibling::award-group) + 1)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'frapo:isOutputOf'" tunnel="yes"/>
      <xsl:with-param name="o" select="$investigation" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$investigation" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&frapo;Investigation'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$investigation" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="bio">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="bio" select="concat($s,'-biography')"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($bio,
          'frbr:realizationOf', '&fabio;Biography',
          'frbr:partOf', $e,
          'dcterms:description', concat('&quot;', ., '&quot;'),
          'frbr:subject', '',
          'rdf:type', '&foaf;Person')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="chapter-title">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="source" select="concat($e,'-source')"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e,
          'rdf:type', '&fabio;BookChapter',
          'dcterms:title', concat('&quot;',.,'&quot;'),
          'frbr:partOf', $source)"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$source" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Book'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="collab">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'foaf:name'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="if (@xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:call-template>

    <xsl:if test="not(parent::collab-alternatives)">
      <xsl:call-template name="single">
        <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
        <xsl:with-param name="o" select="'&foaf;Group'" tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="collab-alternatives">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&foaf;Group'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead"/>
  </xsl:template>

  <xsl:template match="conference">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="conference" select="concat('conference-', $work)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ConferencePaper'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'swc:relatedToEvent'" tunnel="yes"/>
      <xsl:with-param name="o" select="$conference" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$conference" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'swc:ConferenceEvent'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$conference" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="conf-acronym">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'frapo:hasAcronym'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="conf-date">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'swrc:date'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="conf-name">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'swrc:eventTitle'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="conf-num">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'swrc:number'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="conf-loc">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'swrc:location'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="conf-sponsor">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'swc:hasSponsorship', '',
          'rdf:type', 'swc:Sponsorship',
          'swc:isProvidedBy', '',
          'rdf:type', 'foaf:Organization',
          'foaf:name', .)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="conf-theme">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dcterms:description'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="contrib">
    <xsl:param name="work" tunnel="yes"/>
<!--    <xsl:variable name="agent"
      select="f:getBlankChildLabel($work, concat('agent-', count(preceding-sibling::contrib) + 1))"/>
-->
    <!-- FIXME:  this needs work to take care of all the possible ways that an agent's identifying
      info can appear. -->
    <xsl:variable name='contrib'>
      <xsl:choose>
        <xsl:when test="contrib-id[@contrib-id-type = 'orcid']">
          <xsl:value-of select="contrib-id[@contrib-id-type = 'orcid']"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name='contrib-name'
            select='f:makeSlug(concat((.//surname)[1], "-", (.//given-names)[1]))'/>
          <xsl:value-of select='concat($work, "/contrib/", $contrib-name)'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'dcterms:contributor'" tunnel="yes"/>
      <xsl:with-param name="o" select="$contrib" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$contrib" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&foaf;Agent'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$contrib" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="contrib-id[not(@contrib-id-type)]">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dcterms:identifier'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="copyright-holder">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="agent"
      select="concat('copyright-agent-', count(preceding-sibling::copyright-holder)+1,'-',$e)"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($agent,
          'rdf:type', '&foaf;Agent',
          'foaf:name', concat('&quot;',.,'&quot;'),
          'pro:holdsRoleInTime', '',
          'pro:withRole', '&pro;copyright-owner',
          'pro:relatesToDocument', $e)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="copyright-statement">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dcterms:rights'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="copyright-year">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasCopyrightYear'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="country">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="address" select="concat('address-',$s)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'vcard:address'" tunnel="yes"/>
      <xsl:with-param name="o" select="$address" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$address" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&vcard;Address'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$address" tunnel="yes"/>
      <xsl:with-param name="p" select="'vcard:country-name'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="date-in-citation">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e,
          'literal:hasLiteral', '',
          'rdf:type', '&dcterms;date',
          'literal:hasLiteralValue', concat('&quot;',.,'&quot;'),
          if (@content-type) then 'dcterms:description' else (), 
            if (@content-type) then concat('&quot;',@content-type,'&quot;') else ())"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="degree">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'frapo:hasDegreeSuffix'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="element-citation|mixed-citation">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:variable name="cited-document" select="concat($s,'-',$e)"/>
    <xsl:variable name="cited-work" select="concat($s,'-',$work)"/>

    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'biro:references'" tunnel="yes"/>
      <xsl:with-param name="o" select="$cited-document" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'cito:cites'" tunnel="yes"/>
      <xsl:with-param name="o" select="$cited-document" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="double">
      <xsl:with-param name="s" select="$cited-document" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Expression'" tunnel="yes"/>
      <xsl:with-param name="p2" select="'frbr:realizationOf'" tunnel="yes"/>
      <xsl:with-param name="o2" select="$cited-work" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$cited-document" tunnel="yes"/>
      <xsl:with-param name="e" select="$cited-document" tunnel="yes"/>
      <xsl:with-param name="work" select="$cited-work" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="elocation-id">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e,
          'frbr:embodiment', '',
          'rdf:type', '&fabio;Manifestation',
          'fabio:hasDigitalArticleIdentifier', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="edition">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="source" select="concat($e,'-source')"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$source" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:edition'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'frbr:partOf'" tunnel="yes"/>
      <xsl:with-param name="o" select="$source" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="email">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'vcard:email'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="email[parent::contrib]">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'foaf:mbox'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Temporarily commented to understand how to find out authors from a reference
    <xsl:template match="etal">
        <xsl:param name="e" tunnel="yes" />
        <xsl:call-template name="assert">
            <xsl:with-param name="triples" select="(
                $e,'rdf:type',''
                    'rdf:type','&owl;Restriction',
                    'owl:onProperty','&dcterms;creator',
                    'owl:minCardinality',concat('&quot;',.,'&quot;'))" />
        </xsl:call-template>
    </xsl:template>
    -->

  <xsl:template match="ext-link">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'dcterms:relation'" tunnel="yes"/>
      <xsl:with-param name="o" select="if (@xlink:href) then @xlink:href else ." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="fax">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'vcard:tel', '',
          'rdf:type', '&vcard;Fax',
          'literal:hasLiteralValue', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="funding-source">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:variable name="agent" select="f:getBlankChildLabel($s, 'funding-agent')"/>
    <!--<xsl:variable name="agent" select="concat('funding-agent-',$s)" />-->
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($agent,
          'rdf:type', '&foaf;Agent',
          'foaf:name', concat('&quot;', ., '&quot;'),
          'frapo:funds', $s)"/>
    </xsl:call-template>
    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$agent" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="given-names">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'foaf:givenName'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="if (@xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="p" select="'frapo:givenNameInitial'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="gov">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" tunnel="yes" select="$work"/>
      <xsl:with-param name="p" tunnel="yes" select="'rdf:type'"/>
      <xsl:with-param name="o" tunnel="yes" select="'&fabio;Report'"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" tunnel="yes" select="$e"/>
      <xsl:with-param name="p" tunnel="yes" select="'rdf:type'"/>
      <xsl:with-param name="o" tunnel="yes" select="'&fabio;DocumentReport'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="institution">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'vcard:org', '',
          'rdf:type', '&vcard;Organization',
          'vcard:organization-name', 
            concat('&quot;', ., '&quot;', if (@xml:lang) then @xml:lang else ''),
          if (parent::aff/text()[normalize-space() != '']) then 'vcard:organization-unit' else (), 
            if (parent::aff/text()[normalize-space() != '']) then 
              concat('&quot;', parent::aff/text(), '&quot;', if (@xml:lang) then @xml:lang else '') else ())"
      />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="isbn">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="issue" tunnel="yes"/>
    <xsl:param name="volume" tunnel="yes"/>
    <xsl:variable name="issue" select="concat($issue, '-', $e)"/>
    <!--<xsl:variable name="volume" select="concat($volume,'-',$e)" /> -->

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="(if (//article-meta/issue) then $issue else 
                   if (//article-meta/volume) then $volume else $e,
          'frbr:embodiment', '',
          'rdf:type', '&fabio;Manifestation',
          'prism:isbn', .)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="issn">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'prism:issn'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="issue">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="issue" tunnel="yes"/>
    <xsl:param name="collection" tunnel="yes"/>
    <xsl:variable name="issue" select="concat($issue,'-',$e)"/>
    <xsl:variable name="collection" select="concat($collection,'-',$work)"/>

    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'frbr:partOf'" tunnel="yes"/>
      <xsl:with-param name="o" select="$issue" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($issue,
          'rdf:type', '&fabio;PeriodicalIssue',
          'frbr:realizationOf', $collection,
          'prism:issueIdentifier', .)"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$collection" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;WorkCollection'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$issue" tunnel="yes"/>
      <xsl:with-param name="work" select="$collection" tunnel="yes"/>
      <xsl:with-param name="e" select="$issue" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="issue-id">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="issue" tunnel="yes"/>
    <xsl:variable name="issue" select="concat($issue,'-',$e)"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$issue" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:issueIdentifier'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$issue" tunnel="yes"/>
      <xsl:with-param name="e" select="$issue" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="issue-title">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="issue" tunnel="yes"/>
    <xsl:variable name="issue" select="concat($issue,'-',$e)"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$issue" tunnel="yes"/>
      <xsl:with-param name="p" select="'dcterms:title'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$issue" tunnel="yes"/>
      <xsl:with-param name="e" select="$issue" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="issue-sponsor">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="collection" tunnel="yes"/>
    <xsl:variable name="collection" select="concat($collection, '-', $work)"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($collection,
          'frapo:isFundedBy', '',
          'rdf:type', '&foaf;Agent',
          'foaf:name', .)"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="work" select="$collection" tunnel="yes"/>
      <xsl:with-param name="s" select="$collection" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="issue-part">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="issue" tunnel="yes"/>
    <xsl:variable name="issue" select="concat($issue,'-',$e)"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$issue" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:section'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$issue" tunnel="yes"/>
      <xsl:with-param name="e" select="$issue" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="journal-id[not(@journal-id-type)]">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dcterms:identifier'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="if (@xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="journal-meta">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="issue" tunnel="yes"/>
    <xsl:param name="volume" tunnel="yes"/>
    <xsl:param name="journal" tunnel="yes"/>

    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'frbr:partOf'" tunnel="yes"/>
      <xsl:with-param name="o" select="$journal" tunnel="yes"/>
    </xsl:call-template>

    <xsl:if test="//article-meta/volume">
      <!--<xsl:variable name="volume" select="concat($volume,'-',$e)" />-->
    </xsl:if>

    <xsl:if test="//article-meta/issue">
      <xsl:variable name="issue" select="concat($issue,'-',$e)"/>
    </xsl:if>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($journal,
          'rdf:type', '&fabio;Journal',
          'frbr:realizationOf', '',
          'rdf:type', '&fabio;WorkCollection')"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$journal" tunnel="yes"/>
      <xsl:with-param name="e" select="$journal" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="kwd">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'prism:keyword'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="license[@xlink:href]">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'dcterms:license'" tunnel="yes"/>
      <xsl:with-param name="o" select="@xlink:href" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="name[not(parent::name-alternatives)] |
                       string-name[not(parent::name-alternatives)] |
                       name-alternatives">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:choose>
      <xsl:when test="parent::person-group">
        <xsl:variable name="agent"
          select="concat($s, '-agent-', 
                         count(preceding-sibling::name | preceding-sibling::string-name) + 1)"/>

        <xsl:call-template name="single">
          <xsl:with-param name="p" select="'foaf:member'" tunnel="yes"/>
          <xsl:with-param name="o" select="$agent" tunnel="yes"/>
        </xsl:call-template>
        <xsl:call-template name="single">
          <xsl:with-param name="s" select="$agent" tunnel="yes"/>
          <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
          <xsl:with-param name="o" select="'&foaf;Person'" tunnel="yes"/>
        </xsl:call-template>

        <xsl:call-template name="goahead">
          <xsl:with-param name="s" select="$agent" tunnel="yes"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="single">
          <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
          <xsl:with-param name="o" select="'&foaf;Person'" tunnel="yes"/>
        </xsl:call-template>

        <xsl:call-template name="goahead"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="name[not(parent::name-alternatives)]
                         [parent::mixed-citation or parent::element-citation] | 
                       string-name[not(parent::name-alternatives)]
                         [parent::mixed-citation or parent::element-citation] |
                       name-alternatives[parent::mixed-citation or parent::element-citation]">
    <xsl:param name="work" tunnel="yes"/>

    <xsl:variable name="agent"
      select="concat('reference-', count(ancestor::ref/preceding-sibling::ref) + 1,
                     '-agent-', count(preceding-sibling::name |
                                      preceding-sibling::name-alternatives|
                                      preceding-sibling::string-name) + 1)"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'dcterms:creator'" tunnel="yes"/>
      <xsl:with-param name="o" select="$agent" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$agent" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&foaf;Person'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$agent" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>


  <doc xmlns='&xd;'>
    <desc>
      <p>Page number will produce a manifestation node.</p>
      <p>FIXME:  the manifestation here should be the same as is defined by the print publication
        date.</p>
    </desc>
  </doc>
  <xsl:template match="page-range|fpage|lpage">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, 'page-range')"/>
    
    <!-- This will only produce output when we encounter the last <page-range>, <fpage>, or <lpage> -->
    <xsl:if test="not(following-sibling::page-range | following-sibling::fpage | following-sibling::lpage)">
      <xsl:call-template name="single">
        <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
        <xsl:with-param name="o" select="$me" tunnel="yes"/>
      </xsl:call-template>
      <xsl:if test="preceding-sibling::page-range">
        <xsl:call-template name="single">
          <xsl:with-param name="s" select="$me" tunnel="yes"/>
          <xsl:with-param name="p" select="'prism:pageRange'" tunnel="yes"/>
          <xsl:with-param name="o" select="preceding-sibling::page-range[1]" tunnel="yes"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="preceding-sibling::fpage">
        <xsl:call-template name="single">
          <xsl:with-param name="s" select="$me" tunnel="yes"/>
          <xsl:with-param name="p" select="'prism:startingPage'" tunnel="yes"/>
          <xsl:with-param name="o" select="preceding-sibling::fpage[1]" tunnel="yes"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="preceding-sibling::lpage">
        <xsl:call-template name="single">
          <xsl:with-param name="s" select="$me" tunnel="yes"/>
          <xsl:with-param name="p" select="'prism:endingPage'" tunnel="yes"/>
          <xsl:with-param name="o" select="preceding-sibling::lpage[1]" tunnel="yes"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="part-title">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="source" select="concat($e,'-source')"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e,
          'dcterms:title', concat('&quot;', ., '&quot;'),
          'frbr:partOf', $source)"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$source" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Book'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="patent">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PatentDocument'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasPatentNumber'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="person-group[not(@person-group-type)]">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="group" select="concat('group-',count(preceding::person-group)+1)"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($group,
          'rdf:type', '&foaf;Group',
          'pro:holdsRoleInTime', '',
          'pro:withRole', '&pro;contributor',
          'pro:relatesToDocument', $e)"/>
    </xsl:call-template>

    <xsl:if test="empty(name)">
      <xsl:call-template name="attribute">
        <xsl:with-param name="s" select="$group" tunnel="yes"/>
        <xsl:with-param name="p" select="'foaf:name'" tunnel="yes"/>
        <xsl:with-param name="o" select=".." tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="person-group">
    <xsl:variable name="group" select="concat('group-', count(preceding::person-group) + 1)"/>
    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$group" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="phone">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'vcard:tel', '',
          'rdf:type', '&vcard;Tel',
          'literal:hasLiteralValue', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="prefix">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'foaf:title'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="principal-award-recipient">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:variable name="agent" select="concat('principal-award-recipient-', $s)"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($agent,
          'rdf:type', '&foaf;Agent',
          'foaf:name', concat('&quot;', ., '&quot;'),
          'pro:holdsRoleInTime', '',
          'pro:withRole', '&scoro;funding-recipient',
          'pro:relatesToEntity', $s)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="principal-investigator">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:variable name="agent" select="concat('principal-investigator-', $s)"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($agent,
          'rdf:type', '&foaf;Agent',
          'foaf:name', concat('&quot;', ., '&quot;'),
          'pro:holdsRoleInTime', '',
          'pro:withRole', '&scoro;principal-investigator',
          'pro:relatesToEntity', $s)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="product">
    <xsl:variable name="procuct" select="concat('product-',generate-id())"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'cito:discusses'" tunnel="yes"/>
      <xsl:with-param name="o" select="$procuct" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$procuct" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&owl;Thing'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$procuct" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="publisher | publisher-name[parent::mixed-citation or parent::element-citation]">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="publisher" select="concat('publisher-',$e)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'dcterms:publisher'" tunnel="yes"/>
      <xsl:with-param name="o" select="$publisher" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$publisher" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&foaf;Organization'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="self::publisher-name">
        <xsl:call-template name="attribute">
          <xsl:with-param name="p" select="'foaf:name'" tunnel="yes"/>
          <xsl:with-param name="o" select="." tunnel="yes"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="goahead">
          <xsl:with-param name="s" select="$publisher" tunnel="yes"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="publisher-name">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'foaf:name'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="publisher-loc">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="s" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'tvc:hasValueInTime', '',
          'rdf:type', '&tvc;ValueInTime',
          'tvc:withinContext', $e,
          'tvc:withValue', '',
          'rdf:type', '&vcard;VCard',
          'vcard:addr', '',
          'rdf:type', '&vcard;Address',
          'vcard:locality', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="pub-date|date">
    <xsl:choose>
      <xsl:when test="@date-type">
        <xsl:apply-templates select="@date-type"/>
      </xsl:when>
      <xsl:when test="@publication-format">
        <xsl:apply-templates select="@publication-format"/>
      </xsl:when>
      <xsl:when test="@pub-type">
        <xsl:apply-templates select="@pub-type"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="set-date">
          <xsl:with-param name="p" select="'dcterms:date'" tunnel="yes"/>
          <xsl:with-param name="o" select="'&dcterms;date'" tunnel="yes"/>
          <xsl:with-param name="el" select="."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ref">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="i" select="count(preceding-sibling::ref)+1"/>
    <xsl:variable name="iref" select="concat('reference-item-',$i)"/>
    <xsl:variable name="ref" select="concat('reference-',$i)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'co:item'" tunnel="yes"/>
      <xsl:with-param name="o" select="$iref" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="double">
      <xsl:with-param name="s" select="$iref" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&co;ListItem'" tunnel="yes"/>
      <xsl:with-param name="p2" select="'co:itemContent'" tunnel="yes"/>
      <xsl:with-param name="o2" select="$ref" tunnel="yes"/>
    </xsl:call-template>

    <xsl:if test="following-sibling::ref">
      <xsl:call-template name="single">
        <xsl:with-param name="s" select="$iref" tunnel="yes"/>
        <xsl:with-param name="p" select="'co:nextItem'" tunnel="yes"/>
        <xsl:with-param name="o" select="concat('reference-item-',$i+1)" tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$iref" tunnel="yes"/>
      <xsl:with-param name="p" select="'co:index'" tunnel="yes"/>
      <xsl:with-param name="o" select="xs:string($i)" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$ref" tunnel="yes"/>
      <xsl:with-param name="p" select="'dcterms:bibliographicCitation'" tunnel="yes"/>
      <xsl:with-param name="o" select="normalize-space(.)" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$ref" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&biro;BibliographicReference'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$ref" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="ref-list">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="reference-list" select="concat($e,'-reference-list')"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'frbr:part'" tunnel="yes"/>
      <xsl:with-param name="o" select="$reference-list" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$reference-list" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&biro;ReferenceList'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$reference-list" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="related-article">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="re"
      select="concat('related-','-',count(preceding-sibling::related-article)+1)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:relatedEndeavour'" tunnel="yes"/>
      <xsl:with-param name="o" select="$re" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$re" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Article'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="goahead">
      <xsl:with-param name="e" select="$re" tunnel="yes"/>
      <xsl:with-param name="s" select="$re" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="related-object">
    <xsl:variable name="re"
      select="concat('related-object', '-', count(preceding-sibling::related-object) + 1)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'frbr:relatedEndeavour'" tunnel="yes"/>
      <xsl:with-param name="o" select="$re" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$re" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Expression'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="goahead">
      <xsl:with-param name="e" select="$re" tunnel="yes"/>
      <xsl:with-param name="s" select="$re" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="role">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '',
          'rdf:type', '&pro;Role',
          'rdfs:label', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="role[. = 'editor-in-chief']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&pro;editor-in-chief')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="role[. = 'chief scientist']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&scoro;chief-scientist')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="role[. = 'photographer']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&scoro;photographer')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="role[. = 'research associate']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&scoro;postdoctoral-researcher')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="season">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasSeason'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="self-uri[@xlink:href]">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e,
        'frbr:arrangement', '',
        'rdf:type', '&fabio;Expression',
        'dqm:hasURI', @xlink:href,
        'dcterms:description', .)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="source">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="source" select="concat($e,'-source')"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$source" tunnel="yes"/>
      <xsl:with-param name="p" select="'dcterms:title'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'frbr:partOf'" tunnel="yes"/>
      <xsl:with-param name="o" select="$source" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="std">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;TechnicalStandard'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead"/>
  </xsl:template>

  <xsl:template match="std-organization">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:variable name="organization" select="concat($work,'standard-organization')"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'dcterms:creator'" tunnel="yes"/>
      <xsl:with-param name="o" select="$organization" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($organization,
          'rdf:type', '&foaf;Organization',
          'foaf:name', concat('&quot;',.,'&quot;'),
          'pro:holdsRoleInTime', '',
          'pro:withPro', '&pro;author',
          'pro:relatesToDocument', $work)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="sub-article">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:param name="i" tunnel="yes"/>

    <xsl:variable name="prefix" select="concat('sub',count(preceding::sub-article)+1,'-')"
      as="xs:string"/>
    <xsl:variable name="sw" select="concat($prefix,$work)" as="xs:string"/>
    <xsl:variable name="se" select="concat($prefix,$e)" as="xs:string"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($se,
          'rdf:type', '&fabio;Expression',
          'frbr:realizationOf', $sw,
          'fabio:hasRepresentation', $i,
          'frbr:partOf', $e)"
      />
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$sw" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:partOf'" tunnel="yes"/>
      <xsl:with-param name="o" select="$work" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="goahead">
      <xsl:with-param name="work" select="$sw" tunnel="yes"/>
      <xsl:with-param name="e" select="$se" tunnel="yes"/>
      <xsl:with-param name="s" select="$se" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="subj-group">
    <xsl:param name="s" tunnel="yes"/>

    <xsl:for-each select="subject">
      <xsl:variable name="subject-counting" select="count(preceding::subject) + 1"/>
      <xsl:variable name="subject-uri" select="concat($s, '-term', $subject-counting)"/>
      <xsl:call-template name="single">
        <xsl:with-param name="p" select="'fabio:hasSubjectTerm'" tunnel="yes"/>
        <xsl:with-param name="o" select="$subject-uri" tunnel="yes"/>
      </xsl:call-template>

      <xsl:call-template name="apply">
        <xsl:with-param name="s" select="$subject-uri" tunnel="yes"/>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:if test="subj-group">
      <xsl:for-each select="subject">
        <xsl:variable name="subject-counting" select="count(preceding::subject)+1"/>
        <xsl:variable name="subject-uri" select="concat($s, '-term', $subject-counting)"/>
        <xsl:call-template name="single">
          <xsl:with-param name="s" select="$subject-uri" tunnel="yes"/>
          <xsl:with-param name="p" select="'skos:narrower'" tunnel="yes"/>
          <xsl:with-param name="o" select="concat($s, '-term', count(preceding::subject) + 1)"
            tunnel="yes"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="subject">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;SubjectTerm'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'rdfs:label'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="subtitle|journal-subtitle">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasSubtitle'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="if (@xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="suffix">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'frapo:hasNameSuffix'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="supplementary-material">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="material"
      select="concat('supplementary-information-',count(preceding-sibling::supplementary-material)+1,'-',$e)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'cito:citesAsRelated'" tunnel="yes"/>
      <xsl:with-param name="o" select="$material" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$material" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;SupplementaryInformation'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$material" tunnel="yes"/>
      <xsl:with-param name="e" select="$material" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="surname">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'foaf:familyName'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="if (@xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="p" select="'frapo:givenNameInitial'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="trans-title">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasTranslatedTitle'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="if (@xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="trans-subtitle">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasTranslatedSubtitle'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="lang" select="if (@xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="uri">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dqm:hasURI'" tunnel="yes"/>
      <xsl:with-param name="o" select="if (@xlink:href) then @xlink:href else ." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="volume">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="issue" tunnel="yes"/>
    <xsl:param name="volume" tunnel="yes"/>
    <xsl:variable name="issue" select="concat($issue,'-',$e)"/>
    <!--<xsl:variable name="volume" select="concat($volume,'-',$e)" />-->

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="if (../issue) then $issue else $e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:partOf'" tunnel="yes"/>
      <xsl:with-param name="o" select="$volume" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($volume,
          'rdf:type', '&fabio;PeriodicalVolume',
          'prism:volume', concat('&quot;', ., '&quot;'),
          'frbr:partOf', '',
          'rdf:type', '&fabio;Periodical')"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$volume" tunnel="yes"/>
      <xsl:with-param name="e" select="$volume" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="volume-id">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="volume" tunnel="yes"/>
    <xsl:variable name="volume" select="concat($volume,'-',$e)"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$volume" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:volume'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="goahead">
      <xsl:with-param name="s" select="$volume" tunnel="yes"/>
      <xsl:with-param name="e" select="$volume" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="volume-series">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="volume" tunnel="yes"/>
    <xsl:variable name="volume" select="concat($volume,'-',$e)"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$volume" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasSequenceIdentifier'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="year[parent::element-citation | parent::mixed-citation]">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasPublicationYear'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
      <xsl:with-param name="type" select="'&xsd;'"/>
    </xsl:call-template>

    <xsl:call-template name="goahead"/>
  </xsl:template>
  <!-- END - Mapping elements -->

  <!-- BEGIN - Mapping attributes -->
  <xsl:template match="@abbrev-type">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'fabio:hasShortTitle', '',
          'rdf:type', '&datacite;Identifier',
          'literal:hasLiteralValue', concat('&quot;', .., '&quot;'),
          '&prov;wasAttributedTo', '',
          'rdf:type', '&prov;Agent',
          'rdfs:label', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'abstract']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'rdf:type', '&fabio;Abstract',
          'frbr:summarizationOf', '',
          'rdf:type', '&fabio;Expression')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'addendum']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Addendum'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'announcement']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Announcement'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'article-commentary']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'rdf:type', '&fabio;Comment',
          'cito:discusses', '',
          'rdf:type', '&fabio;Article')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'book-review']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s, 
          'rdf:type','&fabio;BookReview',
          'cito:reviews', '',
          'rdf:type', '&fabio;Book')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'books-received']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($work,
          'rdf:type', '&fabio;NotificationOfReceipt',
          'swanrel:relatesTo', '',
          'rdf:type','&fabio;Book')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'brief-report']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;BriefReport'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'calendar']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;TimeTable'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'case-report']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ReportDocument'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;CaseReport'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'collection']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ExpressionCollection'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'correction']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Correction'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'discussion']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Opinion'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'disertation']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Thesis'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'editorial']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Editorial'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'in-brief']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="issue" tunnel="yes"/>
    <xsl:variable name="issue" select="concat($issue,'-',$e)"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'rdf:type', '&fabio;InBrief',
          'frbr:partOf', $issue,
          'rdf:summarizationOf', '',
          'rdf:type', '&fabio;Article',
          'frbr:partOf', $issue)"
      />
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$issue" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PeriodicalIssue'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'introduction']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&deo;Introduction'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'letter']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Letter'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'meeting-report']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ReportDocument'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;MeetingReport'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'news']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;NewsItem'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'obituary']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Obituary'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'oration']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Oration'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'partial-retraction']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Retraction'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'cito:retracts', '',
          'frbr:partOf', '',
          'rdf:type', '&owl;Thing')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'product-review']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ProductReview'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="double">
      <xsl:with-param name="p" select="'cito:reviews'" tunnel="yes"/>
      <xsl:with-param name="p2" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o2" select="'&owl;Thing'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'rapid-communication']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;RapidCommunication'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'reprint']">
    <xsl:param name="m" tunnel="yes"/>
    <xsl:call-template name="double">
      <xsl:with-param name="s" select="$m" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:reproductionOf'" tunnel="yes"/>
      <xsl:with-param name="p2" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o2" select="'&fabio;Manifestation'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'research-article']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Article'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ResearchPaper'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'retraction']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Retraction'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="double">
      <xsl:with-param name="p" select="'cito:retracts'" tunnel="yes"/>
      <xsl:with-param name="p2" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o2" select="'&owl;Thing'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'review-article']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'rdf:type', '&fabio;ReviewArticle',
          'cito:reviews', '',
          'rdf:type', '&owl;Thing')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@article-type[. = 'translation']">
    <xsl:call-template name="double">
      <xsl:with-param name="p" select="'frbr:translationOf'" tunnel="yes"/>
      <xsl:with-param name="p2" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o2" select="'&fabio;Expression'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@calendar">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:usesCalendar'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@collab-type[. = 'assignee']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&scoro;patent-holder')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@collab-type[. = 'authors']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&pro;author')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@collab-type[. = 'editors']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&pro;editor')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@collab-type[. = 'compilers']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime','',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&pro;compiler')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@collab-type[. = 'guest-editor']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&pro;guest-editor')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@collab-type[. = 'inventors']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&scoro;inventor')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@collab-type[. = 'translators']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&pro;translator')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@contrib-type|@collab-type">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '',
          'rdf:type', '&pro;Role',
          'rdf:label', .)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@contrib-type[. = 'author']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'dcterms:creator'" tunnel="yes"/>
      <xsl:with-param name="o" select="$s" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $work,
          'pro:withRole', '&pro;author')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@contrib-id-type">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'datacite:hasIdentifier', '',
          'rdf:type', '&datacite;Identifier',
          'literal:hasLiteralValue', concat('&quot;', .., '&quot;'),
          'datacite:usesIdentifierScheme', '',
          'rdf:type', '&datacite;IdentifierScheme',
          'rdfs:label', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@contrib-id-type[. = 'ORCID']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'datacite:hasIdentifier', '',
          'rdf:type', '&datacite;Identifier',
          'literal:hasLiteralValue', concat('&quot;', .., '&quot;'),
          'datacite:usesIdentifierScheme', '&datacite;orcid')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@contrib-id-type[. = 'JST']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'datacite:hasIdentifier', '',
          'rdf:type', '&datacite;Identifier',
          'literal:hasLiteralValue', concat('&quot;', .., '&quot;'),
          'datacite:usesIdentifierScheme', '&datacite;jst')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@corresp[. = 'yes']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $e,
          'pro:withRole', '&pro;corresponding-author')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@country">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'frapo:country'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@date-type[. = 'accepted']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="se" select="concat($e,'-',generate-id(..))"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:realization'" tunnel="yes"/>
      <xsl:with-param name="o" select="$se" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$se" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Expression'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$se" tunnel="yes"/>
      <xsl:with-param name="p" select="'dcterms:dateAccepted'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&dcterms;dateAccepted'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:apply-templates select="../@publication-format">
      <xsl:with-param name="e" select="$se" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="@date-type[. = 'corrected']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="se" select="concat($e,'-',generate-id(..))"/>
    <xsl:variable name="date" select="concat('&quot;',f:getDate(..),'&quot;^^',f:getDatetype(..))"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:realization'" tunnel="yes"/>
      <xsl:with-param name="o" select="$se" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasCorrectionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasCorrectionDate'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($se,
          'rdf:type', '&fabio;Expression',
          'frbr:revision', '',
          'rdf:type', '&fabio;Expression')"/>
    </xsl:call-template>
    <xsl:apply-templates select="../@publication-format">
      <xsl:with-param name="e" select="$se" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="@date-type[. = 'preprint']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Preprint'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="set-date">
      <xsl:with-param name="p" select="'fabio:hasDistributionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasDistributionDate'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:apply-templates select="../@publication-format"/>
  </xsl:template>

  <xsl:template match="@date-type[. = 'retracted']">
    <xsl:call-template name="set-date">
      <xsl:with-param name="p" select="'fabio:hasRetractionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasRetractionDate'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:apply-templates select="../@publication-format"/>
  </xsl:template>

  <xsl:template match="@date-type[. = 'received']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="se" select="concat($e,'-',generate-id(..))"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:realization'" tunnel="yes"/>
      <xsl:with-param name="o" select="$se" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$se" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Expression'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$se" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasDateReceived'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasDateReceived'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:apply-templates select="../@publication-format">
      <xsl:with-param name="e" select="$se" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="@date-type[. = 'rev-recd']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="se" select="concat($e,'-',generate-id(..))"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($work,
          'frbr:realization','',
          'rdf:type', '&fabio;Expression',
          'frbr:revision', $se)"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$se" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Expression'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$se" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasDateReceived'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasDateReceived'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:apply-templates select="../@publication-format">
      <xsl:with-param name="e" select="$se" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="@date-type[. = 'rev-request']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasRevisionRequestDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasRevisionRequestDate'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@date-type[. = 'pub']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="$me" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$me" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Manifestation'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$me" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:publicationDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&prism;publicationDate'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:apply-templates select="../@publication-format"/>
  </xsl:template>

  <xsl:template match="@deceased[. = 'yes']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&trait;Dead'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@equal-contrib">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:variable name="contribution"
      select="concat('contribution-',count(../preceding-sibling::contrib[@equal-contrib])+1)"/>
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'scoro:makesContribution'" tunnel="yes"/>
      <xsl:with-param name="o" select="$contribution" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="double">
      <xsl:with-param name="s" select="$contribution" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&scoro;ContributionSituation'" tunnel="yes"/>
      <xsl:with-param name="p2" select="'scoro:hasContributionContext'" tunnel="yes"/>
      <xsl:with-param name="o2" select="$work" tunnel="yes"/>
    </xsl:call-template>

    <xsl:if test="@equal-contrib = 'yes'">
      <xsl:for-each select="../following-sibling::contrib">
        <xsl:if test="@equal-contirb = 'yes'">
          <xsl:variable name="equal-contribution"
            select="concat('contribution-',count(../preceding-sibling::contrib[@equal-contrib])+1)"/>
          <xsl:call-template name="single">
            <xsl:with-param name="s" select="$contribution" tunnel="yes"/>
            <xsl:with-param name="p" select="'scoro:isEqualToContributionSituation'" tunnel="yes"/>
            <xsl:with-param name="o" select="$equal-contribution" tunnel="yes"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@id|@object-id[@object-id-type != 'doi']">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dcterms:identifier'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@initials">
    <xsl:call-template name="attribute">
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@journal-id-type">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'datacite:hasIdentifier', '',
          'rdf:type', '&datacite;Identifier',
          'literal:hasLiteralValue', concat('&quot;', .., '&quot;'),
          'datacite:usesIdentifierScheme', '',
          'rdf:type', '&datacite;IdentifierScheme',
          'rdfs:label', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@journal-id-type[. = ('archive', 'aggregator', 'doaj', 'index', 'pmc', 'publisher-id')]">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'datacite:hasIdentifier', '',
          'rdf:type', '&datacite;Identifier',
          'datacite:usesIdentifierScheme', '&datacite;local-resource-identifier-scheme',
          'literal:hasLiteralValue', concat('&quot;',..,'&quot;'),
          'prov:wasAttributedTo', '',
          'rdf:type', '&prov;Agent',
          'rdf:type', '&foaf;Organization',
          'rdfs:label', f:getLabelForId(.))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@journal-id-type[. = ('doi', 'issn')]">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="concat('prism:', .)" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@journal-id-type[. = 'nlm-journal-id']">
    <xsl:call-template name='attribute'>
      <xsl:with-param name="p" select="'fabio:hasNationalLibraryOfMedicineJournalId'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@journal-id-type[. = 'nlm-ta']">
    <xsl:call-template name='attribute'>
      <xsl:with-param name="p" select="'fabio:hasNLMJournalTitleAbbreviation'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@journal-id-type[. = 'pubmed-jr-id']">
    <xsl:call-template name='attribute'>
      <xsl:with-param name="p" select="'pubmed:journalId'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
    <xsl:template match="@mimetype">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e,
          'frbr:embodiment', '',
          'rdf:type', '&fabio;DigitalManifestation',
          'dcterms:format',
            concat('&mediatypes;', .,
                   if (../@mime-subtype) then concat('/',../@mime-subtype) else ''))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@object-id-type[. = 'doi']">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'prism:doi'" tunnel="yes"/>
      <xsl:with-param name="o" select="../@object-id" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@person-group-type[. = ('translator', 'translators')]">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'rdf:type', '&foaf;Group',
          'pro:holdsRoleInTime', '',
          'pro:withRole', '&pro;translator',
          'pro:relatesToDocument', $e)"/>
    </xsl:call-template>

    <xsl:if test="empty(../name)">
      <xsl:call-template name="attribute">
        <xsl:with-param name="p" select="'foaf:name'" tunnel="yes"/>
        <xsl:with-param name="o" select=".." tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@person-group-type[. = ('author','authors')]">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'rdf:type','&foaf;Group',
          'pro:holdsRoleInTime','',
          'pro:withRole','&pro;author',
          'pro:relatesToDocument',$e)"/>
    </xsl:call-template>

    <xsl:if test="empty(../name)">
      <xsl:call-template name="attribute">
        <xsl:with-param name="p" select="'foaf:name'" tunnel="yes"/>
        <xsl:with-param name="o" select=".." tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@person-group-type">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'rdf:type', '&foaf;Group',
          'pro:holdsRoleInTime', '',
          'pro:relatesToDocument', $e,
          'pro:withRole', '',
          'rdf:type', '&pro;Role',
          'rdfs:label', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>

    <xsl:if test="empty(../name)">
      <xsl:call-template name="attribute">
        <xsl:with-param name="p" select="'foaf:name'" tunnel="yes"/>
        <xsl:with-param name="o" select=".." tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@product-type[. = 'book']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Book'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@product-type[. = 'software']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ComputerProgram'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@product-type[. = 'article']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Article'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@product-type[. = 'issue']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PeriodicalIssue'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@product-type[. = 'website']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;WebSite'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@product-type[. = 'film']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Film'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@product-type">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
        'rdf:type', '',
        'rdf:type', '&owl;Class',
        'rdfs:label', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="@publication-format">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="set-manifestation-date">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Manifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($me,
          'dcterms:format', '',
          'rdf:type', '&dcterms;MediaTypeOrExtent',
          'rdfs:label', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-format[. = 'print']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="set-manifestation-date">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PrintObject'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-format[. = 'electronic']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="set-manifestation-date">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;DigitalManifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-format[. = 'book']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Book'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-manifestation-date">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;DigitalManifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-format[. = 'video']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;MovingImage'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-manifestation-date">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasManifestation'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Manifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-format[. = 'audio']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;SoundRecording'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-manifestation-date">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasManifestation'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Manifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-format[. = 'online']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="set-manifestation-date">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;DigitalManifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($me,
          'frbr:exemplar', '',
          'rdf:type', '&fabio;ComputerFile',
          'fabio:isStoredOn', '&fabio;internet')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-format[. = 'web']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="set-manifestation-date">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;DigitalManifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($me,
          'frbr:exemplar', '',
          'rdf:type', '&fabio;ComputerFile',
          'fabio:isStoredOn', '&fabio;web')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type[. = 'book']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Book'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type[. = 'letter']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Letter'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type[. = 'journal']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;JournalArticle'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type[. = 'confproc']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ConferencePaper'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type[. = 'patent']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PatentDocument'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type[. = 'report']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;ReportDocument'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type[. = 'standard']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Specification'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type[. = 'working-paper']">
    <xsl:call-template name="single">
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;WorkingPaper'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@publication-type">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e,
          'rdf:type', '',
          'rdf:type', '&owl;Class',
          'rdfs:label', concat('&quot;', ., '&quot;'),
          'rdfs:subClassOf','&fabio;Expression')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'art-access-id']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'datacite:hasIdentifier', '',
          'rdf:type', '&datacite;Identifier',
          'datacite:usesIdentifierScheme', '&datacite;local-resource-identifier-scheme',
          'literal:hasLiteralValue', concat('&quot;',..,'&quot;'),
          'prov:wasAttributedTo', '',
          'rdf:type', '&prov;Agent',
          'rdfs:label', concat('&quot;', 'An archive', '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'arxiv']">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasArXivId'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'coden']">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasCODEN'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'doi']">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'prism:doi'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'doaj']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'datacite:hasIdentifier', '',
          'rdf:type', '&datacite;Identifier',
          'datacite:usesIdentifierScheme', '&datacite;local-resource-identifier-scheme',
          'literal:hasLiteralValue', concat('&quot;', .., '&quot;'),
          'prov:wasAttributedTo', '',
          'rdf:type', '&prov;Agent',
          'rdfs:label', concat('&quot;', 'DOAJ', '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'isbn']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'frbr:embodiment', '',
          'rdf:type', '&fabio;Manifestation',
          'rdf:type', ..)"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'manuscript']">
    <xsl:call-template name='attribute'>
      <xsl:with-param name="p" select="'pmc:manuscriptId'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'medline']">
    <xsl:param name='work' tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasPubMedId'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'other']">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'dcterms:identifier'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'pii']">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasPII'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'pmcid' or . = 'pmc']">
    <xsl:param name='work' tunnel="yes"/>
    <xsl:variable name="pmcid">
      <xsl:choose>
        <xsl:when test="matches(.., 'PMC\d+')">
          <xsl:value-of select=".."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('PMC', ..)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasPubMedCentralId'" tunnel="yes"/>
      <xsl:with-param name="o" select="$pmcid" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'pmid']">
    <xsl:param name='work' tunnel="yes"/>
    <xsl:call-template name="attribute">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasPubMedId'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'publisher-id']">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
          'datacite:hasIdentifier', '',
          'rdf:type', '&datacite;Identifier',
          'datacite:usesIdentifierScheme', '&datacite;local-resource-identifier-scheme',
          'literal:hasLiteralValue', concat('&quot;', .., '&quot;'),
          'prov:wasAttributedTo', '',
          'rdf:type', '&prov;Agent',
          'rdf:type', '&foaf;Organization',
          'rdfs:label', concat('&quot;', 'A publisher', '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'sici']">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasSICI'" tunnel="yes"/>
      <xsl:with-param name="o" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-id-type[. = 'std-designation']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:call-template name="double">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;TechnicalStandard'" tunnel="yes"/>
      <xsl:with-param name="p2" select="'fabio:hasStandardNumber'" tunnel="yes"/>
      <xsl:with-param name="o2" select=".." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'epub']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="set-manifestation">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;DigitalManifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$me" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:publicationDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&prism;publicationDate'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'ppub']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="set-manifestation">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PrintObject'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$me" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:publicationDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&prism;publicationDate'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'epub-ppub']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="mee" select="concat($m,'-',generate-id(..),'-e')"/>
    <xsl:variable name="mep" select="concat($m,'-',generate-id(..),'-p')"/>

    <xsl:call-template name="set-manifestation">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PrintObject'" tunnel="yes"/>
      <xsl:with-param name="m" select="$mee" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-manifestation">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PrintObject'" tunnel="yes"/>
      <xsl:with-param name="m" select="$mep" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$mee" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:publicationDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&prism;publicationDate'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$mep" tunnel="yes"/>
      <xsl:with-param name="p" select="'prism:publicationDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&prism;publicationDate'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'epreprint']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="ee" select="f:getBlankChildLabel($e, generate-id(..))"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:realization'" tunnel="yes"/>
      <xsl:with-param name="o" select="$ee" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$ee" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Preprint'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-manifestation">
      <xsl:with-param name="s" select="$ee" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;DigitalManifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$me" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasDistributionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasDistributionDate'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'ppreprint']">
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="ee" select="f:getBlankChildLabel($e, generate-id(..))"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:realization'" tunnel="yes"/>
      <xsl:with-param name="o" select="$ee" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$ee" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;Preprint'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-manifestation">
      <xsl:with-param name="s" select="$ee" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PrintObject'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$me" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasDistributionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasDistributionDate'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'ecorrected']">
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasCorrectionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasCorrectionDate'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($work,
          'frbr:realization', '',
          'rdf:type', '&fabio;o;Expression',
          'frbr:revision', '',
          'rdf:type', '&fabio;Expression',
          'frbr:embodiment', '',
          'rdf:type', '&fabio;DigitalManifestation')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'pcorrected']">
    <xsl:param name="work" tunnel="yes"/>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$work" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasCorrectionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasCorrectionDate'" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($work,
          'frbr:realization', '',
          'rdf:type', '&fabio;Expression',
          'frbr:revision', '',
          'rdf:type', '&fabio;Expression',
          'frbr:embodiment', '',
          'rdf:type', '&fabio;PrintObject')"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'eretracted']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($m, generate-id(..))"/>

    <xsl:call-template name="set-manifestation">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;DigitalManifestation'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$me" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasRetractionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasRetractionDate'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pub-type[. = 'pretracted']">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:param name="m" tunnel="yes"/>
    <xsl:variable name="me" select="f:getBlankChildLabel($e, generate-id(..))"/>

    <xsl:call-template name="set-manifestation">
      <xsl:with-param name="s" select="$e" tunnel="yes"/>
      <xsl:with-param name="p" select="'frbr:embodiment'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;PrintObject'" tunnel="yes"/>
      <xsl:with-param name="m" select="$me" tunnel="yes"/>
    </xsl:call-template>

    <xsl:call-template name="set-date">
      <xsl:with-param name="s" select="$me" tunnel="yes"/>
      <xsl:with-param name="p" select="'fabio:hasRetractionDate'" tunnel="yes"/>
      <xsl:with-param name="o" select="'&fabio;hasRetractionDate'" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@rid[parent::contrib and (some $a in //(aff|aff-alternatives) satisfies $a/@id = .)]">
    <xsl:variable name="type" select="."/>
    <xsl:apply-templates select="//(aff|aff-alternatives)[@id = $type]" mode="xref"/>
  </xsl:template>

  <xsl:template match="@seq">
    <xsl:call-template name="attribute">
      <xsl:with-param name="p" select="'fabio:hasSequenceIdentifier'" tunnel="yes"/>
      <xsl:with-param name="o" select="." tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@xml:lang[parent::article]">
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name='language' select='concat($e, "/language")'/>
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($e, 'dcterms:language', $language)"/>
    </xsl:call-template>
    <xsl:call-template name='assert'>
      <xsl:with-param name='triples'
        select="($language,
          'rdf:type', '&dcterms;LinguisticSystem',
          'dcterms:description', concat('&quot;', ., '&quot;', '^^&dcterms;RFC5646'))"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="author-comment">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="work" tunnel="yes"/>
    <xsl:param name="e" tunnel="yes"/>
    <xsl:variable name="comment" select="concat($s,'-comment')"/>
    
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
        'pro:holdsRoleInTime', '',
        'pro:relatesToDocument', $comment,
        'pro:withRole', '&pro;author')"/>
    </xsl:call-template>
    
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($comment,
        'rdf:type', '&fabio;Comment',
        'frbr:partOf', $e,
        'dcterms:creator', $s,
        'dcterms:description', concat('&quot;', ., '&quot;'))"/>
    </xsl:call-template>
  </xsl:template>
  

</xsl:stylesheet>
