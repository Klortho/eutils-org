xquery version "1.0-ml";

xdmp:set-response-content-type("text/xml"),

let $format := xdmp:get-request-field("format")
let $results := xdmp:http-get("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com")[2]

return
  if ($format = 'rdf') then
    xdmp:xslt-invoke("einfo.xsl", document{$results})
  else
    $results

