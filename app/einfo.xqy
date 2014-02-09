xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace transform="http://exist-db.org/xquery/transform";
declare option exist:serialize "media-type=text/xml";

let $base_url := 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com'
let $format := request:get-parameter("format", ())
let $results := doc($base_url)

return
  if ($format = 'rdf') then
    transform:transform($results, "einfo.xsl", ())
  else
    $results

