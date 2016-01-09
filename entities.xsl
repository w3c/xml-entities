<?xml version="1.0"?>
<!--
$Id: entities.xsl,v 1.18 2013/12/08 18:43:25 dcarlis Exp $
Generate entity files for MathML
David Carlisle
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:d="data:,dpc"
                version="2.0">

<xsl:param name="plane1hack" select="false()"/>

<!--set to true to guard combining characters with a space-->
<xsl:param name="guard-combining" select="false()"/>
<xsl:param name="olddesc" select="false()"/>
<xsl:param name="mml2" select="doc('mml2.xml')"/>
<xsl:param name="xhtml1" select="doc('xhtml1.xml')"/>
<xsl:param name="mathmaptxt" 
	   select="tokenize(unparsed-text('MathMap-9.txt'),'[\r\n]+')"/>
<xsl:key name="mml2" match="char" use="@name"/>
<xsl:variable name="mathmap">
<m>
<xsl:for-each select="$mathmaptxt">
<xsl:analyze-string select="." regex="^([0-9A-F]+);\s*([0-9A-Za-z]+);">
<xsl:matching-substring>
<c hex="U{if(string-length(regex-group(1))=4) then '0' else ''}{regex-group(1)}" id="{regex-group(2)}"/>
</xsl:matching-substring>
</xsl:analyze-string>
</xsl:for-each>
</m>
</xsl:variable>


<xsl:strip-space elements="group"/>

<xsl:output
  method="text"
  />


<xsl:variable name="top"> produced by the XSL script entities.xsl
     from input data in unicode.xml.

     Copyright 1998 - 2016 W3C.

     Use and distribution of this code are permitted under the terms of
     either of the following two licences:

     1) W3C Software Notice and License.
        http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231.html


     2) The license used for the WHATWG HTML specification,
        which states, in full:
            You are granted a license to use, reproduce and create derivative
            works of this document.

 
     Please report any errors to David Carlisle
     via the public W3C list www-math@w3.org.

     The numeric character values assigned to each entity
     (should) match the Unicode assignments in Unicode 6.x.
</xsl:variable>

