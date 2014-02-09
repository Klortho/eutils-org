xquery version "3.0";

declare namespace request="http://exist-db.org/xquery/request";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

let $format := request:get-parameter("format", ())


return
  
  if ($exist:path eq "/") then
    (: forward root path to index.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <forward url="index.xql"/>
    </dispatch>
  
  (: /data :)
  else if (matches($exist:path, "^/data$")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <forward url="einfo.xqy"/>
    </dispatch>

  (: /data/pubmed :)
  else if (matches($exist:path, "^/data/[a-z]+$")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <forward url="../einfo-db.xqy"/>
    </dispatch>
  
  (: /data/pmc/14900?format=rdf :)
  else if (matches($exist:path, "^/data/pmc/[0-9]+$") and $format = "rdf") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <forward url="../../jats2spar.xqy"/>
    </dispatch>
  
  
  (: /data/pmc/14900 - esummary
    let $url := fn:replace($url, "^/data/([a-z]+)/([0-9,]+)(\?(.*))?$", "/esummary.xqy?db=$1&amp;id=$2&amp;$4") :)
  else if (matches($exist:path, "^/data/[a-z]+/[0-9]+$")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <forward url="../../esummary.xqy"/>
    </dispatch>
  
  
  
  else if (ends-with($exist:resource, ".html")) then
    (: the html page is run through view.xql to expand templates :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <view>
        <forward url="{$exist:controller}/modules/view.xql"/>
      </view>
      <error-handler>
        <forward url="{$exist:controller}/error-page.html" method="get"/>
        <forward url="{$exist:controller}/modules/view.xql"/>
      </error-handler>
    </dispatch>
  
  (: Resource paths starting with $shared are loaded from the shared-resources app :)
  else if (contains($exist:path, "/$shared/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}">
        <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
      </forward>
    </dispatch>
  
  else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
      <cache-control cache="yes"/>
    </dispatch>
