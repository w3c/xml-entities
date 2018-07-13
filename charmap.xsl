<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">


<xsl:strip-space elements="group"/>

<xsl:output
  method="xml" indent="no" encoding="US-ASCII" omit-xml-declaration="yes"
  />

 

<xsl:variable name="top"> produced by the XSL script charmap.xsl
     from input data in unicode.xml.

     Copyright 2003 - 2013 W3C.

     Use and distribution of this code are permitted under the terms of the
     W3C Software Notice and License.
     http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231.html

     Please report any errors to David Carlisle
     via the public W3C list www-math@w3.org.

     The numeric character values assigned to each entity
     (should) match the Unicode assignments in Unicode 5.2.
</xsl:variable>


<xsl:variable name="copy">
     Entity names in this file are derived from files carrying the
     following notice:

     (C) International Organization for Standardization 19XY
     Permission to copy in any form is granted for use with
     conforming SGML systems and applications as defined in
     ISO 8879, provided this notice is included in all copies.
</xsl:variable>

<xsl:template match="set">
  <xsl:variable name="d" select="../@name"/>
  <xsl:variable name="f">
    <xsl:choose>
      <xsl:when test="starts-with(@name,'957')"><xsl:value-of select="substring(@name,11)"/></xsl:when>
      <xsl:when test="starts-with(@name,'88')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  
  <xsl:text>&#10;  </xsl:text>
  <xsl:element name="xsl:import">
    <xsl:attribute name="href"><xsl:value-of select="$f"/>map.xsl</xsl:attribute>
  </xsl:element>
  
  <xsl:result-document  href="{$d}/{$f}map.xsl">
    <xsl:text>&#10;</xsl:text>
    <xsl:comment>
      <xsl:text>&#10;     File </xsl:text>
      <xsl:value-of select="$f"/>map.xsl<xsl:text/>
      <xsl:copy-of select="$top"/>
      
      <xsl:choose>
	<xsl:when test="starts-with(@name,'9573') and replace(@name,'2003','1991')=../../group[@name='iso9573-1991']/set/@name">
	  <xsl:value-of select="translate($copy,'XY','86')"/>
	</xsl:when>
	<xsl:when test="starts-with(@name,'9')">
	  <xsl:value-of select="translate($copy,'XY','91')"/>
	</xsl:when>
	<xsl:when test="starts-with(@name,'8')">
	  <xsl:value-of select="translate($copy,'XY','86')"/>
	</xsl:when>
      </xsl:choose>
    </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xsl:element name="xsl:stylesheet">
      <xsl:attribute name="version">2.0</xsl:attribute>
      <xsl:text>&#10;</xsl:text>
      <xsl:element name="xsl:character-map">
	<xsl:attribute name="name"><xsl:value-of select="$f"/></xsl:attribute>
	
	
	<xsl:for-each select="key('set',@name)">
	  <xsl:sort lang="en" select="@id"/>
	  <xsl:sort lang="en" select="not(@optional)"/>
	  <xsl:text>&#10;  </xsl:text>
	  <xsl:choose>
	    <xsl:when test="not(contains(../@id,'-') or ../@dec &lt; 128)">
	      <xsl:element name="xsl:output-character">
		<xsl:attribute name="character">
		  <xsl:value-of select="codepoints-to-string(../@dec)"/>
		</xsl:attribute>
		<xsl:attribute name="string">
		  <xsl:text>&amp;</xsl:text>
		  <xsl:value-of  select="@id"/>
		  <xsl:text>;</xsl:text>
		</xsl:attribute>
	      </xsl:element>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:comment>
		<xsl:value-of select="../@id"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@id"/>
	      </xsl:comment>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
	<xsl:text>&#10;</xsl:text>
      </xsl:element>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:element>
    <xsl:text>&#10;</xsl:text>
  </xsl:result-document>
  
</xsl:template>


<xsl:key name="set" match="entity" use="@set"/>

<xsl:template match="/">
  <xsl:apply-templates select="unicode/entitygroups/group[@name='2007']"/>
</xsl:template>

<xsl:template match="group[@name='predefined']"/>

<xsl:template match="group">
  
  <xsl:result-document href="{@name}/entitynamesmap.xsl">
    <xsl:element name="xsl:stylesheet">
      <xsl:attribute name="version">2.0</xsl:attribute>
      <xsl:text>&#10;</xsl:text>
      <xsl:comment>
	<xsl:text>&#10;     entitynamesmap.xsl</xsl:text>
	<xsl:copy-of select="$top"/>
	<xsl:text>&#10;</xsl:text>
      </xsl:comment>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates select="set"/>
      <xsl:text>&#10;&#10;  </xsl:text>
      <xsl:element name="xsl:character-map">
	<xsl:attribute name="name">
	  <xsl:value-of select="if(@name='2007') then 'w3c-entity-names' else @name"/>
	</xsl:attribute>
	<xsl:attribute name="use-character-maps">
	  <xsl:for-each select="set">
	    <xsl:text> </xsl:text>
	    <xsl:choose>
	      <xsl:when test="starts-with(@name,'957')"><xsl:value-of select="substring(@name,11)"/></xsl:when>
	      <xsl:when test="starts-with(@name,'88')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
	      <xsl:when test="@name='html5-uppercase'"><xsl:value-of select="@name"/></xsl:when>
	      <xsl:when test="starts-with(@name,'html')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
	      <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>
	</xsl:attribute>
      </xsl:element>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:element>
    <xsl:text>&#10;</xsl:text>
  </xsl:result-document>

  <xsl:result-document href="{@name}/htmlmathml.xsl">
    <xsl:element name="xsl:stylesheet">
      <xsl:attribute name="version">2.0</xsl:attribute>
      <xsl:text>&#10;</xsl:text>
      <xsl:comment>
	<xsl:text>&#10;     htmlmathml.xsl</xsl:text>
	<xsl:copy-of select="$top"/>
	<xsl:text>&#10;</xsl:text>
      </xsl:comment>
      <xsl:text>&#10;</xsl:text>

<xsl:for-each select="set[@name=../../group[@name=('mathml','html5')]/set/@name]">
  <xsl:variable name="d" select="../@name"/>
  <xsl:variable name="f">
    <xsl:choose>
      <xsl:when test="starts-with(@name,'957')"><xsl:value-of select="substring(@name,11)"/></xsl:when>
      <xsl:when test="starts-with(@name,'88')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  
  <xsl:text>&#10;  </xsl:text>
  <xsl:element name="xsl:import">
    <xsl:attribute name="href"><xsl:value-of select="$f"/>map.xsl</xsl:attribute>
  </xsl:element>
</xsl:for-each>

      <xsl:text>&#10;&#10;  </xsl:text>
      <xsl:element name="xsl:character-map">
	<xsl:attribute name="name" select="'htmlmathml'"/>
	<xsl:attribute name="use-character-maps">
	  <xsl:for-each select="set[@name=../../group[@name=('mathml','html5')]/set/@name]">
	    <xsl:text> </xsl:text>
	    <xsl:choose>
	      <xsl:when test="starts-with(@name,'957')"><xsl:value-of select="substring(@name,11)"/></xsl:when>
	      <xsl:when test="starts-with(@name,'88')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
	      <xsl:when test="@name='html5-uppercase'"><xsl:value-of select="@name"/></xsl:when>
	      <xsl:when test="starts-with(@name,'html')"><xsl:value-of select="substring-after(@name,'-')"/></xsl:when>
	      <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>
	</xsl:attribute>
      </xsl:element>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:element>
    <xsl:text>&#10;</xsl:text>
  </xsl:result-document>
</xsl:template>


</xsl:stylesheet>
