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
     th {text-align:left;}
     
    </style>
    <xsl:text>&#10;</xsl:text>
    <script type='text/javascript' src='sorttable.js'></script>
    <xsl:text>&#10;</xsl:text>
   </head>
   <body>
    <h1>MathML Operator Dictionary</h1>

    <hr/>
    <ul>
     <li><a href="#compressed">Compressed View</a></li>
     <li><a href="#stable">Sortable Table View</a></li>
    </ul>
    <hr/>

    <h2 id="compressed">Compressed view</h2>
    <xsl:for-each-group select="//operator-dictionary"
			group-by="concat('form:',@form,' lspace:',@lspace,' rspace:',@rspace)">
     <xsl:sort select="current-grouping-key()"/>
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
	<span title="{
		     replace(replace(../@id,'U0?','U+'),'-0','&#160;U+')}{
		     '&#10;accent'[current()/@accent='true']}{
		     '&#10;fence'[current()/@fence='true']}{
		     '&#10;stretchy'[current()/@stretchy='true']}{
		     '&#10;largeop'[current()/@largeop='true']}{
		     '&#10;symmetric'[current()/@symmetric='true']}{
		     '&#10;movablelimits'[current()/@movablelimits='true']}{
		     '&#10;'}{../lower-case(description)}">
	 <xsl:choose>
	  <xsl:when test="../@id=('U02061','U02062','U02063','U02064') or starts-with(../@id,'U1E')">
	   <xsl:text>&#x27e8;</xsl:text>
	   <span style="font-size:80%;font-style:italic">
	    <xsl:value-of select="replace(lower-case(../description),' ','&#160;')"/>
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


    <h2 id="stable">Sortable Table View</h2>


    
    <xsl:variable  name="c" select="'priority','lspace','rspace'"/>
    <xsl:variable  name="p" select="'fence','stretchy','separator','accent','largeop','movablelimits', 'symmetric'"/>
    <xsl:variable name="v" select="'linebreakstyle','minsize'"/>
    <xsl:text>&#10;</xsl:text>
    <table class="sortable">
     <xsl:text>&#10;</xsl:text>
     <thead>
      <xsl:text>&#10;</xsl:text>
      <tr>
       <xsl:text>&#10;</xsl:text>
       <xsl:for-each select="'Character','Glyph','Name','form',$c,'Properties'">
	<th><xsl:value-of select="."/></th>
       </xsl:for-each>
      </tr>
      <xsl:text>&#10;</xsl:text>
     </thead>
     <xsl:text>&#10;</xsl:text>
     <tbody>
      <xsl:text>&#10;</xsl:text>
      <xsl:for-each select="/unicode/charlist/character/operator-dictionary">
       <xsl:sort select="xs:integer(@priority)"/>
       <xsl:text>&#10;</xsl:text>
       <tr>
	<xsl:variable name="od" select="."/>
	 <xsl:variable name="d" select="for $i in tokenize(../@dec,'-') return xs:integer($i)"/>
	 <xsl:text>&#10;</xsl:text>
	 <th>
	  <xsl:attribute name="abbr" select="$d[1]"/>
	   <xsl:choose>
	     <xsl:when test="empty($d[. &gt;127])">
	     <xsl:value-of select="replace(replace(codepoints-to-string($d),'&amp;','&amp;amp;'),'&lt;','&amp;lt;')"/>
	     </xsl:when>
	     <xsl:otherwise>
	       <xsl:value-of select="replace(../@id,'[U-]0*([0-9A-F]*)','&amp;#x$1;')"/>
	     </xsl:otherwise>
	   </xsl:choose>
	 </th>
	 <th>
	  <xsl:value-of select="
				if($d=9001)
				 then '&#x3008;'
				else if($d=9002) then
				'&#x3009;'
				else codepoints-to-string($d)"/>
	 </th>
	 <th class="uname">
	 <xsl:value-of select="lower-case(../description)"/></th>
	 <th><xsl:value-of select="@form"/></th>
	 <xsl:for-each select="$c">
	  <td><xsl:value-of select="$od/@*[name()=current()]"/></td>
	 </xsl:for-each>
	 <td>
	  <xsl:value-of select="
				$p[$od/@*[.='true']/name()=.],
				$od/@*[name()=$v]/concat(name(),'=',.)
				" separator=", "/>
	 </td>
	 <xsl:text>&#10;</xsl:text>
       </tr>
       <xsl:text>&#10;</xsl:text>
      </xsl:for-each>
     </tbody>
     <xsl:text>&#10;</xsl:text>
    </table>
    <xsl:text>&#10;</xsl:text>
   </body>
  </html>
 </xsl:template>



 



<xsl:key name="opdict" match="operator-dictionary" use="concat(../@id,@form)"/>

</xsl:stylesheet>
