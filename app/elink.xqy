xquery version "1.0";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace transform="http://exist-db.org/xquery/transform";
declare option exist:serialize "media-type=text/xml";

let $base_url := 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com'
let $format := request:get-parameter("format", ())

(: Parse the URI.  It will be '.../data/<dbfrom>/<id>/links/<linkname>'  :)
let $uri := request:get-uri()
let $path-segs := tokenize($uri, "/")
let $data-seg-num := index-of($path-segs, "data")[1]
let $dbfrom   := $path-segs[$data-seg-num + 1]
let $id       := $path-segs[$data-seg-num + 2]
let $linkname := $path-segs[$data-seg-num + 4]

(:
  Handle the case of multiple IDs entered like this, "id=312836839,24475906".  We can't
  pass them to elink that way, because it would return results in "batch" mode.  Instead,
  we have to convert this to "id=312836839&id=24475906".
:)
let $id_params :=
  for $idval in tokenize($id, ",")
  return concat("id=", $idval)
let $id_params_str := string-join($id_params, "&amp;")

let $results := doc(concat($base_url, "&amp;dbfrom=", $dbfrom, "&amp;", $id_params_str,
  "&amp;linkname=", $linkname))

return
  if ($format = 'rdf') then
    transform:transform($results, "elink.xsl", ())
  else
    $results

