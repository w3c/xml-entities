<?xml version="1.0"?>
<!--
$Id: characters.xsl,v 1.71 2015/07/05 15:41:38 dcarlis Exp $

mml6.xsl David Carlisle
Generate bycodes.html, byalpha.html and the alphabetic glyph tables
originally for MathML chapter 6.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="2.0"
		xmlns:d="data:,dpc"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="d xs">

<xsl:import href="xmlspec.xsl"/>

<xsl:param name="none" select="false()"/>

<xsl:output encoding="US-ASCII" 
	    include-content-type="no" 
	    omit-xml-declaration="yes"/>

<xsl:param name="cssbase" select="'//www.w3.org/StyleSheets/TR/'"/>
<xsl:param name="baseuri" select="'//www.w3.org/2003/entities/'"/>
<xsl:param name="resultbase" select="'2007doc/'"/>
<xsl:param name="editors-copy" select="''"/>
<xsl:param name="script" select="'no'"/>
<xsl:param name="longtitle" select="'yes'"/>

<xsl:variable name="css" as="element()*">
  <style  type="text/css">
.base {background-color: #EEEEEE;}
.kwlabel {font-weight:normal}
  </style>
  <link rel="stylesheet" type="text/css" href="{$cssbase}W3C-{
  if($editors-copy) then 'ED' else upper-case(/spec/@w3c-doctype)}.css"/>
</xsl:variable>

<xsl:template name="css">
  <xsl:copy-of select="$css"/>
</xsl:template>

<xsl:param name="glyphs" select="'http://www.w3.org/2003/entities/glyphs'"/>

<xsl:strip-space elements="group"/>


<xsl:variable name="u" select="doc('unicode.xml')"/>
<xsl:variable name="blocks" select="$u/unicode/unicodeblocks/block"/>
<xsl:variable name="hex" select="('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F')"/>
<xsl:key name="set" match="entity" use="@set"/>
<xsl:key name="id" match="character" use="@id"/>
<xsl:key name="mathvariant" match="character[surrogate]" use="surrogate/@mathvariant"/>


<xsl:template match="/">
  <xsl:result-document 
      method="html"
      encoding="US-ASCII"
      include-content-type="no"
      doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
      doctype-system="http://www.w3.org/TR/html4/loose.dtd"
      href="index.html">
    <xsl:apply-templates/>
  </xsl:result-document>
  <xsl:apply-templates select="$u/unicode/entitygroups/group[@name='2007']/set"/>
  <xsl:apply-templates select="$u/unicode/charlist"/>
</xsl:template>

<xsl:variable name="blockstarts" select="('000','001','002','003','004',
'006',
                       '020','021','022','023','024','025','026','027','029','02A','02B',
                       '0FB','0FE',
                       '1D4','1D5','1D6','1D7','1EE',
 	               '1F7','1F8')"/>


<xsl:template match="charlist">


<xsl:for-each select="../mathvariants/mathvariant">
  <xsl:call-template name="letter-like">
    <xsl:with-param name="mathvariant" select="@name"/>
    <xsl:with-param name="title" select="@description"/>
  </xsl:call-template>
</xsl:for-each>


<xsl:for-each select="$blockstarts">
  <xsl:call-template name="code-chart">
    <xsl:with-param name="range" select="."/>
  </xsl:call-template>
</xsl:for-each>


<xsl:call-template name="bycodes"/>
<xsl:call-template name="byalpha"/>


</xsl:template>



<xsl:template match="group[@name='predefined']"/>

<xsl:template match="group">
<xsl:result-document method="html" 
		     include-content-type="no"
		     encoding="US-ASCII"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     href="{$resultbase}overview-{@name}.html">
<html>
<head>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8"/>
<title><xsl:value-of select="@name"/></title>
</head>
<body>
<h1><xsl:value-of select="@name"/></h1>
<p>
<a href="../index.html">Overview</a>
</p>
<table>
<tr>
<td>&#160;</td>
<td>&#160;</td>
<td>&#160;</td>
<td>&#160;<a href="../{@name}/{@name}map.xsl">XSLT 2 character map</a>&#160;</td>
</tr>
<xsl:for-each select="set">
<xsl:variable name="f">
<xsl:apply-templates select="." mode="name"/>
</xsl:variable>
<xsl:if test="string($f)">
<tr>
<th><xsl:value-of select="$f"/></th>
<td>&#160;<a href="{$f}.html">HTML Description</a>&#160;</td>
<td>&#160;<a href="{$baseuri}{../@name}/{$f}.ent">Entity Declarations</a>&#160;</td>
<td>&#160;<a href="{$baseuri}{../@name}/{$f}map.xsl">XSLT 2 character map</a>&#160;</td>
</tr>
</xsl:if>
</xsl:for-each>
</table>
</body>
</html>
</xsl:result-document>
<xsl:apply-templates select="set[not(../@name='mathml') or starts-with(@name,'m')]"/>
</xsl:template>

<xsl:template match="set" mode="name">
<xsl:choose>
<xsl:when test="../@name='mathml' and not(starts-with(@name,'m'))"/>
<xsl:when test="starts-with(@name,'957')"><xsl:value-of select="substring(@name,11)"/></xsl:when>
<xsl:when test="starts-with(@name,'88')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
<!--<xsl:when test="starts-with(@name,'html')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>-->
<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:variable name="sets" select="$u/unicode/entitygroups/group[@name='2007']/set"/>

<xsl:template match="set"/>
<xsl:template match="group[@name='2007']/set">
<xsl:variable name="set" select="@name"/>
<xsl:variable name="f">
<xsl:apply-templates select="." mode="name"/>
</xsl:variable>
<xsl:variable name="t"
  select="upper-case($f)"/>

<xsl:result-document method="html" 
		     include-content-type="no"
		     encoding="US-ASCII"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     href="{$resultbase}{$f}.html">
