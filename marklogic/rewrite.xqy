xquery version "1.0-ml";

let $url := xdmp:get-request-url() 
return fn:replace($url, "^/macbeth$", "/mac.xqy")
