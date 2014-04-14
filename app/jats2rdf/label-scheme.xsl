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
    ### LABEL SCHEME ###
    This XSLT defines and implements a scheme for all the labels of entities we want to
    explicitly specify in the translation of JATS article into OWL (based on SPAR + BioTea)
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:f="http://www.essepuntato.it/xslt/functions/"
    exclude-result-prefixes="xs f"
    version="2.0">
   
    <!-- FUNCTION: getArticleLabelWork -->
    <xsl:function name="f:getArticleLabelWork" as="xs:string?">
        <xsl:param name="element" as="element()?" />
        <xsl:value-of select="
            concat(normalize-space(($element//ancestor-or-self::article[1]//article-meta)[1]//article-title[1]),' (Work)')" />
    </xsl:function>
    
    <!-- FUNCTION: getArticleLabelExpression -->
    <xsl:function name="f:getArticleLabelExpression" as="xs:string?">
        <xsl:param name="element" as="element()?" />
        <xsl:value-of select="
            concat(normalize-space(($element//ancestor-or-self::article[1]//article-meta)[1]//article-title[1]),' (Expression)')" />
    </xsl:function>
    
    <!-- FUNCTION: getJournalLabel -->
    <xsl:function name="f:getJournalLabel" as="xs:string?">
        <xsl:param name="element" as="element()?" />
        <xsl:value-of select="
            normalize-space(($element//ancestor-or-self::article[1]//journal-meta)[1]//journal-title[1])" />
    </xsl:function>
    
    <!-- FUNCTION: getJournalVolumeLabel -->
    <xsl:function name="f:getJournalVolumeLabel" as="xs:string?">
        <xsl:param name="element" as="element()?" />
        <xsl:variable name="content" select="normalize-space(($element//ancestor-or-self::article[1]//article-meta)[1]//volume[1])" as="xs:string?" />
        <xsl:if test="$content">
            <xsl:value-of select="
                f:getJournalLabel($element), $content" separator=", volume " />
        </xsl:if>
    </xsl:function>
    
    <!-- FUNCTION: getJournalIssueLabel -->
    <xsl:function name="f:getJournalIssueLabel" as="xs:string?">
        <xsl:param name="element" as="element()?" />
        <xsl:variable name="content" select="normalize-space(($element//ancestor-or-self::article[1]//article-meta)[1]//issue[1])" as="xs:string?" />
        <xsl:if test="$content">
            <xsl:value-of select="
                f:getJournalVolumeLabel($element), $content" separator=", issue " />
        </xsl:if>
    </xsl:function>
    
    <!-- FUNCTION: getContributorLabel -->
    <xsl:function name="f:getContributorLabel" as="xs:string?">
        <xsl:param name="element" as="element()?" />
        <xsl:value-of select="
            normalize-space(($element[self::contrib]/name|$element[self::name])[1])" />
    </xsl:function>
   
</xsl:stylesheet>