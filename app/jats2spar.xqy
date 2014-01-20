xquery version "1.0-ml";
(:
  This runs a JATS journal article through jats2spar.xsl
:)

xdmp:set-response-content-type("text/xml"),

try {
  let $db := "pmc"
  let $id := xdmp:get-request-field("id")
  
  
  let $resp := xdmp:http-get(
    concat("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com&amp;db=pmc", 
           "&amp;id=", $id)
  )
  let $response := $resp[1]
  let $content := $resp[2]
  
  return
    if ($response/code = 200) then
      let $params := map:map()
      let $_put := map:put($params, "db", $db)
      return
        xdmp:xslt-invoke("jats2spar.xsl", document{$content}, $params)
    else
      <error>Oops!</error>
}

catch ($e) {
  <error>{ $e }</error>
}

