<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright (c) 2014, Silvio Peroni <essepuntato@gmail.com>

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
<!-- 
    ### IRI SCHEME ###
    This XSLT defines and implements a scheme for all the IRIs of entities we want to
    explicitly specify in the translation of JATS article into OWL (based on SPAR + BioTea)
-->
<!DOCTYPE xsl:stylesheet [
    <!ENTITY pmc "http://rdf.ncbi.nlm.nih.gov/pmc/">
    <!ENTITY doi "http://dx.doi.org/">
    <!ENTITY nlmcat "http://rdf.ncbi.nlm.nih.gov/nlmcatalog/">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://www.essepuntato.it/xslt/functions/"
    exclude-result-prefixes="xs f"
    version="2.0">
    
    <!-- FUNCTION: getArticleIRIWork -->
    <xsl:function name="f:getArticleIRIWork" as="xs:anyURI?">
        <xsl:param name="element" as="element()?" />
        <xsl:variable name="context" select="
            ($element//ancestor-or-self::article[1]//article-meta)[1]//article-id[@pub-id-type='pmc']" as="element()*" />
        <xsl:choose>
            <xsl:when test="exists($context)">
                <xsl:value-of select="concat('&pmc;',normalize-space($context[1]))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="error((),'No IRI has been generated for the article (FRBR Work).')" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- FUNCTION: getArticleIRIExpression -->
    <!-- ISSUES:
        * What is the value of the attribute @pub-id-type to identify the PMC version identifier?
        * What is the URL to use if we do not have any PMC version identifier?
        * If both DOI and PMC version, do I use the former or the latter?
    -->
    <xsl:function name="f:getArticleIRIExpression" as="xs:anyURI?">
        <xsl:param name="element" as="element()" />
        <xsl:variable name="context" select="
            ($element//ancestor-or-self::article[1]//article-meta)[1]//article-id[@pub-id-type='doi']" 
            as="element()*" />
        <xsl:choose>
            <xsl:when test="exists($context)">
                <xsl:value-of select="concat('&doi;',normalize-space($context[1]))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="error((),'No IRI has been generated for the article (FRBR Work).',$element)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- FUNCTION: getJournalIRI -->
    <xsl:function name="f:getJournalIRI" as="xs:anyURI?">
        <xsl:param name="element" as="element()" />
        <xsl:variable name="context" select="
            ($element//ancestor-or-self::article[1]//journal-meta)[1]//journal-id[@journal-id-type='nlm-journal-id'],
            ($element//ancestor-or-self::article[1]//journal-meta)[1]//issn[@pub-type='ppub'],
            ($element//ancestor-or-self::article[1]//journal-meta)[1]//issn[@pub-type='epub'],
            ($element//ancestor-or-self::article[1]//journal-meta)[1]//issn,
            ($element//ancestor-or-self::article[1]//journal-meta)[1]//journal-title" 
            as="element()*" />
        <xsl:choose>
            <xsl:when test="exists($context)">
                <xsl:choose>
                    <xsl:when test="$context[1][self::issn]">
                        <xsl:value-of select="
                            concat(
                                f:getArticleIRIExpression($element),
                                '/journal/issn/',
                                string-join(tokenize(lower-case(normalize-space($context[1])),' '),'-'))" />
                    </xsl:when>
                    <xsl:when test="$context[1][self::journal-title]">
                        <xsl:value-of select="
                            concat(
                                f:getArticleIRIExpression($element),'/journal/name/',f:normalise($context[1]))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('&nlmcat;',normalize-space($context[1]))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="error((),'No IRI has been generated for the journal.',$element)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- FUNCTION: getJournalVolumeIRI -->
    <xsl:function name="f:getJournalVolumeIRI" as="xs:anyURI?">
        <xsl:param name="element" as="element()" />
        <xsl:variable name="context" select="f:getJournalVolumeSequence($element)" as="element()*" />
        <xsl:choose>
            <xsl:when test="exists($context)">
                <xsl:value-of select="concat(f:getJournalIRI($element),'/',normalize-space($context[1]))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="error((),'No IRI has been generated for the journal volume.',$element)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!-- Accompanying functions: getJournalVolumeSequence, doesJournalVolumeExist -->
    <xsl:function name="f:getJournalVolumeSequence" as="element()*">
        <xsl:param name="element" as="element()" />
        <xsl:sequence select="
            ($element//ancestor-or-self::article[1]//article-meta)[1]//volume" />
    </xsl:function>
    <xsl:function name="f:doesJournalVolumeExist" as="xs:boolean">
        <xsl:param name="element" as="element()" />
        <xsl:choose>
            <xsl:when test="f:getJournalVolumeSequence($element)">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- FUNCTION: getJournalIssueIRI -->
    <xsl:function name="f:getJournalIssueIRI" as="xs:anyURI?">
        <xsl:param name="element" as="element()" />
        <xsl:variable name="context" select="f:getJournalIssueSequence($element)" 
            as="element()*" />
        <xsl:choose>
            <xsl:when test="exists($context)">
                <xsl:value-of select="concat(f:getJournalVolumeIRI($element),'/',normalize-space($context[1]))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="error((),'No IRI has been generated for the journal issue.',$element)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <!-- Accompanying functions: getJournalIssueSequence, doesJournalIssueExist -->
    <xsl:function name="f:getJournalIssueSequence" as="element()*">
        <xsl:param name="element" as="element()" />
        <xsl:sequence select="
            ($element//ancestor-or-self::article[1]//article-meta)[1]//issue" />
    </xsl:function>
    <xsl:function name="f:doesJournalIssueExist" as="xs:boolean">
        <xsl:param name="element" as="element()" />
        <xsl:choose>
            <xsl:when test="f:getJournalIssueSequence($element)">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- FUNCTION: getContributorIRI -->
    <!-- ISSUES:
        * What is the URI in refs?
    -->
    <xsl:function name="f:getContributorIRI" as="xs:anyURI?">
        <xsl:param name="element" as="element()" />
        <xsl:if test="$element">
            <xsl:variable name="context" select="f:getContributorSequece($element)" as="element()*" />
            <xsl:choose>
                <xsl:when test="exists($context)">
                    <xsl:value-of select="concat(f:getArticleIRIWork($element),'/contrib/',f:normalise($context[1]))" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="error((),'No IRI has been generated for the contributor.',$element)" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:function>
    <!-- Accompanying functions: getContributorSequece, doesContributorExist -->
    <xsl:function name="f:getContributorSequece" as="element()*">
        <xsl:param name="element" as="element()" />
        <xsl:sequence select="
            $element[self::name],
            $element[self::contrib]/name" />
    </xsl:function>
    <xsl:function name="f:doesContributorExist" as="xs:boolean">
        <xsl:param name="element" as="element()" />
        <xsl:choose>
            <xsl:when test="f:getContributorSequece($element)" >
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- ISSUES:
        * what to do with references?
    -->
    
    <!-- Supporting functions and templates -->
    <xsl:function name="f:normalise" as="xs:string">
        <xsl:param name="element" as="element()" />
        <xsl:value-of select="tokenize(replace(lower-case(normalize-space($element)),'\.',''),' ')" separator="-" />
    </xsl:function>
    
    <!-- PROTOTYPICAL BODY OF FUNCTIONS
    <xsl:function name="f:[nameOfTheFunction]" as="xs:anyURI?">
        <xsl:param name="element" as="element()" />
        <xsl:if test="$element">
            <xsl:variable name="context" select="[elementToFind]" as="element()*" />
            <xsl:choose>
                <xsl:when test="exists($context)">
                    <xsl:value-of select="concat('&[namespaceToUse];',normalize-space($context[1]))" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="error((),'No IRI has been generated for XXX.')" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="f:does[Object]Exist" as="xs:boolean">
        <xsl:param name="element" as="element()" />
        <xsl:choose>
            <xsl:when test="$element[Object ...]">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="f:get[Object]Sequence" as="element()*">
        <xsl:param name="element" as="element()" />
        <xsl:sequence select="[Object]" />
    </xsl:function>
    -->
</xsl:stylesheet>