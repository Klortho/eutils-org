xquery version "1.0";

declare namespace transform="http://exist-db.org/xquery/transform";
declare option exist:serialize "media-type=text/xml";

(:let $format := xdmp:get-request-field("format"):)
let $format := "rdf"
let $results := doc("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com")

return
  if ($format = 'rdf') then
    transform:transform($results, "einfo.xsl", ())
  else
    $results

