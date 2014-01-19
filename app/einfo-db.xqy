xquery version "1.0-ml";

xdmp:set-response-content-type("text/xml"),


try {
  let $format := xdmp:get-request-field("format")
  let $db := xdmp:get-request-field("db")
  (:let $base_url := 'http://chrisbaloney.com/einfo-mock.cgi':)
  (:let $base_url := 'http://chrisbaloney.com/einfo-pubmed.xml':)
  let $base_url := 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi'
  (:let $base_url := 'http://127.0.0.1:8009/entrez/eutils/einfo.fcgi':)

  let $results := xdmp:http-get(
    concat($base_url, "?tool=eutils.org&amp;email=voldrani@gmail.com&amp;db=", $db)
  )[2]

  return
    if ($format = 'rdf') then
      xdmp:xslt-invoke("einfo.xsl", document{$results})
    else
      $results
}
catch ($e) {
  <caught-error>{ $e }</caught-error>
}

(:
let $results := xdmp:http-get(
  'http://chrisbaloney.com/einfo-pubmed.xml'
)[2]
:)

