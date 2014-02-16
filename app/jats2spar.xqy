xquery version "1.0";
(:
  This runs a JATS journal article through jats2spar.xsl
:)

declare namespace request="http://exist-db.org/xquery/request";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace http="http://expath.org/ns/http-client";
declare option exist:serialize "media-type=text/xml";

let $base_url := 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?tool=eutils.org&amp;email=voldrani@gmail.com'
let $idconv_base := 'http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=xml&amp;ids='

(: Parse the URI.  It will be '.../data/pmc/<id>'  :)
let $uri := request:get-uri()
let $path-segs := tokenize($uri, "/")
let $data-seg-num := index-of($path-segs, "data")[1]
let $db := $path-segs[$data-seg-num + 1]
let $id := $path-segs[$data-seg-num + 2]
let $pmcid := concat('PMC', $id)

(: Invoke eutils :)
let $results := doc(concat($base_url, "&amp;db=", $db, "&amp;id=", $id))

(: Invoke PMC ID converter :)
let $idconv_out := doc(concat($idconv_base, $pmcid))
(: Get the versioned PMCID for this article :)
let $pmcidv := $idconv_out//version[@current="true"]/@pmcid


return
  transform:transform(
    $results, "jats2spar.xsl", 
    <parameters>
      <param name="this-work" value="{concat("http://rdf.ncbi.nlm.nih.gov/pmc/", $pmcid)}"/>
      <param name="this-expression" value="{concat("http://rdf.ncbi.nlm.nih.gov/pmc/", $pmcidv)}"/>
    </parameters>
  )