<xsl:variable name="vs1">
     References to the VARIANT SELECTOR 1 character (&amp;#x0FE00;)
     should match the uses listed in Unicode Technical Report 25.
</xsl:variable>

<xsl:variable name="copy1">
     Entity names in this file are derived from files carrying the
     following notice:
</xsl:variable>

<xsl:variable name="copy">
     (C) International Organization for Standardization WQYZ
     Permission to copy in any form is granted for use with
     conforming SGML systems and applications as defined in
     ISO 8879, provided this notice is included in all copies.
</xsl:variable>

<xsl:template match="set">
<xsl:param name="write-file" select="true()"/>
<xsl:variable name="d" select="../@name"/>
<xsl:variable name="f">
<xsl:choose>
<xsl:when test="starts-with(@name,'957')"><xsl:value-of select="substring(@name,11)"/></xsl:when>
<xsl:when test="starts-with(@name,'88')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
<!--
<xsl:when test="starts-with(@name,'html')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
-->
<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:text>&#10;&lt;!ENTITY % </xsl:text>
<xsl:value-of select="$f"/>
<xsl:text> PUBLIC "</xsl:text>
<xsl:value-of select="@fpi"/>
<xsl:text>" "</xsl:text>
<xsl:value-of select="$f"/>
<xsl:text>.ent"&gt;&#10;%</xsl:text>
<xsl:value-of select="$f"/>
<xsl:text>;</xsl:text>
<xsl:if test="$write-file">
<xsl:result-document method="text"  href="{$d}/{$f}.ent">
  <xsl:text>
&lt;!--
     File </xsl:text>
  <xsl:value-of select="$f"/>
  <xsl:text>.ent</xsl:text>
  <xsl:copy-of select="$top"/>
  <xsl:if test="key('set',@name)/../@id[contains(.,'-0FE00')]">
   <xsl:copy-of select="$vs1"/>
  </xsl:if>


  <xsl:choose>
  <xsl:when test="starts-with(@name,'9573') and replace(@name,'2003','1991')=../../group[@name='iso9573-1991']/set/@name">
    <xsl:value-of select="$copy1"/>
    <xsl:value-of select="translate($copy,'WQYZ','1991')"/>
  </xsl:when>
  <xsl:when test="starts-with(@name,'9573')">
    <xsl:value-of select="$copy1"/>
    <xsl:value-of select="translate($copy,'WQYZ','1986')"/>
  </xsl:when>
  <xsl:when test="starts-with(@name,'9573-2003')">
    <xsl:value-of select="translate($copy,'WQYZ','2003')"/>
  </xsl:when>
  <xsl:when test="starts-with(@name,'9573-2004')">
    <xsl:value-of select="translate($copy,'WQYZ','2004')"/>
  </xsl:when>
  <xsl:when test="starts-with(@name,'8')">
    <xsl:value-of select="$copy1"/>
    <xsl:value-of select="translate($copy,'WQYZ','1986')"/>
  </xsl:when>
  </xsl:choose>
  <xsl:text>
-->
</xsl:text>

&lt;!-- 

       <xsl:if test="@fpi">Public identifier: <xsl:value-of select="@fpi"/>//XML</xsl:if>
       System identifier: http://www.w3.org/2003/entities/<xsl:value-of select="$d"/>/<xsl:value-of select="$f"/>.ent

     <xsl:if test="@fpi">The public identifier should always be used verbatim.
     </xsl:if>The system identifier may be changed to suit local requirements.

     Typical invocation:

       &lt;!ENTITY % <xsl:value-of select="$f"/><xsl:if test="@fpi"> PUBLIC
         "<xsl:value-of select="@fpi"/>//XML"</xsl:if><xsl:if test="not(@fpi)"> SYSTEM</xsl:if>
         "http://www.w3.org/2003/entities/<xsl:value-of select="$d"/>/<xsl:value-of select="$f"/>.ent"
       >
       %<xsl:value-of select="$f"/>;

<xsl:text>-->

</xsl:text>
  <xsl:if test="$plane1hack and key('set',@name)/../@id[starts-with(.,'U1D')]">
   <xsl:text>&lt;!ENTITY % plane1D  "&amp;#38;#38;#x1D">

</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="key('set',@name)">
    <xsl:sort lang="en" select="@id"/>
    <xsl:sort lang="en" select="not(@optional)"/>
  </xsl:apply-templates>
</xsl:result-document>
</xsl:if>

</xsl:template>

<xsl:template match="entity">
    <xsl:variable name="a" select="string(../@id)"/>
    <xsl:variable name="b" select="string(key('mml2',@id,$mml2)/@val)"/>
    <xsl:variable name="n" select="@set"/>
<!--
    <xsl:if test="not($a=$b) and $n=/unicode/entitygroups/group[@name='mathml']/set/@name">
      <xsl:message>mathml2: <xsl:value-of select="@id,$a,$b"/></xsl:message>
    </xsl:if>
-->
    <xsl:variable name="ad" select="string(../@dec)"/>
    <xsl:variable name="c" select="string(key('mml2',@id,$xhtml1)/@dec)"/>
<!--
    <xsl:if test="not($ad=$c) and $n=/unicode/entitygroups/group[@name='xhtml1']/set/@name">
      <xsl:message>xhtml1: <xsl:value-of select="@id,$ad,$c"/></xsl:message>
    </xsl:if>
-->
    <xsl:variable name="m" select="key('m',@id,$mathmap)/@hex"/>
<!--
    <xsl:if test="exists($m) and not($a=$m)">
           <xsl:message>unicode tr: <xsl:value-of select="@id,',',$a,',',$m"/></xsl:message>
    </xsl:if>
-->
<!--
    <xsl:if test="../unicodedata/@decomp[not(contains(.,'&lt;'))]">
     <xsl:message>DECOMP: <xsl:value-of select="@id,../@id,':',../unicodedata/@decomp"/></xsl:message>
    </xsl:if>
-->
    <xsl:if test="@optional">
      <xsl:text/>&lt;!ENTITY % <xsl:value-of select="@optional"/> "<xsl:value-of select="@default"/>"&gt;&#10;<xsl:text/>
      <xsl:text/>&lt;![%<xsl:value-of select="@optional"/>;[<xsl:text/>
    </xsl:if>
    <xsl:if test="../description/@unicode='none'">&lt;!--</xsl:if>
    <xsl:text>&lt;!ENTITY </xsl:text>
    <xsl:value-of  select="@id"/>
    <xsl:value-of select="substring('               ',string-length(@id))"/>
    <xsl:text> "</xsl:text>
    <xsl:choose>
    <xsl:when test="'60' = ../@dec or '38' = ../@dec">
      <xsl:text>&amp;#38;#</xsl:text><xsl:value-of select="../@dec"/>
    </xsl:when>
    <xsl:when test="$plane1hack and starts-with(../@id,'U1D')">
      <xsl:text>%plane1D;</xsl:text><xsl:value-of select="substring(../@id,4)"/>
    </xsl:when>
    <xsl:when test="starts-with(../description,'COMBINING') and $guard-combining">
      <xsl:text> &amp;#x</xsl:text><xsl:value-of select="substring(../@id,2)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text/>&amp;<xsl:if test="starts-with(../@dec,'60-')">#38;</xsl:if>#x<xsl:text/>
      <xsl:value-of select="replace(translate(../@id,'Ux',''),'-',';&amp;#x')"/>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:text>;" &gt;</xsl:text>
    <xsl:if test="../description/@unicode='none'"> --&gt;</xsl:if>
    <xsl:text>&lt;!--</xsl:text>
    <xsl:value-of select="desc[$olddesc]|../description[not($olddesc)]"/>
    <xsl:if test="../description/@unicode='provisional'"> --&gt;&lt;!-- (Provisional)</xsl:if>
    <xsl:text> --&gt;</xsl:text>
    <xsl:if test="@optional">
      <xsl:text>]]&gt;</xsl:text>
    </xsl:if>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:key name="set" match="entity" use="@set"/>

<xsl:key name="m" match="c" use="@id"/>

<xsl:template match="/">
  <xsl:apply-templates select="unicode/entitygroups/group[@name='2007']"/>
</xsl:template>


<xsl:template match="charlist"/>

<xsl:template match="group[@name='2007']">

<xsl:result-document method="text"  href="2007/w3centities.ent">
  <xsl:call-template name="preamble">
    <xsl:with-param name="name" select="'Combined Set'"/>
    <xsl:with-param name="file" select="'w3centities'"/>
    <xsl:with-param name="write-file" select="false()"/>
  </xsl:call-template>
  <xsl:apply-templates select="set"/>
</xsl:result-document>
<xsl:result-document method="text"  href="2007/w3centities-f.ent">
  <xsl:call-template name="preamble">
    <xsl:with-param name="name" select="'Combined Set'"/>
    <xsl:with-param name="file" select="'w3centities-f'"/>
    <xsl:with-param name="write-file" select="true()"/>
  </xsl:call-template>
  <xsl:for-each-group select="key('set',set/@name)" group-by="@id">
    <xsl:sort select="@id"/>
    <xsl:apply-templates select="."/>
  </xsl:for-each-group>
</xsl:result-document>
<xsl:result-document method="text"  href="2007/htmlmathml.ent">
  <xsl:call-template name="preamble">
    <xsl:with-param name="name" select="'HTML MathML Set'"/>
    <xsl:with-param name="file" select="'htmlmathml'"/>
    <xsl:with-param name="write-file" select="false()"/>
  </xsl:call-template>
  <xsl:apply-templates select="../group[@name='html5']/set">
    <xsl:with-param name="write-file" select="false()"/>
  </xsl:apply-templates>
<xsl:apply-templates select="../group[@name='mathml']/set">
    <xsl:with-param name="write-file" select="false()"/>
</xsl:apply-templates>
</xsl:result-document>
<xsl:result-document method="text"  href="2007/htmlmathml-f.ent">
  <xsl:call-template name="preamble">
    <xsl:with-param name="name" select="'HTML MathML Set'"/>
    <xsl:with-param name="file" select="'htmlmathml-f'"/>
    <xsl:with-param name="write-file" select="true()"/>
  </xsl:call-template>
    <xsl:for-each-group select="key('set',../group[@name=('mathml','html5')]/set/@name)" group-by="@id">
    <xsl:sort select="@id"/>
    <xsl:apply-templates select="."/>
    </xsl:for-each-group>
</xsl:result-document>

<xsl:result-document method="text"  href="2007/htmlmathml.json">
 <xsl:text>&#10;{</xsl:text>
 <xsl:text>&#10; "characters": {</xsl:text>
    <xsl:for-each-group select="key('set',../group[@name=('mathml','html5')]/set/@name)" group-by="@id">
    <xsl:sort select="@id"/>
    <xsl:if test="position()!=1">,</xsl:if>
    <xsl:text>&#10;  </xsl:text>
    <xsl:apply-templates select="." mode="json"/>
    </xsl:for-each-group>
 <xsl:text>&#10; },</xsl:text>
 <xsl:text>&#10; "optional-;": [</xsl:text>
         <xsl:for-each-group select="key('set',../group[@name=('mathml','html5')]/set/@name)[@optional-semi]" group-by="@id">
	  <xsl:sort select="@id"/>
	  <xsl:if test="position()!=1">, </xsl:if>
	  <xsl:value-of select="concat('&quot;',@id,'&quot;')"/>
	 </xsl:for-each-group>
 <xsl:text>]</xsl:text>
 <xsl:text>&#10;}&#10;</xsl:text>
