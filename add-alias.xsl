<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="aliases" select="doc('aliases.xml')"/>
<xsl:output encoding="US-ASCII" omit-xml-declaration="yes"/>

<xsl:template match="/">
     <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="unicode.xsl"</xsl:processing-instruction>
    <xsl:text>&#10;</xsl:text>
    <xsl:copy-of select="comment()"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="processing-instruction()|comment()" priority="2"/>

<xsl:template match="node()|@*">
 <xsl:copy>
  <xsl:copy-of select="@*"/>
  <xsl:apply-templates/>
 </xsl:copy>
</xsl:template>

<xsl:key name="alias" match="tr" use="concat(
   'U',
   if(string-length(td/a)=4) then '0' else '',
   td/a)
   "/>
<xsl:template match="unicodedata">
 <xsl:copy>
  <xsl:copy-of select="@* except @alias"/>
  <xsl:if test="key('alias',../@id,$aliases)">
   <xsl:attribute name="alias"
		  select="string-join(
			  key('alias',../@id,$aliases)/td[1],';'
			  )">
   </xsl:attribute>
  </xsl:if>
 </xsl:copy>
</xsl:template>

</xsl:stylesheet>
