<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>

<xsl:template match="/">
var nms=[];
<xsl:for-each select="//character[not(contains(@dec,'-'))]">
nms[<xsl:value-of select="@dec"/>]='<xsl:value-of select="description"/>
<xsl:text>';</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>