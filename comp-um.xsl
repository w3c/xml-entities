<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		>
 <xsl:output method="text"/>
 
 <xsl:variable name="u" select="doc('unicode.xml')"/>
 <xsl:variable name="umt" select="unparsed-text-lines('../../wspr/unicode-math/unicode-math-table.tex')"/>

 <xsl:template name="m">
  <xsl:value-of>
#	N - Normal - includes all digits and symbols requiring only one form
#	A - Alphabetic
#	B - Binary
#	C - Closing - usually paired with opening delimiter
#	D - Diacritic
#	F - Fence - unpaired delimiter (often used as opening or closing)
#	G - Glyph_Part - piece of large operator
#	L - Large - n-ary or large operator, often takes limits
#	O - Opening - usually paired with closing delimiter
#	P - Punctuation
#	R - Relation - includes arrows
#	S - Space
#	U - Unary - operators that are only unary
#	V - Vary - operators that can be unary or binary depending on context
#	X - Special - characters not covered by other classes

------
               not(
		      (@mathclass='R' and $um='\mathrel')
		   or (@mathclass='B' and $um='\mathbin')
		   or (@mathclass='V' and $um='\mathbin')
		   or (@mathclass='A' and $um='\mathalpha')
		   or (@mathclass='N' and $um='\mathord')
		   or (@mathclass='G' and $um='\mathord')
		   or (@mathclass='U' and $um='\mathord')
		   or (@mathclass='O' and $um='\mathopen')
		   or (@mathclass='C' and $um='\mathclose')
		   or (@mathclass='P' and $um='\mathpunct')
		   or (@mathclass='F' and $um='\mathfence')
		   or (@mathclass='L' and $um='\mathop')
		   or (@mathclass='D' and $um='\mathaccent')
		   )

------
		   
</xsl:value-of>
  <xsl:for-each select="$u//character[unicodedata[@mathclass] or mathlatex[@set='unicode-math']]">
   <xsl:choose>
    <xsl:when test="mathlatex[@set='unicode-math']">    
     <xsl:variable name="cs" select="
				     if(contains(description,'GREEK'))
				     then
				     replace(mathlatex[@set='unicode-math'],'\\','\\m?')
				     else
				     replace(mathlatex[@set='unicode-math'],' ','space')
"/>
     <xsl:variable name="re"  select="concat('.*\',$cs,' *\}\{([^\{\}]*)\}.*')"/>
     <xsl:variable name="um" select="($umt[matches(.,$re)]!replace(.,$re,'$1'),'???')[1]"/>
     <xsl:if test="unicodedata/not(
		      (@mathclass='R' and $um='\mathrel')
		   or (@mathclass='B' and $um='\mathbin')
		   or (@mathclass='V' and $um='\mathbin')
		   or (@mathclass='A' and $um='\mathalpha')
		   or (@mathclass='N' and $um='\mathord')
		   or (@mathclass='G' and $um='\mathord')
		   or (@mathclass='U' and $um='\mathord')
		   or (@mathclass='O' and $um='\mathopen')
		   or (@mathclass='C' and $um='\mathclose')
		   or (@mathclass='P' and $um='\mathpunct')
		   or (@mathclass='F' and $um='\mathfence')
		   or (@mathclass='L' and $um='\mathop')
		   or (@mathclass='D' and $um='\mathaccent')
		   )">
      <xsl:value-of select="@id, ' | ',
			    $cs,substring($pad,string-length($cs)), ' | ',
			    (unicodedata/@mathclass,'!')[1],' | ',
			    $um,substring($pad2,string-length($um)), ' | ',
			    description,'&#10;'" separator=""/>
     </xsl:if>
    </xsl:when>
    <xsl:when test="@dec &lt; 128"/>
    <xsl:otherwise>
     <xsl:value-of select="@id, ' | ***                        | ',
			   unicodedata/@mathclass,
			   ' | ***                | ',
			   description,'&#10;'" separator=""/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:for-each>
 </xsl:template>

 <xsl:variable name="pad" select="'                         '"/>
 <xsl:variable name="pad2" select="'                 '"/>
 
</xsl:stylesheet>
 
 
 
