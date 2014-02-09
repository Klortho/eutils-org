xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace transform="http://exist-db.org/xquery/transform";
declare option exist:serialize "media-type=text/xml";

let $base_url := 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/einfo.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com'
let $format := request:get-parameter("format", ())

(: Parse the URI path.  It will be '.../data/pmc/<id>'  :)
let $uri := request:get-uri()
let $path-segs := tokenize($uri, "/")
let $data-seg-num := index-of($path-segs, "data")[1]
let $db := $path-segs[$data-seg-num + 1]

let $results := doc(concat($base_url, "&amp;db=", $db))

return
  if ($format = 'rdf') then
    transform:transform($results, "einfo.xsl", ())
  else
    $results

