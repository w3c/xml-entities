<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>

<xsl:template match="/">
var nms=[];
<xsl:for-each select="//character[not(contains(@dec,'-'))]">
 nms[<xsl:value-of select="@dec"/>]='<xsl:text/>
 <xsl:value-of select="description"/>
 <xsl:if test="entity|mathlatex[@set='unicode-math']|latex">
  <xsl:text>     </xsl:text>
 </xsl:if>
 <xsl:value-of select="distinct-values((
		       entity/concat('&amp;amp;',@id,';'),
                       (mathlatex[@set='unicode-math'],latex)/
		       normalize-space(replace(.,'([\\''])','\\$1'))))
		       "/>
<xsl:text>';</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
