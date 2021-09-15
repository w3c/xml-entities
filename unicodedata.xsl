<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:d="data:,dpc"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="d xs">
  
<xsl:strip-space elements="*"/>
<xsl:output indent="yes" encoding="US-ASCII" omit-xml-declaration="yes"/>
<!--
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-5.1.0d10.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-5.2.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-6.0.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-p.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-6.1.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-6.2.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-6.3.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-7.0.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-8.0.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-9.0.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-10.0.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-11.0.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-12.0.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-12.1.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-13.0.0.txt'),'[&#10;&#13;]+')"/>
-->
<xsl:variable name="UD" select="tokenize(unparsed-text('UnicodeData-14.0.0.txt'),'[&#10;&#13;]+')"/>
<xsl:variable name="uc" select="doc('unicode.xml')"/>
<xsl:variable name="comb" select="doc('combine.xml')"/>
<!--
<xsl:variable name="MC" select="'MathClass-11.txt'"/>
<xsl:variable name="MC" select="'MathClass-13.txt'"/>
-->
<xsl:variable name="MC" select="'MathClass-15.txt'"/>

<xsl:variable name="mathclass">
<xsl:for-each select="tokenize(unparsed-text($MC),'[&#10;&#13;]+')[matches(.,'^[0-9A-F.]+;[A-Z]')]">
<mc c="{substring-before(.,';')}"><xsl:value-of select="substring-after(.,';')"/></mc>
</xsl:for-each>
</xsl:variable>
<xsl:key name="mathclass" match="mc" use="if(contains(@c,'..'))
then
(d:hexs(substring-before(@c,'..')) to d:hexs(substring-after(@c,'..')))
else
d:hexs(@c)
"/>


<xsl:key name="char" match="character" use="@id"/>

<xsl:template name="main">
  <xsl:result-document href="uc-new.xml">
    <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="unicode.xsl"</xsl:processing-instruction>
    <xsl:text>&#10;</xsl:text>
    <xsl:copy-of select="$uc/comment()"/>
    <xsl:text>&#10;</xsl:text>
    <unicode>
      <xsl:copy-of select="$uc/unicode/(@*,node() except charlist)"/>
      <charlist>
      <xsl:perform-sort>
	<xsl:sort select="@id"/>
	<xsl:sequence select="$uc/unicode/charlist/character"/>
	<xsl:for-each select="$UD">
	  <xsl:analyze-string select="." regex="^([^;]*);([A-Z][^;]*);([^;]*);.*">
	    <xsl:matching-substring>
	      <!--
		  <xsl:message>
		  <xsl:value-of select="position(),'===',.,concat('U',if(string-length(regex-group(1))=4) then '0' else '',regex-group(1))"/>
		  </xsl:message>
	      -->
	      <xsl:if test="not(key('char',concat('U',if(string-length(regex-group(1))=4) then '0' else '',regex-group(1)),$uc))">
		<character id="{concat('U',if(string-length(regex-group(1))=4) then '0' else '',regex-group(1))}"
			   dec="{d:hexs(regex-group(1))}"
			   image="none">
		  <unicodedata>
		    <xsl:variable name="u" select="tokenize(.,';')"/>
		    <xsl:for-each select="$udfields">
		      <xsl:variable name="p" select="position()"/>
		      <xsl:if test="$p gt 2 and $u[$p]">
			<xsl:attribute name="{.}" select="$u[$p]"/>
		      </xsl:if>
		    </xsl:for-each>
<xsl:message select="'@@',."/>
		    <xsl:if test="key('mathclass',d:hexs(.),$mathclass)">
		     <xsl:attribute name="mathclass" select="key('mathclass',d:hexs(.),$mathclass)"/>
		    </xsl:if>
		  </unicodedata>
		  <description unicode="proposed"><xsl:value-of select="regex-group(2)"/></description>
		</character>
	      </xsl:if>
	    </xsl:matching-substring>
	  </xsl:analyze-string>
	</xsl:for-each>
      </xsl:perform-sort>
    </charlist>
    </unicode>
  </xsl:result-document>
</xsl:template>


<xsl:variable name="udfields" select="('code',
				       'name','category','combclass','bidi','decomp','decimal','digit','numeric','mirror','unicode1','comment','upper','lower','title')"/>




<xsl:function name="d:hex" as="xs:integer">
<xsl:param name="x"/>
  <xsl:sequence
    select="if (empty($x)) then 0 else ($x[last()] + 16* d:hex($x[position()!=last()]))"/>
</xsl:function>

<xsl:function name="d:hexs">
  <xsl:param name="x"/>
     <xsl:sequence select="d:hex(
           for $i in string-to-codepoints($x)
           return if ($i &gt; 64) then $i - 55 else $i - 48)"/>
</xsl:function>

<xsl:variable name="hexd" select="('1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','0')"/>
<xsl:function name="d:dtoh">
   <xsl:param name="d"/>
     <xsl:value-of select="'000',$hexd[$d idiv 16],$hexd[$d mod 16]" separator=""/>
</xsl:function>


<xsl:template name="mathclass">
  <xsl:result-document href="uc-new.xml">
    <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="unicode.xsl"</xsl:processing-instruction>
    <xsl:text>&#10;</xsl:text>
    <xsl:copy-of select="$uc/comment()"/>
    <xsl:text>&#10;</xsl:text>
   <xsl:apply-templates mode="mathclass" select="$uc/*"/>
  </xsl:result-document>
