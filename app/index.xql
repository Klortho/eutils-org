xquery version "1.0";
(:
  Main page of Eutils.org.  This XQuery just invokes index.xsl.
:)

declare namespace transform="http://exist-db.org/xquery/transform";

transform:transform(<dummy/>, "index.xsl",())
