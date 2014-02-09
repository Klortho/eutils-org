xquery version "1.0-ml";

(: 
  This is the main URL rewriting module for Eutils.org deployed under the MarkLogic
  server.  It is not used in eXist.
:)

let $url := xdmp:get-request-url()

let $url := fn:replace($url, "^/data/?(\?.*)?$", "/einfo.xqy$1") 
let $url := fn:replace($url, "^/data/([a-z]+)(\?(.*))?$", "/einfo-db.xqy?db=$1&amp;$3")
let $url := fn:replace($url, "^/data/pmc/([0-9]+)\?format=rdf", "/jats2spar.xqy?id=$1")
let $url := fn:replace($url, "^/data/([a-z]+)/([0-9,]+)(\?(.*))?$", "/esummary.xqy?db=$1&amp;id=$2&amp;$4")


let $url := fn:replace($url, "^/data/([a-z]+)/([0-9,]+)/links/([a-z_]+)(\?(.*))?$",
                             "/elink.xqy?dbfrom=$1&amp;id=$2&amp;linkname=$3&amp;$5")

return $url