</xsl:result-document>

</xsl:template>


<xsl:template match="group[@name='predefined']"/>
<xsl:template match="group[@name='mathml']">
 <xsl:apply-templates select="set[starts-with(@name,'m')]"/>
</xsl:template>


<xsl:template name="preamble">
  <xsl:param name="name"/>
  <xsl:param name="file"/>
  <xsl:param name="write-file"/>
&lt;!-- 
     Copyright 1998 - 2016 W3C.

     Use and distribution of this code are permitted under the terms of
     either of the following two licences:

     1) W3C Software Notice and License.
        http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231.html


     2) The license used for the WHATWG HTML specification,
        which states, in full:
            You are granted a license to use, reproduce and create derivative
            works of this document.


     Please report any errors to David Carlisle
     via the public W3C list www-math@w3.org.

<xsl:choose>
 <xsl:when test="$name='HTML MathML Set'">
       Public identifier:  web-entities
       Public identifier: -//W3C//ENTITIES HTML MathML Set//EN//XML
       System identifier: http://www.w3.org/2003/entities/2007/htmlmathml-f.ent

     One of the public identifiers should always be used verbatim.
     (The first one is more suitable for XHTML, the second one uses
     Formal Public Identifier syntax, that may be required by SGML systems.)
     The system identifier may be changed to suit local requirements.

     Typical invocations:

       &lt;!ENTITY % htmlmathml-f PUBLIC
         "-//W3C//ENTITIES HTML MathML Set//EN//XML"
         "http://www.w3.org/2003/entities/2007/htmlmathml-f.ent"
       >
       %<xsl:value-of select="$file"/>;

       &lt;DOCTYPE html PUBLIC "web-entities"
                            "http://www.w3.org/2003/entities/2007/htmlmathml-f.ent"
       >
