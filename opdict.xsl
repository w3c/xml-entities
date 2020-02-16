<xsl:stylesheet version="3.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="xs">

 <xsl:output method="html" version="5"/>

 <xsl:template match="/">
  <html>
   <head>
    <title>Opt Dict</title>
    <style>
     body {max-width:60em;font-family:"Stix Two Math", "Cambria Math", "STIX Math", "Asana Math"}
     dt {font-weight: bold}
     
    </style>
   </head>
   <body>
    <h1>MathML Operator Dictionary</h1>
    <xsl:for-each-group select="//operator-dictionary"
			group-by="concat('form:',@form,' lspace:',@lspace,' rspace:',@rspace)">
     <dl>
      <dt>
       <xsl:value-of select="current-grouping-key()"/>
      </dt>
      <dd>
       <dl>
	<xsl:for-each-group select="current-group()" group-by="string(@priority)">
	 <xsl:sort select="number(@priority)"/>
	 <dt>Priority: <xsl:value-of select="@priority"/></dt>
	 <dd>
       <xsl:for-each select="current-group()">
	<xsl:if test="position()!=1">, </xsl:if>
	<span title="{../@id}{'&#10;accent'[current()/@accent='true']}{'&#10;stretchy'[current()/@stretchy='true']}{concat('&#10;priority:',current()/@priority)[current()/@priority]}{'&#10;'}{../lower-case(description)}">
	 <xsl:choose>
	  <xsl:when test="../@id=('U02061','U02062','U02063','U02064') or starts-with(../@id,'U1E')">
	   <xsl:text>&#x27e8;</xsl:text>
	   <span style="font-size:80%;font-style:italic">
	    <xsl:value-of select="lower-case(../description)"/>
	   </span>
	   <xsl:text>&#x27e9;</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	   <xsl:value-of select="codepoints-to-string(../tokenize(@dec,'-')!xs:int(.))"/>
	  </xsl:otherwise>
	 </xsl:choose>
	</span>
       </xsl:for-each>
	 </dd>
	</xsl:for-each-group>
       </dl>
      </dd>
     </dl>
    </xsl:for-each-group>
   </body>
  </html>
 </xsl:template>
</xsl:stylesheet>
