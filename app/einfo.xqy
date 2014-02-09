xquery version "1.0";

declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace request="http://exist-db.org/xquery/request";
declare option exist:serialize "media-type=text/xml";
declare variable $exist:path external;


(:let $format := xdmp:get-request-field("format"):)
let $format := request:get-parameter("format", ())
let $results := doc("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com")

return
(:
  if (true()) then
    <foo>{
      "format = ", $format
      request:attribute-names(),
      "exist:path = ", request:get-attribute("$exist:path")
    }</foo>
:)

  if ($format = 'rdf') then
    transform:transform($results, "einfo.xsl", ())
  else
    $results