<html>
<head>
<title><xsl:value-of select="$t"/></title>
<style type="text/css">
.ignore {background-color: #AAAAAA;}
.base {background-color: #CCCCCC;}
</style>
<xsl:copy-of select="$css"/>
</head>
<body>
<h1><xsl:value-of select="$t"/></h1>
<p>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#sets">Sets of names</a>
<xsl:variable name="p">
 <xsl:apply-templates select="preceding-sibling::set[1]" mode="name"/>
</xsl:variable>
<xsl:variable name="n">
 <xsl:apply-templates select="following-sibling::set[1]" mode="name"/>
</xsl:variable>

<xsl:if test="string($p)">
<br/>Previous: <a href="{$p}.html">
<xsl:value-of select="$p"/></a>
</xsl:if>
<xsl:if test="string($n)">
<br/>Next: <a href="{$n}.html">
<xsl:value-of select="$n"/></a>
</xsl:if>
</p>
<p>
<a href="{$baseuri}{../@name}/{$f}.ent">Entity Declarations</a><br/>
<a href="{$baseuri}{../@name}/{$f}map.xsl">XSLT 2 character map</a>
</p>
<table border="1">
<tr>
<th>Name</th>
<th>Unicode</th>
<th>Glyph</th>
<th>Unicode Name</th>
<th>Description</th>
<th>Aliases</th>
</tr>
<xsl:for-each select="key('set',$set)">
<xsl:sort lang="en" select="@id"/>
<tr>
    <xsl:if test="../description/@unicode='provisional'">
      <xsl:attribute name="class">provisional</xsl:attribute>
      <xsl:message><xsl:value-of select="concat('Provisional: ',$set,': ',@id)"/></xsl:message>
    </xsl:if>
    <xsl:if test="@optional and @default='IGNORE'">
      <xsl:attribute name="class">ignore</xsl:attribute>
    </xsl:if>
<td>
<xsl:value-of select="@id"/>
</td>
<td>
<xsl:value-of select="d:uplus(../@id)"/>
</td>
<td>
<img height="32" 
         width="32"
         src="{$glyphs}/{substring(../@id,2,3)}/{translate(../@id,'x','')}.png"
         alt="{../@id}"
         >
<xsl:if test="../@image='none'"><xsl:attribute
  name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute></xsl:if>
</img>
</td>
<td>
<xsl:value-of select="../description"/>
</td>
<td>
<xsl:value-of select="desc"/>
<xsl:if test="not(desc)">&#160;</xsl:if>
</td>
<td>
<xsl:variable name="aliases" select="distinct-values((../entity[@set=$sets/@name])/@id)[not (. = current()/@id)]"/>
<xsl:if test="@id='AMP'">
</xsl:if>
<xsl:choose>
  <xsl:when test="exists($aliases)">
    <xsl:value-of select="$aliases" separator=", "/>
  </xsl:when>
  <xsl:otherwise>&#160;</xsl:otherwise>
</xsl:choose>
</td>
</tr>
</xsl:for-each>
</table>
<p>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#sets">Sets of names</a>
<xsl:variable name="p">
 <xsl:apply-templates select="preceding-sibling::set[1]" mode="name"/>
</xsl:variable>
<xsl:variable name="n">
 <xsl:apply-templates select="following-sibling::set[1]" mode="name"/>
</xsl:variable>

<xsl:if test="string($p)">
<br/>Previous: <a href="{$p}.html">
<xsl:value-of select="$p"/></a>
</xsl:if>
<xsl:if test="string($n)">
<br/>Next: <a href="{$n}.html">
<xsl:value-of select="$n"/></a>
</xsl:if>
</p>

</body>
</html>
</xsl:result-document>
</xsl:template>

<!-- -->



<!-- -->

<xsl:template name="code-chart">
 <xsl:param name="range"/>
<xsl:result-document method="html" 
		     include-content-type="no"
		     encoding="US-ASCII"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     href="{$resultbase}{$range}.html">
<html>
<head>
<title>Unicode Characters:
<xsl:value-of select="concat($range,'00 to ',$range,'FF')"/>
</title>
<style type="text/css">
.unassigned { background-color: #FF9999 }
.nonxml { background-color: #FF7799 }
.reserved { background-color: #FF6E0E }
.undescribed { background-color: #FFFF99 }
.proposed { background-color: #FF99FF }
span.stix {
 font-size: 125%;
 font-family: STIXGeneral, STIXGeneral-Italic, STIXGeneral-Bold, STIXGeneral-BoldItalic, STIXSize1Symbols;
 background-color: #FFFFDD; 
}
<!--
span.cambria {
 font-family:  Cambria;
 background-color: #FFFFEE; 
}
-->
<xsl:if test="$script='yes'">
table#info {
text-align:left;
display:none;
font-size: 70%;
background-color:#AAFFAA;
position:absolute;
z-index: 1;
}
</xsl:if>
</style>
<xsl:copy-of select="$css"/>
<xsl:if test="$script='yes'">
<script>
function showinfo (here,hex,ent) {
var tab=here.getElementsByTagName('table');
if (tab.length==1) {
here.style.backgroundColor='white';
here.removeChild(tab[0]);
} else {
var info = document.getElementById('info');
info.style.zIndex=info.style.zIndex+1;
var newinfo=info.cloneNode(true);
newinfo.style.display="table";
here.style.backgroundColor='#AAFFAA';
tr=newinfo.getElementsByTagName('tr');
tr[0].childNodes[0].innerHTML=here.getAttribute('title');
tr[1].childNodes[0].innerHTML= '&amp;amp;#x' + hex + ';';
tr[2].childNodes[0].innerHTML=ent.replace(/([a-zA-Z0-9]+)/g,'&amp;amp;$1;');
here.appendChild(newinfo);

}
}
</script>
</xsl:if>
</head>
<body>
<h1>Unicode Characters:
<xsl:value-of select="concat($range,'00 to ',$range,'FF')"/>
</h1>
<xsl:if test="$script='yes'">
<table id="info">
<tr><td><span id="info-uname">AAAA</span></td></tr>
<tr><td><span id="info-ucode"></span></td></tr>
<tr><td><span id="info-entities"></span></td></tr>
</table>
</xsl:if>
<p>
<xsl:variable name="p" select="position()"/>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#blocks">Unicode Character Ranges</a><br/>
<xsl:if test="$p!=1">
<a href="{$blockstarts[$p - 1]}.html">Previous: <xsl:value-of 
select="$blockstarts[$p - 1]"/>00 to  <xsl:value-of 
select="$blockstarts[$p - 1]"/>FF</a><br/>
</xsl:if>
<xsl:if test="$p!=last()">
<a href="{$blockstarts[$p+1]}.html">Next: <xsl:value-of 
select="$blockstarts[$p+1]"/>00 to  <xsl:value-of 
select="$blockstarts[$p+1]"/>FF</a><br/>
</xsl:if>
</p>

<xsl:variable name="table">
<table border="1">
<tr>
<th>&#160;</th>
<xsl:for-each select="$hex">
<xsl:variable name="r" select="."/>
<xsl:variable name="b" select="$blocks[@start=concat($range,$r,'0')]"/>
<xsl:variable name="e" select="d:hexfromstring(concat($range,'FF'))"/>
<xsl:choose>
<xsl:when test="$b">
  <xsl:variable name="c" select="$b/((1+min(($e,d:hexfromstring(@end))) - d:hexfromstring(@start))idiv 16)"/>
  <xsl:choose>
    <xsl:when test="$c=1">
      <th width="32"><a href="http://www.unicode.org/charts/PDF/U{$b/replace(@start,'^0','')}.pdf"><xsl:value-of select="replace($b/@name,'(([a-zA-Z][A-Za-z])|-)','&#x200b;$1')"/></a></th>
    </xsl:when>
    <xsl:when test="$range='1EE'">
      <th width="{$c * 32}" colspan="{$c}"><a href="http://std.dkuug.dk/JTC1/SC2/WG2/docs/n3799.pdf"><xsl:value-of select="$b/@name"/></a></th>
    </xsl:when>
<xsl:otherwise>
      <th width="{$c * 32}" colspan="{$c}"><a href="http://www.unicode.org/charts/PDF/U{$b/replace(@start,'^0','')}.pdf"><xsl:value-of select="$b/@name"/></a></th>
    </xsl:otherwise>
  </xsl:choose>
</xsl:when>
<xsl:when test="position()=1 and not($b)">
<xsl:variable name="b" select="$blocks[@end&gt;concat($range,$r,'0')][1]"/>
<xsl:variable name="c" select="$b/((1+min(($e,d:hexfromstring(@end))) - d:hexfromstring(concat($range,$r,'0')))idiv 16)"/>
  <xsl:choose>
    <xsl:when test="$c=1">
      <th width="32"><a href=" http://www.unicode.org/charts/PDF/U{$b/replace(@start,'^0','')}.pdf"><xsl:value-of select="replace($b/@name,'(([a-zA-Z][a-zA-Z])|-)','&#x200b;$1')"/></a></th>
    </xsl:when>
    <xsl:otherwise>
      <th width="{$c * 32}" colspan="{$c}"><a href="http://www.unicode.org/charts/PDF/U{$b/replace(@start,'^0','')}.pdf"><xsl:value-of select="$b/@name"/></a></th>
    </xsl:otherwise>
  </xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:for-each>
<th>&#160;</th>
</tr>
<tr>
<th>&#160;</th>
<xsl:for-each select="$hex">
  <th><xsl:value-of select="$range"/><xsl:value-of select="."/></th>
</xsl:for-each>
<th>&#160;</th>
</tr>
<xsl:for-each select="$hex">
  <xsl:call-template name="table-row">
    <xsl:with-param name="range" select="$range"/>
    <xsl:with-param name="row" select="."/>
  </xsl:call-template>
</xsl:for-each>
<tr>
<th>&#160;</th>
<xsl:for-each select="$hex">
  <th><xsl:value-of select="$range"/><xsl:value-of select="."/></th>
</xsl:for-each>
<th>&#160;</th>
</tr>
</table>
</xsl:variable>
<xsl:copy-of select="$table"/>

<h2 id="key">Key</h2>


<table border="1">
<tr><th>Cell Style</th><th>Status</th></tr>
<tr><td>&#160;&#160;&#160;</td><td>Unicode Character (Unicode <xsl:value-of select="$u/unicode/@unicode"/>)</td></tr>
<xsl:if test="$table//td/@class='proposed'">
<tr><td class="proposed">&#160;&#160;&#160;</td><td><a href="http://unicode.org/alloc/Pipeline.html">Proposed Unicode Character</a></td></tr>
</xsl:if>
<xsl:if test="$table//td/@class='unassigned'">
<tr><td class="unassigned">&#160;</td><td>Unicode or XML Non-Character</td></tr>
</xsl:if>
<xsl:if test="$table//td/@class='nonxml'">
<tr><td class="unassigned">&#160;</td><td>Codepoint not allowed as XML 1.0 character data</td></tr>
</xsl:if>

<xsl:if test="$table//td/@class='reserved'">
<tr><td class="reserved">&#160;</td><td>Reserved (unassigned) codepoint</td></tr>
</xsl:if>
<xsl:if test="$table//td/@class='undescribed'">
<tr><td class="undescribed">&#160;</td><td>Codepoint allowed as XML 1.0 character data; no Unicode character defined</td></tr>
</xsl:if>
<!--<tr><td><img src="{$glyphs}/none.png" alt="none"/></td><td>Character for which an image is not currently available</td></tr>-->
<tr><td><span class="stix">&#160;X&#160;</span></td><td>Character styled with the <a href="http://www.stixfonts.org">STIX Fonts</a></td></tr>
</table>

<p>Table headings link to the (PDF) Code charts at the <a href="http://www.unicode.org">Unicode site</a>.</p>
<!--
<p>Images link to the listing <a href="bycodes.html">listing of all characters assigned an entity name</a> whenever such an entity is defined.</p>
-->
<p>
<xsl:variable name="p" select="position()"/>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#blocks">Unicode Character Ranges</a><br/>
<xsl:if test="$p!=1">
<a href="{$blockstarts[$p - 1]}.html">Previous: <xsl:value-of 
select="$blockstarts[$p - 1]"/>00 to  <xsl:value-of 
select="$blockstarts[$p - 1]"/>FF</a><br/>
</xsl:if>
<xsl:if test="$p!=last()">
<a href="{$blockstarts[$p+1]}.html">Next: <xsl:value-of 
select="$blockstarts[$p+1]"/>00 to  <xsl:value-of 
select="$blockstarts[$p+1]"/>FF</a><br/>
</xsl:if>
</p>
</body>
</html>
</xsl:result-document>
</xsl:template>

<xsl:template name="table-row">
  <xsl:param name="range"/>
  <xsl:param name="row"/>
  <tr>
    <th><xsl:value-of select="$row"/></th>
    <xsl:for-each select="$hex">
      <xsl:call-template name="table-cell">
	<xsl:with-param name="range" select="$range"/>
	<xsl:with-param name="h" select="concat(.,$row)"/>
      </xsl:call-template>
    </xsl:for-each>
    <th><xsl:value-of select="$row"/></th>
  </tr>
</xsl:template>


<xsl:template name="table-cell">
  <xsl:param name="range"/>
  <xsl:param name="h"/>
  <td width="40" align="center">
    <xsl:variable name="x" select="key('id',concat('U',$range,$h),$u)"/>
    <xsl:variable name="c" select=
		  "codepoints-to-string(d:hexfromstring(concat($range,$h))
		   [(. gt 32
		   and
		   . lt 128)
		   or
		   . gt 160]
		   )"/>
    <xsl:choose>
      <xsl:when test="not($x)">
	<xsl:attribute name="class">undescribed</xsl:attribute>
	<xsl:text>&#160;</xsl:text>
      </xsl:when>
      <xsl:when test="$x/description/@unicode='unassigned' and $x/bmp">
	<xsl:attribute name="class">reserved</xsl:attribute>
	<xsl:text>&#160;</xsl:text>
      </xsl:when>
      <xsl:when test="$x/description/@unicode='unassigned'">
	<xsl:attribute name="class">unassigned</xsl:attribute>
	<xsl:text>&#160;</xsl:text>
      </xsl:when>
      <xsl:when test="$range='000' and (matches($h,'^[01]') and not($h=('09','0A','0D')))">
	<xsl:attribute name="class">nonxml</xsl:attribute>
	<xsl:text>&#160;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="title" select="$x/description"/>
	<xsl:if test="$x/description/@unicode='proposed'">
	  <xsl:attribute name="class">proposed</xsl:attribute>
	  <xsl:message>proposed: <xsl:value-of select="concat($range,$h),$x/description"/></xsl:message>
	</xsl:if>
	<xsl:variable name="img">
	  <img height="32" width="32" src="{$glyphs}/{$range}/U{$range}{$h}.png"
	       alt="{$x/description}">
	    <xsl:if test="not($none) and ($x/@image='none')">
<xsl:message select="concat('$$$$: ', 'U', $range, $h, '  ', $x/description)"/>
      <xsl:attribute name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute>
	    </xsl:if>
	  </img>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test="$script='yes'">
	    <xsl:attribute name="onclick" select="concat('showinfo(this,''',replace(concat($range,$h),'^0+',''),''',''',
string-join(
distinct-values($x/entity[@set=$u/unicode/entitygroups/group[@name='2007']/set/@name]/@id),
' ')
,''');')"/>
	    <xsl:copy-of select="$img"/>	     
	  </xsl:when>
	  <xsl:when test="$longtitle='yes'">
	    <xsl:attribute name="title" select="concat(
$x/description,
' &#10;&amp;',
string-join((
replace(concat($range,$h),'^0+','#x'),
distinct-values($x/entity[@set=$u/unicode/entitygroups/group[@name='2007']/set/@name]/@id)),'; &#10;&amp;'),
';')"/>
	    <xsl:copy-of select="$img"/>	     
	  </xsl:when>
	  <xsl:when test="$x/entity[@set=$u/unicode/entitygroups/group[@name='2007']/set/@name]">
	    <a href="bycodes.html#{$x/@id}">
	      <xsl:copy-of select="$img"/>	     
	    </a>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy-of select="$img"/>	     
	  </xsl:otherwise>
	</xsl:choose>
	<br/>
	<span class="stix">&#160;<xsl:value-of select="$c"/>&#160;</span>
      </xsl:otherwise>
    </xsl:choose>
</td>
</xsl:template>

<xsl:template match="phrase[@role='unicode' and not(node())]">
 <xsl:value-of select="$u/unicode/@unicode"/>
</xsl:template>

<!-- -->
<xsl:template name="bycodes">
<xsl:result-document method="html" 
		     include-content-type="no"
		     encoding="US-ASCII"
     indent="no"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     href="{$resultbase}bycodes.html">
<html>
<head>
<title>
  Characters Ordered by Unicode
</title>
<xsl:text>&#10;</xsl:text>
  <style type="text/css">.error { color: red }</style>
<xsl:text>&#10;</xsl:text>
<xsl:copy-of select="$css"/>
</head>
<xsl:text>&#10;</xsl:text>
<body>
<h1>Characters Ordered by Unicode</h1>
<xsl:text>&#10;</xsl:text>
<p>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#sets">Sets of names</a><br/>
<a href="byalpha.html">Characters ordered by Entity Name</a><br/>
</p>


	<p>The line for each character (or character sequence) in the table below lists in order:<br
  />Unicode value,<br/> 
	 Unicode formal name (or in the case of  a sequence of characters, the formal name of the first, followed by a descritption of the variant or combination),<br/>
       a list of all entity names assigned to this character or sequence.</p>

<pre>
<xsl:text>&#10;</xsl:text>
<xsl:for-each select="character[entity/@set=/unicode/entitygroups/group[@name='2007']/set/@name]">
<xsl:sort lang="en" select="@id"/>
<a name="{@id}"/>
<xsl:choose>
<xsl:when test="@image='none'">
  <xsl:value-of select="@id"/>
  <xsl:message>missing image: <xsl:value-of select="@id"/></xsl:message>
</xsl:when>
<xsl:otherwise>
<a href="{$glyphs}/{substring(@id,2,3)}/{translate(@id,'x','')}.png">
<xsl:value-of select="d:uplus(@id)"/>
</a>
</xsl:otherwise>
</xsl:choose>
<xsl:text>, </xsl:text>
<xsl:value-of select="description"/>
<xsl:value-of select="substring(
'                                      ',
string-length(description))"/>
<xsl:text>, </xsl:text>
<xsl:for-each-group select="entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]/@id" group-by=".">
<xsl:value-of select="."/>
<xsl:if test="position() &lt; last()">, </xsl:if>
</xsl:for-each-group>
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</pre>
</body>
</html>
</xsl:result-document>
</xsl:template>

<xsl:template name="byalpha">
  <xsl:result-document method="html" 
		       encoding="US-ASCII"
		       include-content-type="no"
		       doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
		       doctype-system="http://www.w3.org/TR/html4/loose.dtd"
		       href="{$resultbase}byalpha.html">
    <html>
      <head>
	<title>Characters Ordered by Entity Name</title>
	<style type="text/css">.error { color: red }</style>
	<xsl:copy-of select="$css"/>
      </head>
      <body>
	<h1>Characters Ordered by Entity Name</h1>
	<p>
	  <a href="../index.html">Overview</a><br/>
	  <a href="../index.html#sets">Sets of names</a><br/>
	  <a href="bycodes.html">Characters ordered by codes</a><br/>
	</p>
	
	<p>The line for each entity in the table below lists in order:<br
          />entity name,<br/>entity set,<br/>entity description,<br/>Unicode value,<br
   /> Unicode formal name (or in the case of  a sequence of characters, the formal name of the first, followed by a descritption of the variant or combination).</p>
	<pre>
	  <xsl:for-each-group
	      select="character/entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]"
	      group-by="@id">
	    <xsl:sort lang="en" select="@id"/>
	    <xsl:value-of select="@id"/>
	    <xsl:text>, </xsl:text>
	    <xsl:value-of select="substring('                        ',string-length(@id))"/>
	    <xsl:text>, </xsl:text>
	    
	    <xsl:variable name="s" select="string-join(current-group()/replace(@set,'9573-[0-9]*-',''),' ')"/>
	    <xsl:value-of select="$s"/>
	    <xsl:value-of select="substring('                            ',string-length($s))"/>
	    <xsl:text>, </xsl:text>
	    <xsl:value-of select="normalize-space(.)"/>
	    <xsl:value-of select="substring('                                       ',1+string-length(normalize-space(.)))"/>
	    <xsl:text>, </xsl:text>
	    <!-- new bit -->
	    <xsl:choose>
	      <xsl:when test="@image='none'">
		<xsl:value-of select="../@id"/>
		<xsl:message>missing image: <xsl:value-of select="../@id"/></xsl:message>
	      </xsl:when>
	      <xsl:otherwise>
		<a href="{$glyphs}/{substring(../@id,2,3)}/{translate(../@id,'x','')}.png">
		  <xsl:value-of select="d:uplus(../@id)"/>
		</a>
	      </xsl:otherwise>
	    </xsl:choose>
	    <!-- end new bit -->
	    <xsl:text> , </xsl:text>
	    <xsl:value-of select="normalize-space(../description)"/>
	    <xsl:text>, </xsl:text>
	    <xsl:text>&#10;</xsl:text>
	  </xsl:for-each-group>
	</pre>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>



<xsl:function name="d:hexfromstring">
<xsl:param name="x"/>
   <xsl:sequence select="(
         d:hex(
           for $i in string-to-codepoints(upper-case($x))
           return if ($i &gt; 64) then $i - 55 else $i - 48))"/>
</xsl:function>

<xsl:function name="d:hex">
<xsl:param name="x"/>
  <xsl:sequence
    select="if (empty($x)) then 0 else ($x[last()] + 16* d:hex($x[position()!=last()]))"/>
</xsl:function>




<xsl:template match="div1[@id='sets']">
 <div id="setsdiv">
  <xsl:apply-templates select="*"/>
  <ul>
   <xsl:for-each select="$u/unicode/entitygroups/group[@name='2007']/set">
    <li>
     <a href="2007doc/{replace(@name,'^[0-9][0-9\-]*','')}.html">
      <xsl:apply-templates select="." mode="name"/>
     </a>
     <xsl:choose>
      <xsl:when test="not(@name=../../group[@name=('html5','mathml')]/set/@name)">
       <span>
	<xsl:attribute name="style" select="'background-color: #FFCCCC'"/>
	<xsl:text>&#160;&#160;</xsl:text>
	<xsl:value-of select="replace(@fpi,'.*ENTITIES ([^/]*)//.*','$1')"/>
	<xsl:text>&#160;&#160;(not in MathML3 / HTML5)</xsl:text>
       </span>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>&#160;&#160;</xsl:text>
       <xsl:value-of select="replace(@fpi,'.*ENTITIES ([^/]*)//.*','$1')"/>
      </xsl:otherwise>
     </xsl:choose>
    </li>
   </xsl:for-each>
  </ul>
    <p>In addition to the stylesheets and entity files corresponding
    to each individual entity set, a <a
    href="http://www.w3.org/2003/entities/2007/entitynamesmap.xsl">combined
    stylesheet</a> is provided, as well as a combined entity set,
    in two formats, as for the HTML MathML set described above.</p>
    <ul>
      <li><a  href="http://www.w3.org/2003/entities/2007/w3centities.ent">w3centities</a> W3C entities collection; referencing all entity sets listed above</li>
      <li><a
    href="http://www.w3.org/2003/entities/2007/w3centities-f.ent">w3centities-f</a> the same set of entity definitions, expanded into a single file, with duplicates removed</li>
    </ul>
  </div>
</xsl:template>

<!--
<xsl:template match="div1[@id='blocks']">
<div id="sets">
  <dl>
  <xsl:apply-templates select="*"/>
  <xsl:for-each-group select="$blocks[substring(@start,1,3)=$blockstarts]" group-by="substring(@start,1,3)">
    <xsl:for-each select="current-group()">
      <dt><xsl:value-of select="@name"/></dt>
    </xsl:for-each>
    <dd><a href="{current-grouping-key()}.html"><xsl:value-of select="current-grouping-key()"/></a></dd>
  </xsl:for-each-group>
  </dl>
</div>
</xsl:template>
-->

<xsl:template match="div1[@id='blocks']">
  <div id="blocksdiv">
    <xsl:apply-templates select="*"/>
    <ul>
      <xsl:for-each-group select="$blocks[substring(@start,1,3)=$blockstarts]" group-by="substring(@start,1,3)">
	<xsl:variable  name="s" select="d:hexfromstring(substring(@start,1,3))"/>
	<xsl:variable name="e" select="d:hexfromstring(substring(@end,1,3))"/>
	
	<xsl:for-each select="$s to $e">
	<li>
	  <xsl:variable name="p" select="string-join(for $x in (. idiv 256, (. mod 256) idiv 16, . mod 16)
					 return $hex[$x+1],'')"/>
	  <span>
	      <xsl:value-of select="$p"/>
	    </span>
	    <xsl:text> </xsl:text>
	      <a href="2007doc/{$p}.html">
		<xsl:value-of select="current-group()/@name" separator=", "/>
		<xsl:if test="position()!=1"> (continued)</xsl:if>
	      </a>
	</li>
	</xsl:for-each>
      </xsl:for-each-group>
    </ul>
  </div>
</xsl:template>

<xsl:template match="div1[@id='alphabets']">
  <div id="alphabetsdiv">
    <xsl:apply-templates select="*"/>
    <ul>
      <xsl:for-each select="$u/unicode/mathvariants/mathvariant">
	<li>
	  <a href="2007doc/{@name}.html"><xsl:value-of select="@description"/></a>
	</li>
      </xsl:for-each>
    </ul>
  </div>
</xsl:template>

<xsl:template match="graphic[@role='glyph']">
 <img height="32" width="32"  style="position: relative; top: 10px;" 
       src="{$glyphs}/{substring(@source,2,3)}/{@source}.png"
       alt="{key('id',@source,$u)/description}">
  </img>
</xsl:template>

<xsl:variable name="negations" select="('U00338','U020D2','U020E5')"/>
<xsl:template match="p[@id='cancellations']">
<xsl:variable name="section" select="."/>
<ul>
<xsl:for-each select="key('id',$negations,$u)">
<xsl:call-template name="compose-table">
  <xsl:with-param name="section" select="$section"/>
</xsl:call-template>
</xsl:for-each>
</ul>
</xsl:template>

<xsl:template match="p[@id='variants']">
<xsl:variable name="section" select="."/>
<ul>
<xsl:for-each select="key('id','U0FE00',$u)">
 <xsl:call-template name="compose-table">
  <xsl:with-param name="section" select="$section"/>
 </xsl:call-template>
</xsl:for-each>
</ul>
</xsl:template>

<xsl:template name="compose-table">
<xsl:param name="section"/>
<xsl:param name="char" select="translate(@id,'U','-')"/>
<xsl:variable name="c" select="."/>
<li><a href="2007doc/{@id}.html"><xsl:value-of select="lower-case($c/description)"/></a></li>
<xsl:result-document method="html" 
		     include-content-type="no"
		     encoding="US-ASCII"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     href="{$resultbase}{$c/@id}.html">
<html>
<head>
<title>
  <xsl:value-of select="$c/description"/> 
</title>
<style type="text/css">
.ignore {background-color: #AAAAAA;}
.base {background-color: #CCCCCC;}
</style>
<xsl:copy-of select="$css"/>
</head>
<body>
<h1><a name="canc.{$c/@id}" id="canc.{$c/@id}"/><xsl:value-of select="lower-case($c/description)"/></h1>
<p>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#{$section/../@id}"><xsl:apply-templates select="$section/../head/text()"/></a><br/>
<xsl:variable name="p" select="position()"/>
<xsl:if test="$p!=1">
Previous:  <a href="{$negations[$p - 1]}.html">
<xsl:value-of select="key('id',$negations[$p - 1],$u)/lower-case(description)"/>
</a><br/>
</xsl:if>
<xsl:if test="$p!=last()">
Next:  <a href="{$negations[$p + 1]}.html">
<xsl:value-of select="key('id',$negations[$p + 1],$u)/lower-case(description)"/>
</a><br/>
</xsl:if>

</p>
<table border="1">
<tr>
<th>&#160;</th>
<th>Unicode</th>
<th>Glyph</th>
<th>Unicode Name</th>
<th>Entity Names</th>
</tr>
<tr>
<td>&#160;</td>
<td>
<xsl:value-of select="d:uplus($c/@id)"/>
</td>
<td>
<img height="32" 
         width="32"
         src="{$glyphs}/{substring($c/@id,2,3)}/{$c/@id}.png"
         alt="{$c/@id}"
         >
<xsl:if test="$c/@image='none'"><xsl:attribute
  name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute></xsl:if>
</img>
</td>
<td>
<xsl:value-of select="$c/description"/>
</td>
<td>&#160;</td>
</tr>

<xsl:variable name="cz" select="concat($char,'z')"/>
<xsl:for-each select="$u/unicode/charlist/character[contains(concat(@id,'z'),$cz)]">
<xsl:sort select="@id"/>
<xsl:variable name="id" select="@id"/>
<xsl:variable name="base" select="key('id',concat(substring-before($id,$char),substring-after($id,$char)),$u)"/>
<tr class="base">
<xsl:if test="not($base)">
<xsl:attribute name="class">provisional</xsl:attribute>
<xsl:message>no base: <xsl:value-of select="@id"/></xsl:message>
</xsl:if>
<th>Base</th>
<td>
<xsl:value-of select="d:uplus($base/@id)"/>
</td>
<td>
<img height="32" 
         width="32"
         src="{$glyphs}/{substring($base/@id,2,3)}/{translate($base/@id,'x','')}.png"
         alt="{$base/@id}"
         >
<xsl:if test="$base/@image='none'"><xsl:attribute
  name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute></xsl:if>
</img>
</td>
<td>
<xsl:value-of select="$base/description"/>
</td>
<td>
<xsl:variable name="x" select="$base/entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]/@id"/>
<xsl:choose>
<xsl:when test="not($x)">&#160;</xsl:when>
<xsl:otherwise>
<xsl:for-each select="distinct-values($x)">
<xsl:value-of select="."/>
<xsl:if test="position() &lt; last()">, </xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</td>
</tr>
<tr class="combine">
<xsl:if test="not(description/@unicode='combination' or description/@unicode='3.2')">
<xsl:attribute name="class">provisional</xsl:attribute>
<xsl:message><xsl:value-of select="@id"/></xsl:message>
</xsl:if>
<th>Variant</th>
<td>
<xsl:value-of select="d:uplus($id)"/>
</td>
<td>
<img height="32" 
         width="32"
         src="{$glyphs}/{substring($id,2,3)}/{translate($id,'x','')}.png"
         alt="{$id}"
         >
<xsl:if test="@image='none'"><xsl:attribute
  name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute></xsl:if>
</img>
</td>
<td>
<xsl:value-of select="description"/>
</td>
<td>
<xsl:variable name="x" select="entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]/@id"/>
<xsl:choose>
<xsl:when test="not($x)">&#160;</xsl:when>
<xsl:when test="not($x)">&#160;</xsl:when>
<xsl:otherwise>
<xsl:for-each select="distinct-values($x)">
<xsl:value-of select="."/>
<xsl:if test="position() &lt; last()">, </xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</td>
</tr>
</xsl:for-each>
</table>
<p>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#{$section/../@id}"><xsl:apply-templates select="$section/../head/text()"/></a><br/>
<xsl:variable name="p" select="position()"/>
<xsl:if test="$p!=1">
Previous:  <a href="{$negations[$p - 1]}.html">
<xsl:value-of select="key('id',$negations[$p - 1],$u)/lower-case(description)"/>
</a><br/>
</xsl:if>
<xsl:if test="$p!=last()">
Next:  <a href="{$negations[$p + 1]}.html">
<xsl:value-of select="key('id',$negations[$p + 1],$u)/lower-case(description)"/>
</a><br/>
</xsl:if>

</p>
</body>
</html>
</xsl:result-document>
</xsl:template>


<xsl:template match="p[@id='multiple']">
<table border="1">
<thead>
<tr>
<th>Entity</th>
<th>Set</th>
<th>Description</th>
<th colspan="3">Unicode Character</th>
</tr>
</thead>
<tbody>


<xsl:for-each select="$u/unicode/charlist/character
[contains(@id,'-')]
[entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]/@id]
[not(matches(@id,'(020D2|020E5|022D2|00338|0FE00)$'))]">
<xsl:sort select="@id"/>
<xsl:variable name="id" select="@id"/>
<xsl:for-each select="entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]">
<tr class="combine">
<td><xsl:value-of select="@id"/></td>
<td><xsl:value-of select="replace(@set,'9573-2003-','')"/></td>
<td><xsl:value-of select="desc"/></td>
<xsl:if test="position()=1">
<td rowspan="{last()}">
<xsl:if test="starts-with(../description,'COMBINING')">U+0020 </xsl:if>
<xsl:value-of select="d:uplus($id)"/>
</td>
<td rowspan="{last()}">
<img height="32" 
         width="32"
         src="2007doc/{$glyphs}/{substring($id,2,3)}/{translate($id,'x','')}.png"
         alt="{$id}"
         >
<xsl:if test="@image='none'"><xsl:attribute
  name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute></xsl:if>
</img>
</td>
<td rowspan="{last()}">
  <xsl:value-of select="../description"/>
</td>
</xsl:if>
</tr>
</xsl:for-each>
</xsl:for-each>
</tbody>
</table>
</xsl:template>

<xsl:template match="p[@id='combining-start']">
<table border="1">
<thead>
<tr>
<th>Entity</th>
<th>Set</th>
<th>Description</th>
<th colspan="3">Unicode Character</th>
</tr>
</thead>
<tbody>


<xsl:for-each select="$u/unicode/charlist/character
[starts-with(description,'COMBINING')]
[entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]/@id]
[not(matches(@id,'(020D2|020E5|022D2|00338|0FE00)$'))]">
<xsl:sort select="@id"/>
<xsl:variable name="id" select="@id"/>
<xsl:for-each select="entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]">
<tr class="combine">
<td><xsl:value-of select="@id"/></td>
<td><xsl:value-of select="replace(@set,'9573-2003-','')"/></td>
<td><xsl:value-of select="desc"/></td>
<xsl:if test="position()=1">
<td rowspan="{last()}">
 <!--
     <xsl:if test="starts-with(../description,'COMBINING')">U+0020 </xsl:if>
 -->
<xsl:value-of select="d:uplus($id)"/>
</td>
<td rowspan="{last()}">
<img height="32" 
         width="32"
         src="2007doc/{$glyphs}/{substring($id,2,3)}/{translate($id,'x','')}.png"
         alt="{$id}"
         >
<xsl:if test="@image='none'"><xsl:attribute
  name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute></xsl:if>
</img>
</td>
<td rowspan="{last()}">
  <xsl:value-of select="../description"/>
</td>
</xsl:if>
</tr>
</xsl:for-each>
</xsl:for-each>
</tbody>
</table>
</xsl:template>


<xsl:template name="letter-like">
<xsl:param name="mathvariant"/>
<xsl:param name="title"/>

<xsl:result-document method="html" 
		     include-content-type="no"
		     encoding="US-ASCII"
     doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
     doctype-system="http://www.w3.org/TR/html4/loose.dtd"
     href="{$resultbase}{$mathvariant}.html">
<html>
<head>
<title>
  <xsl:value-of select="$title"/> 
</title>
<style type="text/css">
.bmp { background-color: #FFFF99 }
</style>
<xsl:copy-of select="$css"/>
</head>
<body>
<h1>
 <xsl:value-of select="$title"/>
</h1>

<p>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#alphabets">Mathematical Alphanumeric Characters</a><br/>
<xsl:for-each select="preceding-sibling::mathvariant[1]">
Previous: <a href="{@name}.html"><xsl:value-of select="@description"/></a><br/>
</xsl:for-each>
<xsl:for-each select="following-sibling::mathvariant[1]">
Next: <a href="{@name}.html"><xsl:value-of select="@description"/></a><br/>
</xsl:for-each>

</p>


<div>
<br/>
<table border="1">
<tr>
<th>Unicode</th>
<th>BMP</th>
<th>Glyph</th>
<th>Unicode Name</th>
<th>Entity Names</th>
</tr>
<xsl:for-each select="key('mathvariant',$mathvariant,$u)">
<xsl:sort select="@id"/>
<xsl:variable name="s" select="d:uplus(surrogate/@ref)"/>
<tr>
<xsl:if test="bmp">
  <xsl:attribute name="class">bmp</xsl:attribute>
</xsl:if>
<xsl:for-each select="self::node()[not(bmp)]|key('id',bmp/@ref,$u)">
<td>
<xsl:value-of select="d:uplus(@id)"/>
</td>
<td>
<xsl:value-of select="$s"/>
</td>
<td>
<img height="32" 
         width="32"
         src="{$glyphs}/{substring(@id,2,3)}/{translate(@id,'x','')}.png"
         alt="{@id}"
         >
<xsl:if test="@image='none'"><xsl:attribute
  name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute></xsl:if>
</img>
</td>
<td>
<xsl:value-of select="description"/>
</td>
<td>
<xsl:variable name="x" select="entity[@set=/unicode/entitygroups/group[@name='2007']/set/@name]/@id"/>
<xsl:choose>
<xsl:when test="not($x)">&#160;</xsl:when><xsl:when test="not($x)">&#160;</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$x">
<xsl:value-of select="."/>
<xsl:if test="position() &lt; last()">, </xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</td>
</xsl:for-each>
</tr>
</xsl:for-each>
</table>
<xsl:if test="key('mathvariant',$mathvariant,$u)/bmp">
<p>
<span class="bmp"><b>Note:</b> Characters highlighted are in the Plane 0, not in the Mathematical Alphanumeric Symbols block in Plane 1.</span>
</p>
</xsl:if>
</div>


<p>
<a href="../index.html">Overview</a><br/>
<a href="../index.html#alphabets">Mathematical Alphanumeric Characters</a><br/>
<xsl:for-each select="preceding-sibling::mathvariant[1]">
Previous: <a href="{@name}.html"><xsl:value-of select="@description"/></a><br/>
</xsl:for-each>
<xsl:for-each select="following-sibling::mathvariant[1]">
Next: <a href="{@name}.html"><xsl:value-of select="@description"/></a><br/>
</xsl:for-each>
</p>


</body>
</html>
</xsl:result-document>
</xsl:template>

<xsl:template match="p[@id=('epsilontab','phitab')]">
<xsl:variable name="l" select="upper-case(substring-before(@id,'tab'))"/>
<table border="border">
<thead>
<tr>
<th>Entity</th>
<th>Set</th>
<th>Description</th>
<th colspan="3">Unicode Character</th>
</tr>
</thead>
<tbody>
<xsl:for-each-group  select="key('set',$sets/@name,$u)[matches(../description,concat('SMALL.*',$l,'|',$l,'.*SYMBOL'))]" group-by="../@id">
<xsl:for-each select="current-group()">
<tr>
<td><xsl:value-of select="string(@id)"/></td>
<td><xsl:value-of select="replace(@set,'9573-2003-','')"/></td>
<td><xsl:value-of select="desc"/></td>
<xsl:if test="position()=1">
<td rowspan="{last()}"><xsl:value-of select="d:uplus(../@id)"/></td>
<td rowspan="{last()}">
<img height="32" 
         width="32"
         src="2007doc/{$glyphs}/{substring(../@id,2,3)}/{translate(../@id,'x','')}.png"
         alt="{../@id}"
         >
<xsl:if test="../@image='none'"><xsl:attribute
  name="src"><xsl:value-of select="$glyphs"/>/none.png</xsl:attribute></xsl:if>
</img>
</td>
<td rowspan="{last()}">
<xsl:value-of select="../description"/>
</td>
</xsl:if>
</tr>
</xsl:for-each>
</xsl:for-each-group>
</tbody>
</table>
</xsl:template>

<xsl:template match="item">
 <li>
  <xsl:copy-of select="@id"/>
  <xsl:apply-templates/>
 </li>
</xsl:template>


<xsl:template match="item/p[not(../*[2])]">
 <xsl:apply-templates/>
</xsl:template>

<!-- lose class = label -->
<xsl:template match="label[kw]">
  <dt class="kwlabel">
    <xsl:apply-templates/>
  </dt>
</xsl:template>

<xsl:template match="gitem/def/p[count(../*)=1]">
  <xsl:apply-templates/>
</xsl:template>



<xsl:function name="d:uplus" as="xs:string">
  <xsl:param name="id" as="xs:string"/>
  <xsl:sequence select="replace(replace($id,'U0?','U+'),'[\-]0?', ' U+')"/>
</xsl:function>
</xsl:stylesheet>
