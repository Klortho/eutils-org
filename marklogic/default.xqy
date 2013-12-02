xquery version "1.0-ml";

xdmp:set-response-content-type("text/xml"),

(:
  This example demonstrates how to get XML from a web service using
  xdmp:http-get (http://docs.marklogic.com/xdmp:http-get).
  The second node of the response is the payload from the web service.
:)

let $format := xdmp:get-request-field("format")
let $results := xdmp:http-get("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi")[2]

return
  if ($format = 'rdf') then
    xdmp:xslt-invoke("einfo.xsl", document{$results})
  else
    $results

