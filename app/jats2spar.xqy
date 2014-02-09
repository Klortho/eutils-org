xquery version "1.0";
(:
  This runs a JATS journal article through jats2spar.xsl
:)

declare namespace request="http://exist-db.org/xquery/request";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace http="http://expath.org/ns/http-client";
declare option exist:serialize "media-type=text/xml";

let $base_url := 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com'

(: Parse the URI.  It will be '.../data/pmc/<id>'  :)
let $uri := request:get-uri()
let $path-segs := tokenize($uri, "/")
let $data-seg-num := index-of($path-segs, "data")[1]
let $db := $path-segs[$data-seg-num + 1]
let $id := $path-segs[$data-seg-num + 2]
let $results := doc(concat($base_url, "&amp;db=", $db, "&amp;id=", $id))


return
  transform:transform(
    $results, "jats2spar.xsl", 
    <parameters>
      <param name="this-work" value="{concat("http://rdf.ncbi.nlm.nih.gov/pmc/PMC", $id)}"/>
    </parameters>
  )

