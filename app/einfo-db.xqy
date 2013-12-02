xquery version "1.0-ml";

xdmp:set-response-content-type("text/xml"),

let $format := xdmp:get-request-field("format")
let $db := xdmp:get-request-field("db")

(:
return 
  <foo>
    $format = {$format}
    $db = {$db}
  </foo>
:)

let $results := xdmp:http-get(
  concat("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?db=", $db)
)[2]

return
  if ($format = 'rdf') then
    xdmp:xslt-invoke("einfo.xsl", document{$results})
  else
    $results
