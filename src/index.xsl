<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">
	
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
			<body>
				<h1>EutilsRDF Service</h1>
				<p>
					Welcome!
				</p>
				<p>
					This is an installation of the
					<a href='https://github.com/Klortho/EutilsRDF'>EutilsRDF project</a>.
					See the <a href='https://github.com/Klortho/EutilsRDF/wiki'>documentation</a>
					for information on how to use it.
				</p>
				<h2>Sample links</h2>
				<p>These sample links are pulled from the tests.xml file, and could be used for
				  automated testing, if we ever get that far.</p>
				<table border='1'>
					<tr>
						<th>URL</th>
						<th>Result</th>
						<th>Description</th>
					</tr>
					<xsl:apply-templates select='//test[@sample="yes"]'/>
				</table>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match='test'>
		<tr>
			<td>
				<a href='http://chrismaloney.org/eutils/{cfm-url}'>
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
						<a href='{eutils-rdf}'>Eutils</a>
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