<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  <!-- script_url, for example, http://chrismaloney.org/eutils/.
    Let's try to keep it blank (resulting in relative URLs -->
  <xsl:variable name='script_url' select='""'/>

  <xsl:template match='/'>
    <html xml:lang="en">
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>EutilsRDF Service</title>
        <meta name="DC.language" scheme="ISO 639-2/T" content="eng" />
        <meta name="DC.publisher" content="Chris Maloney" />
        <meta name="DC.creator" content="Chris Maloney" />
        <meta name="Author" content="Chris Maloney" />
        <meta name="DC.title"
          content="EutilsRDF Service" />
        <meta name="keywords"
          content="Open Source, GitHub, NCBI, E-utilities
          RDF, Semantic Web" />
        <link rel="stylesheet" type="text/css" href="style.css" />
        <link rel="shortcut icon" type="image/png" href="er-icon.png" />  </head>
      <body style='margin-left: 10%; margin-right: 10%'>
        <h1>EutilsRDF Service</h1>
        <p>
          Welcome!
        </p>
        <p>
          This is an installation of the
          <a href='https://github.com/Klortho/eutilsrdf'>eutilsrdf project</a> (GitHub).
          See the <a href='https://github.com/Klortho/eutilsrdf/wiki'>documentation</a>
          for information on what it is and how to use it.
        </p>
        <h2>Sample links</h2>
        <p>These sample links are pulled from the
          <a href='https://github.com/Klortho/EutilsRDF/blob/master/test/tests.xml'>tests.xml</a> file, and could be used for
          automated testing, if we ever get that far.</p>
        <table border='1'>
          <tr>
            <th>URL</th>
            <th>Result</th>
            <th>Description</th>
          </tr>
          <xsl:apply-templates select='//test[@sample="yes"]'/>
        </table>
        
        <hr style='margin-top: 2em; width: 50%; align: center;'/>
        
        <table style='width: 75%; margin-left: 12%; border:none; vertical-align: top'
               xmlns:dct="http://purl.org/dc/terms/" 
               xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
          <tr>
            <td>
                <a rel="license"
                   href="http://creativecommons.org/publicdomain/zero/1.0/">
                  <img src="cc0.png" 
                       style="border-style: none;" alt="CC0" />
                </a>
            </td>
            <td>
              To the extent possible under law,
              <a rel="dct:publisher"
                 href="http://chrismaloney.org">
                <span property="dct:title">Christopher Maloney</span></a>
              has waived all copyright and related or neighboring rights to
              <em><span property="dct:title">NCBI E-utilities in RDF</span></em>
              and its related site content and source files.
              This work is published from:
              <span property="vcard:Country" datatype="dct:ISO3166"
                    content="US" about="http://chrismaloney.org">
              United States</span>.
            </td>
          </tr>
          <tr>
            <td style='vertical-align: top'>
              <a href='http://www.w3.org/DesignIssues/LinkedData.html'>
                <img src="5star.png" 
                  alt="five star open Web data" />
              </a>
            </td>
            <td>
              Five-star data:
              1. Available on the Web under an open license,
              2. Available as machine-readable structured data,
              3. In an open format,
              4. Uses URIs to identify things,
              5. Linked to other data to provide context.
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match='test'>
    <tr>
      <td>
        <a href='{$script_url}{cfm-url}'>
          <xsl:value-of select='cfm-url'/>
        </a>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test='expected/redirect-to'>
            Redirect to <a href='{expected/redirect-to}'>Eutils</a>
          </xsl:when>
          <xsl:when test='expected/rdf'>
            Good RDF translated from
            <a href='{eutils-url}'>Eutils</a>
          </xsl:when>
          <xsl:when test='expected/error'>
            Error (<xsl:value-of select='expected/error/@status'/>)
          </xsl:when>
        </xsl:choose>
      </td>
      <td>
        <xsl:copy-of select='description/node()'/>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
