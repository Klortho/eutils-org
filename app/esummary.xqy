xquery version "1.0-ml";

xdmp:set-response-content-type("text/xml"),

let $format := xdmp:get-request-field("format")
let $db := xdmp:get-request-field("db")
let $id := xdmp:get-request-field("id")


let $results := xdmp:http-get(
  concat("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com&amp;db=", $db, 
         "&amp;id=", $id, "&amp;version=2.0")
)[2]

return
  if ($format = 'rdf') then
    let $params := map:map()
    let $_put := map:put($params, "db", $db)
    return
      xdmp:xslt-invoke("esummary.xsl", document{$results}, $params)
  else
    $results
    