</xsl:template>
<xsl:template mode="mathclass" match="node()">
<xsl:copy>
 <xsl:copy-of select="@*"/>
   <xsl:apply-templates mode="mathclass"/>
</xsl:copy>
</xsl:template>
<xsl:template mode="mathclass" match="unicodedata[@category]">
<xsl:copy>
 <xsl:copy-of select="@*"/>
 <xsl:if test="key('mathclass',xs:integer(../@dec),$mathclass)">
  <xsl:attribute name="mathclass" select="key('mathclass',xs:integer(../@dec),$mathclass)[1]"/>
 </xsl:if>

<xsl:if test="key('mathclass',xs:integer(../@dec),$mathclass)[2]">
<xsl:message select="key('mathclass',xs:integer(../@dec),$mathclass)"/>
</xsl:if>
</xsl:copy>
</xsl:template>





<!--  -->

<xsl:variable name="umt">
 <umd>
  <xsl:for-each select="tokenize(unparsed-text('https://raw.githubusercontent.com/wspr/unicode-math/master/unicode-math-table.tex'),
			'[&#10;&#13;]+')[contains(.,'UnicodeMathSymbol')]">
   <xsl:variable name="id" select="replace(.,'.UnicodeMathSymbol\{&quot;([0-9A-F]+)\}.*','$1')"/>
   <character id="U{if(string-length($id)=4) then '0' else ''}{$id}">
    <xsl:value-of select="replace(.,'.UnicodeMathSymbol\{&quot;([0-9A-F]+)\}\{(\\[^{} ]+).*','$2')"/>
   </character>
  </xsl:for-each>
 </umd>
</xsl:variable>

<xsl:template name="unicode-math">
  <xsl:result-document href="uc-new.xml">
    <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="unicode.xsl"</xsl:processing-instruction>
    <xsl:text>&#10;</xsl:text>
    <xsl:copy-of select="$uc/comment()"/>
    <xsl:text>&#10;</xsl:text>
    <unicode>
      <xsl:copy-of select="$uc/unicode/(@*,node() except charlist)"/>
      <charlist>
	<xsl:for-each select="$uc/unicode/charlist/character">
	 <character>
	  <xsl:copy-of select="@*,unicodedata,afii,latex,mathlatex[not(@set='unicode-math')]"/>
	  <xsl:if test="key('char',@id,$umt)">
	   <mathlatex set="unicode-math">
	    <xsl:value-of select="key('char',@id,$umt)"/>
	   </mathlatex>
	  </xsl:if>
	  <xsl:copy-of  select="* except (unicodedata,afii,latex,mathlatex)"/>
	 </character>
	</xsl:for-each>
      </charlist>
    </unicode>
  </xsl:result-document>
</xsl:template>



<xsl:template name="opdict">
  <xsl:result-document href="uc-new.xml">
    <xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="unicode.xsl"</xsl:processing-instruction>
    <xsl:text>&#10;</xsl:text>
    <xsl:copy-of select="$uc/comment()"/>
    <xsl:text>&#10;</xsl:text>
    <unicode>
      <xsl:copy-of select="$uc/unicode/(@*,node() except charlist)"/>
      <charlist>
	<xsl:for-each select="$uc/unicode/charlist/character">
	 <character>
	  <xsl:copy-of select="@*,* except description"/>
	  <xsl:variable name="u" select="substring(@id,2)"/>
	  <xsl:variable name="b" select="
	   /unicode/unicodeblocks/block[
	   @start le $u and @end ge $u]/string(@name)"/>
	  <xsl:choose>
	  <xsl:when test="'023F9' le $u and '02767' ge $u"/>
	  <xsl:when  test="not(operator-dictionary) and number(@dec)
			and
			$b=(
			'Mathematical Operators',
			'Supplemental Mathematical Operators',
			'Miscellaneous Technical',
			'Miscellaneous Symbols',
			'Miscellaneous Symbols and Arrows',
			'Dingbats'
			)
			and
			not(contains(description,'ARROW'))
			">
	   <xsl:message select="$b,string(@id), 999, description/string(@unicode), string(description)"/>
	   <operator-dictionary form="prefix" lspace="5" rspace="5" priority="999"/>
	  </xsl:when>
	  <xsl:when  test="not(operator-dictionary) and number(@dec)
			and
			$b=(
			'Mathematical Operators',
			'Supplemental Mathematical Operators',
			'Miscellaneous Technical',
			'Miscellaneous Symbols',
			'Miscellaneous Symbols and Arrows',
			'Dingbats'
			)
			and
			(contains(description,'ARROW'))
			">
	   <xsl:message select="$b,string(@id), 270, description/string(@unicode), string(description)"/>
	   <operator-dictionary form="infix" lspace="5" rspace="5" priority="270"/>
	  </xsl:when>
	  <xsl:when test="not(operator-dictionary) and number(@dec)
			and
			$b=(
			'Arrows',
			'Supplemental Arrows-A',
			'Supplemental Arrows-B',
			'Supplemental Arrows-C'
			)
			">
	   <xsl:message select="$b,string(@id), 270, description/string(@unicode), string(description)"/>
	   <operator-dictionary form="infix" lspace="5" rspace="5" priority="270"/>
	  </xsl:when>
	  </xsl:choose>
	  <xsl:copy-of  select="description"/>
	 </character>
	</xsl:for-each>
      </charlist>
    </unicode>
  </xsl:result-document>
</xsl:template>


</xsl:stylesheet>