</xsl:when>
 <xsl:otherwise>
       Public identifier: -//W3C//ENTITIES <xsl:value-of select="$name"/>//EN//XML
       System identifier: http://www.w3.org/2003/entities/2007/<xsl:value-of select="$file"/>.ent

     The public identifier should always be used verbatim.
     The system identifier may be changed to suit local requirements.

     Typical invocation:

       &lt;!ENTITY % <xsl:value-of select="$file"/> PUBLIC
         "-//W3C//ENTITIES <xsl:value-of select="$name"/>//EN//XML"
         "http://www.w3.org/2003/entities/2007/<xsl:value-of select="$file"/>.ent"
       >
       %<xsl:value-of select="$file"/>;
 </xsl:otherwise>
</xsl:choose>
<xsl:if test="false() and $write-file">
     Some entity names in this file are derived from files carrying the
     following notices:

     (C) International Organization for Standardization 1986,1991
     Permission to copy in any form is granted for use with
     conforming SGML systems and applications as defined in
     ISO 8879, provided this notice is included in all copies.
</xsl:if>

-->

</xsl:template>


<xsl:template match="entity" mode="json">
    <xsl:variable name="a" select="string(../@id)"/>
    <xsl:variable name="b" select="string(key('mml2',@id,$mml2)/@val)"/>
    <xsl:variable name="n" select="@set"/>
    <xsl:variable name="ad" select="string(../@dec)"/>
    <xsl:variable name="c" select="string(key('mml2',@id,$xhtml1)/@dec)"/>
    <xsl:variable name="m" select="key('m',@id,$mathmap)/@hex"/>
    <xsl:if test="../description/@unicode='none'">&lt;!--</xsl:if>
    <xsl:text>"</xsl:text>
    <xsl:value-of  select="@id"/>
    <xsl:text>": "</xsl:text>
    <xsl:choose>
    <xsl:when test="not(starts-with(../@id,'U0'))">
     <xsl:variable name="n" select="number(replace(../@dec,'-.*','')) - 65536"/>
      <xsl:text>\u</xsl:text>
      <xsl:value-of select="d:dtoh(($n idiv 1024) + 55296)"/>
      <xsl:text>\u</xsl:text>
      <xsl:value-of select="d:dtoh(($n mod 1024) + 56320)"/>
      <xsl:if test="contains(../@dec,'-')">
       <xsl:text>!!!!!!</xsl:text>
       <xsl:message select="../@dec"/>
       <xsl:value-of select="../@dec"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="starts-with(../description,'COMBINING')">
      <xsl:text> \u</xsl:text><xsl:value-of select="substring(../@id,3)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="replace(../@id,'[U\-]0','\\u')"/>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:text>"</xsl:text>
</xsl:template>



<xsl:variable name="hexd" select="('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','0')"/>
<xsl:function name="d:dtoh">
   <xsl:param name="d"/>
     <xsl:value-of select="if($d gt 16) then d:dtoh($d idiv 16) else '',$hexd[1+($d mod 16)]" separator=""/>
</xsl:function>

</xsl:stylesheet>
