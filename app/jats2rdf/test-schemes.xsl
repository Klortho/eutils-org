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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://www.essepuntato.it/xslt/functions/"
    exclude-result-prefixes="xs f"
    version="2.0">
    
    <xsl:import href="iri-scheme.xsl"/>
    <xsl:import href="label-scheme.xsl"/>
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes" />
    
    <xsl:template match="/">
        <test>
            <xsl:apply-templates />
        </test>
    </xsl:template>
    
    <xsl:template match="article|article-meta|ref[5]">
        <xsl:call-template name="make-info">
            <xsl:with-param name="iri" select="f:getArticleIRIWork(.),f:getArticleIRIExpression(.)" />
            <xsl:with-param name="iriDesc" select="('Article FRBR Work IRI','Article FRBR Expression IRI')" />
            <xsl:with-param name="label" select="f:getArticleLabelWork(.),f:getArticleLabelExpression(.)" />
        </xsl:call-template>
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="journal-meta|ref[6]|article-meta/volume|article-meta/issue">
        <xsl:call-template name="make-info">
            <xsl:with-param name="iri" select="
                f:getJournalIRI(.),
                if (f:doesJournalVolumeExist(.)) then f:getJournalVolumeIRI(.) else xs:anyURI('NONE'),
                if (f:doesJournalIssueExist(.)) then f:getJournalIssueIRI(.) else xs:anyURI('NONE')" />
            <xsl:with-param name="iriDesc" select="('Journal FRBR Expression IRI','Journal Volume FRBR Expression IRI','Journal Issue FRBR Expression IRI')" />
            <xsl:with-param name="label" select="
                f:getJournalLabel(.),f:getJournalVolumeLabel(.),f:getJournalIssueLabel(.)" />
        </xsl:call-template>
        <xsl:apply-templates />
    </xsl:template>
    
    <!-- The controb in refs should have another URI -->
    <xsl:template match="contrib|ref[5]//name|ref[1]">
        <xsl:call-template name="make-info">
            <xsl:with-param name="iri" select="if (f:doesContributorExist(.)) then f:getContributorIRI(.) else xs:anyURI('NONE')" />
            <xsl:with-param name="iriDesc" select="('Contributor IRI')" />
            <xsl:with-param name="label" select="f:getContributorLabel(.)" />
        </xsl:call-template>
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template name="make-info">
        <xsl:param name="iri" as="xs:anyURI*" />
        <xsl:param name="iriDesc" as="xs:string*" />
        <xsl:param name="label" as="xs:string*" />
        <xsl:variable name="name" select="local-name()" as="xs:string" />
        <xsl:variable name="nodes" as="element()*">
            <xsl:perform-sort select="ancestor-or-self::element()">
                <xsl:sort order="ascending" select="count(ancestor::element())"/>
            </xsl:perform-sort>
        </xsl:variable>
        <xsl:variable name="xpath" select="concat('/',string-join((for $el in $nodes return concat(local-name($el),'[',count($el/preceding-sibling::element()[local-name() = local-name($el)]) + 1,']')),'/'))" as="xs:string" />
            
        <info name="{$name}" xpath="{$xpath}">
            <xsl:for-each select="$iri">
                <xsl:variable name="index" select="position()" as="xs:integer" />
                <xsl:if test="normalize-space() != ''">
                    <iri desc="{$iriDesc[$index]}">
                        <xsl:if test="$label[$index]">
                            <xsl:attribute name="label">
                                <xsl:value-of select="$label[$index]" />
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="." />
                    </iri>
                </xsl:if>
            </xsl:for-each>
        </info>
    </xsl:template>
    
    <xsl:template match="element()">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="text()" />
</xsl:stylesheet>