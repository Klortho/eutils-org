xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace transform="http://exist-db.org/xquery/transform";
declare option exist:serialize "media-type=text/xml";

let $base_url :=
  'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com&amp;version=2.0'
let $format := request:get-parameter("format", ())

(: Parse the URI.  It will be '.../data/<db>/<id>'  :)
let $uri := request:get-uri()
let $path-segs := tokenize($uri, "/")
let $data-seg-num := index-of($path-segs, "data")[1]
let $db := $path-segs[$data-seg-num + 1]
let $id := $path-segs[$data-seg-num + 2]

let $results := doc(concat($base_url, "&amp;db=", $db, "&amp;id=", $id))


return
  if ($format = 'rdf') then
    transform:transform(
      $results, "esummary.xsl", 
      <parameters>
        <param name="db" value="{$db}"/>
      </parameters>
    )
  else
    $results
    
