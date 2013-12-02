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
        <title>Eutils.org Service</title>
        <meta name="DC.language" scheme="ISO 639-2/T" content="eng" />
        <meta name="DC.publisher" content="Chris Maloney" />
        <meta name="DC.creator" content="Chris Maloney" />
        <meta name="Author" content="Chris Maloney" />
        <meta name="DC.title"
          content="Eutils.org Service" />
        <meta name="keywords"
          content="Open Source, GitHub, NCBI, E-utilities
          RDF, Semantic Web, REST, API" />
        <link rel="stylesheet" type="text/css" href="style.css" />
        <link rel="shortcut icon" type="image/png" href="er-icon.png" />  </head>
      <body style='margin-left: 10%; margin-right: 10%'>
        <h1>Eutils.org Service</h1>
        <p>
          This site hosts a RESTful interface to NCBI's Entrez Utilities (E-utilities).
          In it's present state, it is the combination of two project:
        </p>
        <ol>
          <li>An effort to provide an RDF output format for E-utilities (started by
            Chris Maloney), and</li>
          <li>A proof-of-concept to provide a RESTful interface (designed and led by
            Mark Johnson).</li>
        </ol>
        <p>
          This is an installation of the
          <a href='https://github.com/Klortho/eutils-org'>eutils-org project</a> (GitHub).
          This is just in the proof-of-concept stage; there is very little in the way of
          useful data right now.
        </p>
        <p>
          See the <a href='https://github.com/Klortho/eutils-org/wiki'>documentation</a>
          on the GitHub wiki, for information on what it is and how to use it, and an
          all-important to-do list.
        </p>
        <p>
          From here, you can download the
          <a href='entrez-ontology.xml'>Entrez ontology</a>, or access the RDF interface
          to the Entrez Programming utilities (see samples below).
        </p>
        <p>
          The RDF URIs used here conform to the unofficial <a 
          href='https://github.com/Klortho/rdf-uri-resolver/wiki/NCBI-RDF-URI-Standards'>NCBI 
          RDF URI Standards</a>, and are dereferenced, to provide useful RDF data,
          by the <a href='https://github.com/Klortho/rdf-uri-resolver'>rdf-uri-resolver</a>.
        </p>
        
        <p>
          <b><em>
            Note:  the sample links below are out of date.  The two tables below need to
            be combined.
          </em></b>
        </p>
        
        <h2>Sample links</h2>
        <p>These sample links are pulled from the
          <a href='https://github.com/Klortho/eutils-org/blob/master/app/tests.xml'>tests.xml</a> 
          file, and could be used for
          automated testing, if we ever get that far.</p>
        <table border='1'>
          <tr>
            <th>URL</th>
            <th>Result</th>
            <th>Description</th>
          </tr>
          <xsl:apply-templates select='//test[@sample="yes"]'/>
        </table>

        <p>
          In the following table, "RESTful URL"s are relative to the root of this application,
          and "Eutilities URL" are relative to http://eutils.ncbi.nlm.nih.gov/eutils/.          
        </p>
        <table>
          <tr>
            <th>RESTful URL</th>
            <th>Equivalent Eutilities URL (or pipeline)</th>
            <th>Comments</th></tr>
          <tr>
            <td>/</td>
            <td><a href="http://eutils.ncbi.nlm.nih.gov/eutils/einfo.fcgi">einfo.fcgi</a></td>
            <td>What databases are available?</td>
          </tr>
          <tr>
            <td>/pubmed</td>
            <td><a href="http://eutils.ncbi.nlm.nih.gov/eutils/einfo.fcgi?db=pubmed">einfo.fcgi?db=pubmed</a></td>
            <td>Tell me about this database</td>
          </tr>
          <tr>
            <td>/pubmed?term=cat</td>
            <td>esearch pubmed cat | esummary</td>
            <td>Default return type is esummary version 2.0 (report=summary)</td>
          </tr>
          <tr>
            <td>/pubmed?term=cat&amp;report=idlist</td>
            <td><a href="http://eutils.ncbi.nlm.nih.gov/eutils/esearch.fcgi?term=cat">esearch.fcgi?term=cat</a></td>
            <td>Edge case: give me ids</td>
          </tr>
          <tr>
            <td>/pubmed?term=cat&amp;report=full</td>
            <td>esearch pubmed cat | efetch</td>
            <td>Less common case: full record</td>
          </tr>
          <tr>
            <td>/pubmed/24006159</td>
            <td><a href="http://eutils.ncbi.nlm.nih.gov/eutils/esummary.fcgi?db=pubmed&amp;version=2.0&amp;id=24006159">esummary.fcgi?db=pubmed&amp;version=2.0&amp;id=24006159</a></td>
            <td>Again, default type is esummary v2</td>
          </tr>
          <tr>
            <td>/pubmed/ 24006159?report=full</td>
            <td><a href="http://eutils.ncbi.nlm.nih.gov/eutils/efetch.fcgi?db=pubmed&amp;retmode=xml&amp;id=24006159">efetch.fcgi?db=pubmed&amp;retmode=xml&amp;id=24006159</a></td>
            <td>Less common full record</td>
          </tr>
          <tr>
            <td>/pubmed?term=cat&amp;page=2</td>
            <td>esearch pubmed cat | esummary retstart=20 retmax=20</td>
            <td>Note that it returns esummary v2</td>
          </tr>
          <tr>
            <td>/pubmed?term=cat&amp;page=2&amp;report=full</td>
            <td>esearch pubmed cat | efetch retstart=20 retmax=20</td>
            <td>Full records, page 2</td>
          </tr>
          <tr>
            <td>/pubmed?term=cat&amp;page=3&amp;pagesize=10</td>
            <td>esearch pubmed cat | esummary retstart=30 retmax=10</td>
            <td>esummary v2 again</td>
          </tr>
          <tr>
            <td>/pubmed?term=cat&amp;page=5&amp;report=idlist</td>
            <td><a href="http://iwebdev2/staff/mjohnson/proj/eutilities/eutils.cgi?CMD=esearch+pubmed+cat+retstart=100+retmax=20">esearch pubmed cat retstart=100 retmax=20</a></td>
            <td>Note that first line is database, second line is list of IDs. A list of ids without db is meaningless.</td>
          </tr>
          <tr>
            <td>/pubmed/24108202/links/pubmed_pubmed_five</td>
            <td>esearch pubmed 24108202 | elink pubmed_pubmed_five</td>
            <td>Does esummary by default</td>
          </tr>
          <tr>
            <td>/pubmed/24108202/links/pubmed_pubmed_five?report=idlist</td>
            <td>esearch pubmed 24108202 | elink pubmed_pubmed_five</td>
            <td>&#160;</td>
          </tr>
          <tr>
            <td>/pubmed/24108202/links/pubmed_pubmed_five?report=full</td>
            <td>esearch pubmed 24108202 | elink pubmed_pubmed_five | efetch</td>
            <td>&#160;</td>
          </tr>
          <tr>
            <td>/gene/672/links/gene_nuccore</td>
            <td>esearch gene 672 | elink ids gene_nuccore | esummary</td>
            <td>Link returns summaries by default</td>
          </tr>
          <tr>
            <td>/gene/672/links/gene_nuccore?report=full</td>
            <td>esearch gene 672 | elink ids gene_nuccore | efetch</td>
            <td>report=full means "fetch"</td>
          </tr>
          <tr>
            <td>/gene/672/links/gene_nuccore?report=gbwithparts</td>
            <td>esearch gene 672 | elink ids gene_nuccore | efetch - rettype=gbwithparts</td>
            <td>report=gbwithparts means "fetch, rettype=gbwithparts". rettype is no longer necessary; they're just report=.</td>
          </tr>
          <tr>
            <td>/gene/672/links/gene_nuccore_refseqgene?report=fasta&amp;format=text</td>
            <td>esearch gene 672 | elink ids gene_nuccore_refseq_gene | efetch rettype=fasta retmode=text</td>
            <td>This means "the refseqgene FASTA sequence for gene 672."</td>
          </tr>
          <tr>
            <td>/gene/672/links</td>
            <td>(no equivalent)</td>
            <td>List the links available for this record (linkname, dbto, optionally count)</td>
          </tr>
          <tr>
            <td>/pubmed/links</td>
            <td>(no equivalent)</td>
            <td>List all links available for pubmed to other dbs</td>
          </tr>
          <tr>
            <td>/pubmed/field</td>
            <td>(no equivalent)</td>
            <td>Field metadata, subset of einfo</td>
          </tr>
          <tr>
            <td>/links</td>
            <td><a href="http://www.ncbi.nlm.nih.gov/query/static/entrezlinks.html">http://www.ncbi.nlm.nih.gov/query/static/entrezlinks.html</a></td>
            <td>Metadata about all Entrez links</td>
          </tr>
          <tr>
            <td>/pubmed/field/journal</td>
            <td>(no equivalent)</td>
            <td>Index data about field "journal", returns first 20 items.</td>
          </tr>
          <tr>
            <td>/pubmed/field/journal?page=1&amp;pagesize=1000</td>
            <td>(no equivalent)</td>
            <td>Return first 1000 index values</td>
          </tr>
          <tr>
            <td>/pubmed/field/journal?term=Journal+of+the+American</td>
            <td>(no equivalent)</td>
            <td>Search field "journal" for index values containing query string</td>
          </tr>
        </table>
        
        <h2>Return values and format</h2>
        <p>        
        This utility will always return a well formed XML document. 
        Depending on whether or not the script is able to parse and handle the URL,
        it will return one of the following:
        </p>
        <ul>
          <li>
            404 Not found - for cases where it doesn't understand the request, or if the retmode
            is 'rdf' but the service doesn't support the requested transformation.
          </li>
          <li>
            303 See Other redirect to the NCBI Eutilities URL - if the request is not for RDF
            (retmode is not given or is not 'rdf')
          </li>
          <li>
            502 Bad gateway - if this service received a bad response from the NCBI E-utilities.
          </li>
          <li>
            200 OK, with a valid RDF/XML document.
          </li>
        </ul>
        
        

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
