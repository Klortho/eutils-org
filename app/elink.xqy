xquery version "1.0-ml";

xdmp:set-response-content-type("text/xml"),

let $format := xdmp:get-request-field("format")
let $dbfrom := xdmp:get-request-field("dbfrom")
let $id := xdmp:get-request-field("id")
let $linkname := xdmp:get-request-field("linkname")

(:
  Handle the case of multiple IDs entered like this, "id=312836839,24475906".  We can't
  pass them to elink that way, because it would return results in "batch" mode.  Instead,
  we have to convert this to "id=312836839&id=24475906".
:)
let $id_params :=
  for $idval in tokenize($id, ",")
  return concat("id=", $idval)
let $id_params_str := string-join($id_params, "&amp;")


let $results := xdmp:http-get(
  concat("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com&amp;dbfrom=", $dbfrom,
         "&amp;", $id_params_str, "&amp;linkname=", $linkname)
)[2]

return
  if ($format = 'rdf') then
    xdmp:xslt-invoke("elink.xsl", document{$results})
  else
    $results

