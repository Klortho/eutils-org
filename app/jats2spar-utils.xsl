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
  exclude-result-prefixes="xs f xlink xd" 
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

  <!--===================================================================-->
  <!-- Named templates -->
  
  
  <!-- 
    This utility template is used in place of 'apply-templates' in many places.  It recursively
    applies templates, and turns the @xml:lang attribute into a tunneling parameter.

    FIXME:  Question:  wouldn't it be easier to just define a function that finds the nearest
    ancestor @xml:lang, and call that whenever needed?
  -->
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:template name="goahead">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:param name="nodes" select="."/>
    <xsl:apply-templates select="$nodes/attribute()"/>
    <xsl:apply-templates select="$nodes/element()">
      <xsl:with-param name="lang"
        select="if (not($nodes/self::article) and $nodes/@xml:lang) then $nodes/@xml:lang else $lang"
        tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
      <p>assert takes, as the $triples parameter, a sequence of strings like (s, p1, o1, p2, o2, ...), 
        where s is the subject, and the pi, oi pairs are predicates and the objects, and produces a 
        set of statements.  The subject can be either the prefixed name of the URI, or a string
        begining with "_:", which indicates a blank node.  Any object can be either of those, or a
        literal value.  If the object is a literal value, then it should be enclosed in quotes,
        and can have language and type, in the format used in Turtle.
        If oi is an empty string, then a blank node will be produced, and the subsequent predicates
        and objects will be applied to that.</p>
      <p>A typical way to call it is like this:</p>
      <pre>&lt;xsl:with-param name="triples" select="($s, 
    'tvc:hasValueInTime', '',
    'rdf:type', '&tvc;ValueInTime',
    'tvc:withinContext', $w,
    'rdfs:label', concat('&quot;', 'That Seventies Show', '&quot;', '^^xsd:string'),
    'dcterms:description', concat('&quot;', ., '&quot;'))"/&gt;</pre>
    </desc>
  </doc>
  <xsl:template name="assert">
    <xsl:param name="triples" as="xs:string*"/>
    <xsl:param name="prev-subject" as="xs:string*"/>
    <xsl:param name="reification" select="false()" as="xs:boolean"/>
    
    <!-- Go ahead only if we have at least three resources to make the statement -->
    <xsl:if test="count($triples) >= 3">
      <xsl:variable name="subject" select="$triples[1]" as="xs:string"/>
      <xsl:choose>
        <!-- Use the parent description -->
        <xsl:when test="$prev-subject = $subject and not($reification)">
          <xsl:call-template name="create-structure">
            <xsl:with-param name="triples" select="$triples"/>
          </xsl:call-template>
        </xsl:when>
        <!-- Create a new description for the subject -->
        <xsl:otherwise>
          <rdf:Description>
            <!--
              Add either @rdf:about (normally), @rdf:nodeID (if this is a named blank node), or
              nothing (if the subject is a blank node with no name) 
            -->
            <xsl:choose>
              <xsl:when test="starts-with($subject, '_:')">
                <xsl:attribute name="rdf:nodeID">
                  <xsl:value-of select="substring($subject, 3)"/>
                </xsl:attribute>
              </xsl:when>
              <xsl:when test="$subject">
                <xsl:attribute name="rdf:about">
                  <xsl:value-of select="$subject"/>
                </xsl:attribute>
              </xsl:when>
            </xsl:choose>
            <xsl:call-template name="create-structure">
              <xsl:with-param name="triples" select="$triples"/>
            </xsl:call-template>
          </rdf:Description>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
      <p>create-structure is a helper template for assert. This also takes, as 
        the $triples parameter, a sequence of strings like (s, p1, o1, p2, o2, ...).
        It outputs the XML element that encodes the p1-o1 relation, and then
        recursively invokes assert.</p>
    </desc>
  </doc>
  <xsl:template name="create-structure">
    <xsl:param name="triples" as="xs:string*"/>
    
    <xsl:variable name="subject" select="$triples[1]" as="xs:string"/>
    <xsl:variable name="predicate" select="$triples[2]" as="xs:string"/>
    <xsl:variable name="object" select="$triples[3]" as="xs:string"/>
    
    <!-- 
      Create the predicate.  First, check to make sure that it has a valid prefix
      (sanity check).
    -->
    <xsl:variable name="prefix" select='substring-before($predicate, ":")'/>
    <xsl:choose>
      <xsl:when test="not($prefix = $prefixes)">
        <xsl:message> Warning: unrecognized prefix '<xsl:value-of select="$prefix"/>' </xsl:message>
        <!--
          <warning>
            <prefix><xsl:value-of select='$prefix'/></prefix>
            <subject><xsl:copy-of select='$subject'/></subject>
            <predicate><xsl:copy-of select='$predicate'/></predicate>
            <object><xsl:copy-of select='$object'/></object>
            <triples><xsl:value-of select='string-join($triples, ", ")'/></triples>
          </warning>
        -->
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:element name="{$predicate}">
          <xsl:choose>
            <!-- Is the object a literal value? -->
            <xsl:when test="starts-with($object, '&quot;')">
              <xsl:variable name="value"
                select="substring-before(substring-after($object, '&quot;'), '&quot;')"/>
              <xsl:variable name="lang" select="substring-after($object, '@')"/>
              <xsl:variable name="type" select="substring-after($object, '^^')"/>
              <xsl:if test="$lang">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="$lang"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$type">
                <xsl:attribute name="rdf:datatype" select="$type"/>
              </xsl:if>
              <xsl:value-of select="$value"/>
            </xsl:when>
            
            <!-- Create the object as a named blank node, with @rdf:nodeID -->
            <xsl:when test="starts-with($object, '_:')">
              <xsl:attribute name="rdf:nodeID">
                <xsl:value-of select="substring($object, 3)"/>
              </xsl:attribute>
            </xsl:when>
            
            <!-- Create the object as a resource -->
            <xsl:when test="$object">
              <xsl:attribute name="rdf:resource">
                <xsl:value-of select="$object"/>
              </xsl:attribute>
            </xsl:when>
            
            <!-- Create a reification (i.e. the object is an empty string) -->
            <xsl:otherwise>
              <xsl:call-template name="assert">
                <xsl:with-param name="triples" select="('', subsequence($triples, 4))" as="xs:string*"/>
                <xsl:with-param name="prev-subject" select="$subject"/>
                <xsl:with-param name="reification" select="true()"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    
    <!-- If the object exists, create another statement (according to $triples) using the same subject -->
    <xsl:if test="$object">
      <xsl:call-template name="assert">
        <xsl:with-param name="triples" select="($subject, subsequence($triples, 4))" as="xs:string*"/>
        <xsl:with-param name="prev-subject" select="$subject"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
    
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
      <p>The attribute template instantiates a triple whose object is a literal data value.</p>
    </desc>
  </doc>
  <xsl:template name="attribute">
    <xsl:param name="s" as="xs:string" tunnel="yes"/>
    <xsl:param name="p" as="xs:string" tunnel="yes"/>
    <xsl:param name="o" as="xs:string" tunnel="yes"/>
    <xsl:param name="type" as="xs:string" select="''" tunnel="yes"/>
    <xsl:param name="lang" as="xs:string" select="''" tunnel="yes"/>
    
    <xsl:call-template name="assert">
      <xsl:with-param name="triples"
        select="($s,
                 $p, concat('&quot;', $o, '&quot;',
                            if ($lang) then concat('@', $lang) else '', 
                            if ($type) then concat('^^', $type) else ''))"/>
    </xsl:call-template>
  </xsl:template>


  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:template name="date-assert">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="p" tunnel="yes"/>
    <xsl:param name="o" tunnel="yes"/>
    <xsl:param name="date"/>
    <xsl:choose>
      <xsl:when test="@calendar | season">
        <xsl:call-template name="assert">
          <xsl:with-param name="triples"
            select="($s,
            'literal:hasLiteral', '',
            'rdf:type', $o,
            'literal:hasLiteralValue', concat('&quot;', $date, '&quot;'))"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="assert">
          <xsl:with-param name="triples" select="($s, $p, $date)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:template name="double">
    <xsl:param name="s" as="xs:string" tunnel="yes"/>
    <xsl:param name="p" as="xs:string" tunnel="yes"/>
    <xsl:param name="o" as="xs:string" tunnel="yes"/>
    <xsl:param name="p2" as="xs:string" tunnel="yes"/>
    <xsl:param name="o2" as="xs:string" tunnel="yes"/>
    
    <xsl:call-template name="assert">
      <xsl:with-param name="triples" 
        select="($s,
                 $p, $o, 
                 if ($p2 = '') then $p else $p2, $o2)"/>
    </xsl:call-template>
  </xsl:template>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:template name="apply">
    <xsl:param name="lang" tunnel="yes"/>
    <xsl:apply-templates select="attribute()"/>
    <xsl:apply-templates select=".">
      <xsl:with-param name="lang"
        select="if (not(self::article) and @xml:lang) then @xml:lang else $lang" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:template name="set-date">
    <xsl:param name="s" tunnel="yes"/>
    <xsl:param name="p" tunnel="yes"/>
    <xsl:param name="o" tunnel="yes"/>
    <xsl:param name="el" select=".."/>
    <xsl:choose>
      <xsl:when test="$el/(season|@calendar)">
        <xsl:variable name="date" select="concat($s,'-date')"/>
        <xsl:call-template name="single">
          <xsl:with-param name="p" select="'literal:hasLiteral'" tunnel="yes"/>
          <xsl:with-param name="o" select="$date" tunnel="yes"/>
        </xsl:call-template>
        <xsl:call-template name="attribute">
          <xsl:with-param name="p" select="'literal:hasLiteralValue'" tunnel="yes"/>
          <xsl:with-param name="o" select="f:getDate($el)" tunnel="yes"/>
          <xsl:with-param name="type" select="f:getDatetype($el)" tunnel="yes"/>
        </xsl:call-template>
        <xsl:apply-templates select="@calendar|season">
          <xsl:with-param name="s" select="$date" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="attribute">
          <xsl:with-param name="o" select="f:getDate($el)" tunnel="yes"/>
          <xsl:with-param name="type" select="f:getDatetype($el)" tunnel="yes"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:template name="set-manifestation">
    <xsl:param name="m" tunnel="yes"/>
    <!-- current manifestation -->
    <xsl:call-template name="single">
      <xsl:with-param name="s" select="$m" tunnel="yes"/>
      <xsl:with-param name="p" select="'rdf:type'" tunnel="yes"/>
    </xsl:call-template>
    <xsl:if test="../@date-type != 'pub'">
      <xsl:call-template name="single">
        <!-- set Work/Expression relation to the current manifestation -->
        <xsl:with-param name="o" select="$m" tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:template name="set-manifestation-date">
    <xsl:param name="m" tunnel="yes"/>
    <!-- current manifestation -->
    <xsl:call-template name="set-manifestation"/>
    <xsl:if test="empty(../@data-type)">
      <xsl:call-template name="set-date">
        <xsl:with-param name="s" select="$m" tunnel="yes"/>
        <xsl:with-param name="p" select="dcterms:date" tunnel="yes"/>
        <xsl:with-param name="o" select="'&dcterms;date'" tunnel="yes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:template name="single">
    <xsl:param name="s" as="xs:string" tunnel="yes"/>
    <xsl:param name="p" as="xs:string" tunnel="yes"/>
    <xsl:param name="o" as="xs:string" tunnel="yes"/>
    
    <xsl:call-template name="assert">
      <xsl:with-param name="triples" select="($s, $p, $o)"/>
    </xsl:call-template>
  </xsl:template>

  <!--===================================================================-->
  <!-- Functions -->
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
      <p>This function makes a slug from a string, suitable for inserting into a newly
        minted URI.  It converts everything to lowercase, then replaces all special characters
        with spaces, normalizes spaces, converts spaces to '-'.</p>
    </desc>
  </doc>
  <xsl:function name='f:makeSlug' as='xs:string'>
    <xsl:param name='orig' as='xs:string'/>
    <xsl:value-of select='translate(normalize-space(lower-case(
        replace($orig, "[^A-Za-z0-9]", " ")
      )), " ", "-")'/>
  </xsl:function>
  
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:function name="f:getDatetype" as="xs:string">
    <xsl:param name="el" as="element()"/>
    <xsl:choose>
      <xsl:when test="$el/month">
        <xsl:choose>
          <xsl:when test="$el/day">
            <xsl:value-of select="'&xsd;date'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'&xsd;gYearMonth'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'&xsd;gYear'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:function name="f:getDate" as="xs:string">
    <xsl:param name="el" as="element()"/>
    <xsl:variable name="date">
      <xsl:if test="$el/year">
        <xsl:value-of select="$el/year"/>
      </xsl:if>
      <xsl:if test="$el/month">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$el/month"/>
      </xsl:if>
      <xsl:if test="$el/day">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$el/day"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$date"/>
  </xsl:function>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
    </desc>
  </doc>
  <xsl:function name="f:getLabelForId" as="xs:string">
    <xsl:param name="id" as="xs:string"/>
    <xsl:variable name="result" as="xs:string">
      <xsl:choose>
        <xsl:when test="$id = 'archive'">
          <xsl:value-of select="'An archive'"/>
        </xsl:when>
        <xsl:when test="$id = 'aggregator'">
          <xsl:value-of select="'An aggregator'"/>
        </xsl:when>
        <xsl:when test="$id = 'doaj'">
          <xsl:value-of select="'DOAJ'"/>
        </xsl:when>
        <xsl:when test="$id = 'index'">
          <xsl:value-of select="'An indexing service'"/>
        </xsl:when>
        <xsl:when test="$id = 'nlm-ta'">
          <xsl:value-of select="'PubMed'"/>
        </xsl:when>
        <xsl:when test="$id = 'pmc'">
          <xsl:value-of select="'PubMed Central'"/>
        </xsl:when>
        <xsl:when test="$id = 'publisher-id'">
          <xsl:value-of select="'A publisher'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat('&quot;', $result, '&quot;')"/>
  </xsl:function>
  
  <doc xmlns='http://www.oxygenxml.com/ns/doc/xsl'>
    <desc>
      <p>This function generates a new label for a blank node child.  The parent label
        can either be a full http URI or a blank node.
        So, for example, given "_:investigation-1" (the parent) and "funding-agent"
        (a label for the child), this will
        produce "_:funding-agent-investigation-1".</p>
    </desc>
  </doc>
  <xsl:function name="f:getBlankChildLabel" as="xs:string">
    <xsl:param name="parent" as="xs:string"/>
    <xsl:param name="child-label" as="xs:string"/>
    
    <xsl:variable name='p'>
      <xsl:choose>
        <xsl:when test="starts-with($parent, 'http://')">
          <xsl:value-of select='replace(substring-after($parent, "http://"), "/", "-")'/>
        </xsl:when>
        <xsl:when test="starts-with($parent, '_:')">
          <xsl:value-of select="substring($parent, 3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$parent"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select='concat("_:", $child-label, "-", $p)'/>
  </xsl:function>
  
  
  
</xsl:stylesheet>