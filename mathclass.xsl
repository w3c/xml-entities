<xsl:stylesheet version="3.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- generate MathClassEx.txt (for checking) -->

<xsl:output method="text" encoding="UTF-8"/>

<xsl:param name="ex" select="'no'"/>

<xsl:key name="id" match="*[@id]" use="@id"/>

<xsl:variable name="html5" select="distinct-values(/unicode/entitygroups/group[@name=('mathml','html5')]/set/@name)"  />

<xsl:variable name="deprecated" select="'U02329',
					'U0232A',
					'U03014',
					'U03015',
					'U03018',
					'U03019',
					'U0FE35',
					'U0FE36',
					'U0FE37',
					'U0FE38'
					"/>

<xsl:template match="unicode">
<xsl:value-of select="'# File: MathClass','Ex'[$ex='yes'],'.txt'" separator=""/>
<xsl:text>
# Revision: 16.0
# Date: 2025-07-01
#
# © 2025 Unicode®, Inc.
# Unicode and the Unicode Logo are registered trademarks of Unicode, Inc. in the U.S. and other countries.
# For terms of use, see http://www.unicode.org/terms_of_use.html
# For documentation, see http://www.unicode.org/reports/tr25/
#
# ------------------------------------------------
# This file is a classification of characters based on their usage in
# mathematical notation</xsl:text>
<xsl:if test="$ex=yes"> and providing a mapping to standard entity
# sets commonly used for SGML and MathML documents</xsl:if><xsl:text>.
#
# While the contents of this file represent the best information
# available to the authors and the Unicode Technical Committee as
# of the date referenced above, it is likely that the information
# in this file will change from time to time.
#
# This file is *NOT* formally part of the Unicode Character Database
# at this time.
#
# The character encoding of this plain-text file is UTF-8.
#
# The data consists of </xsl:text>
<xsl:value-of select ="if($ex='yes') then
  '8  fields. The number and type of fields may change
  # in future versions of this file.'
  else '2 fields.'"/>
<xsl:text>
#
# 1: code point or range
#
# 2: class, one of:
#
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
#
</xsl:text>
<xsl:if test="$ex='yes'">
<xsl:text># The C, O, and F operators are stretchy. In addition, some binary operators such
# as U+002F are stretchy as noted in the descriptive comments. The classes are
# also useful in determining extra spacing around the operators as discussed
# in UTR #25.
#
# 3: entity name
#
# 4: entity set
#
# 5: descriptive comments (of various types)
# The descriptive comments provide more information about a character,
# or its specific appearance. Some descriptions contain common macro
# names (with slash) but in the majority of cases, the description is
# simply the description of the entity in the published entity set, if
# different from the formal Unicode character name. Minor differences
# in word order, punctuation and verb forms have been ignored, but not
# systematic differences in terminology, such as filled vs. black.
# In principle this allows location of entities by their description.
#
# 6: Comment with Unicode General Category, character (UTf-8)
#    and Unicode character name or names
#    Character names are provided for ease of reference only.
#
</xsl:text>
</xsl:if>
<xsl:text># Fields are delimited by ';'.
# Spaces adjacent to the delimiter or the '#' are not significant
# Future versions of this file may use different amounts of whitespace.
#
# Some character positions in the Mathematical Alphanumeric Symbols block are
# reserved and have been mapped to the Letterlike Symbols block in Unicode.
# This is indicated in 24 special purpose comments.
#
# The character repertoire of this revision is the repertoire of Unicode
# Version </xsl:text>
<xsl:value-of select="@unicode"/>
<xsl:text>.0. For more information see Revision 16 or later of UTR #25.
# ------------------------------------------------
</xsl:text>

<xsl:text>&#10;</xsl:text>
<xsl:text>#code point;class</xsl:text>
<xsl:if test="$ex='yes'"><xsl:text>;entity;set;note/description # comment/Unicode name</xsl:text></xsl:if>
<xsl:text>&#10;</xsl:text>

<xsl:for-each select="charlist/character/(unicodedata[@mathclass or ../@id=$deprecated]|bmp)">
  <xsl:choose>
    <xsl:when test="../@id=('U02329','U03014','U03018')">
      <xsl:value-of select="'#',replace(../@id,'^U0?',''),';O',';;; # '[$ex='yes'],'&#10;'" separator=""/>
    </xsl:when>
    <xsl:when test="../@id=('U0232A','U03015','U03019')">
      <xsl:value-of select="'#',replace(../@id,'^U0?',''),';C',';;; # '[$ex='yes'],'&#10;'" separator=""/>
    </xsl:when>
    <xsl:when test="../@id=('U0FE35','U0FE36','U0FE37','U0FE38')">
      <xsl:value-of select="'#',replace(../@id,'^U0?',''),';',';;; # '[$ex='yes'],'&#10;'" separator=""/>
    </xsl:when>
    <xsl:when test="self::bmp">
      <xsl:value-of select="'#',replace(../@id,'^U0?',''),'=',
	replace(@ref,'^U0?',''), ';',
        key('id',@ref)/unicodedata/@mathclass,
	';;; # '[$ex='yes'],'&#10;'
	" separator=""/>
    </xsl:when>
    <xsl:otherwise>
  <xsl:value-of select="
			replace(../@id,'^U0?',''),';',
			@mathclass, (';',
			replace(string-join(distinct-values(../entity[@set=$html5]/@id),' '), 'amp AMP','AMP amp'), ';',
			if (../entity[@set=$html5]/@id) then 'HTML-MathML' else '', ';',
			(), ' # ',
			 @category, ' ',
			'(',codepoints-to-string(../@dec),') ',
			../description)[$ex='yes'],
			'&#10;'
			"
		separator=""/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:for-each>
<xsl:text>&#10;# EOF&#10;</xsl:text>
</xsl:template>

  
</xsl:stylesheet>
