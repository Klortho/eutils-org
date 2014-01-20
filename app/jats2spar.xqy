xquery version "1.0-ml";
(:
  This runs a JATS journal article through jats2spar.xsl
:)

xdmp:set-response-content-type("text/xml"),

let $db := "pmc"
let $id := xdmp:get-request-field("id")


let $jats_xml := xdmp:http-get(
  concat("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com&amp;db=pmc", 
         "&amp;id=", $id)
)[2]

return
  let $params := map:map()
  let $_put := map:put($params, "db", $db)
  return
    xdmp:xslt-invoke("jats2spar.xsl", document{$jats_xml}, $params)
    
