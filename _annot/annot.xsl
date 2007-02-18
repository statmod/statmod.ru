<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:co="http://statmod.ru/courses"
	xmlns:an="http://statmod.ru/annotations"
	xmlns:pr="http://statmod.ru/staff"
      exclude-result-prefixes="msxsl co pr">

<xsl:variable name="profs" select="document('../_staff/prof.xml')"/>
<xsl:variable name="specs">
	<specs>
		<spec id="sa">
			<name>САПР</name>
			<xsl:copy-of select="document('../_courses/sa_spec.xml')"/>
		</spec>
		<spec id="sm">
			<name>СМ</name>
			<xsl:copy-of select="document('../_courses/sm_spec.xml')"/>
		</spec>
		<spec id="mm">
			<name>ММ</name>
			<xsl:copy-of select="document('../_courses/mm_spec.xml')"/>
		</spec>
	</specs>
</xsl:variable>

<xsl:variable name="spec" select="/an:annotations/@spec"/>



<xsl:template match="/an:annotations">
   <html>
      <body>
		<h2>Специализация <xsl:value-of select="msxsl:node-set($specs)/specs/spec[@id=$spec]/name/node()"/></h2>
		
		<p>
			<xsl:apply-templates select="an:notes/node()"/>
		</p>
		<ol>
			<xsl:apply-templates select="an:cycle"/>
		</ol>
		
      </body>
   </html>
</xsl:template>

<xsl:template match="an:cycle">
	<li><h3><xsl:value-of select="an:name"/></h3>
		<ul>
			<xsl:apply-templates select="an:annot"/>
		</ul>
	</li>
</xsl:template>

<xsl:template match="an:annot">
	<li>
		<xsl:apply-templates select="node()"/>
	</li>
</xsl:template>

<xsl:key name="year_key" match="@year" use="."/>


<xsl:template match="an:header">
		<xsl:for-each select="an:course">
<xsl:call-template name="format_course">
		<xsl:with-param name="courses" select="msxsl:node-set($specs)/specs/spec[@id=$spec]/co:courses/co:course[(@alias=current()/@id) and(@hours != 0)]"/>
		<xsl:with-param name="pos" select="position()"/>
</xsl:call-template>

<xsl:choose>
	<xsl:when test="position() &lt; (last() - 1)">,<spec code="#32"/></xsl:when>
	<xsl:when test="position() = (last() - 1)">и<spec code="#32"/></xsl:when>
</xsl:choose>
		</xsl:for-each>
  		<br/>
<!--	<xsl:value-of select="an:course/@id"/>-->
</xsl:template>

<xsl:template name="format_course">
	<xsl:param name="courses"/>
	<xsl:param name="style" select="1"/>
	<xsl:param name="pos"/>
	
	<xsl:if test="$courses">
		<a name="{$courses[1]/@alias}">
		<b>
		<xsl:variable name="c_info">
			<xsl:choose>
				<xsl:when test="sum($courses/@hours) &lt; 4">полугодовой </xsl:when>
				<xsl:when test="sum($courses/@hours) = 4">годовой </xsl:when>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="$courses[1]/@class='с/к'">спецкурс </xsl:when>
				<xsl:when test="$courses[1]/@class='с/с'">спецсеминар </xsl:when>
				<xsl:otherwise>курс</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>	
		
		<xsl:if test="$style = 1">
			<xsl:choose>
				<xsl:when test="$pos = 1">
					<xsl:value-of select="concat(translate(substring($c_info, 1, 1), 'спгк', 'СПГК'), substring($c_info,2))"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$c_info"/></xsl:otherwise>
			</xsl:choose>
			<spec code="#32"/>
		</xsl:if>
		
		<spec code="laquo"/>
		<xsl:value-of select="$courses[1]/co:name"/>
		<spec code="raquo"/><spec code="#32"/>
		(<xsl:for-each select="$courses/.">
		<xsl:value-of select="@year"/> курс
		<xsl:value-of select="@semester"/> семестр<xsl:if test="position()!=last()">, </xsl:if>
		</xsl:for-each>)
  		</b></a>
		
		<!-- xsl:copy-of select="$courses"/ -->
	</xsl:if>
</xsl:template>


<xsl:template match="an:spec">
	<spec code="{@code}"/>
</xsl:template>


<xsl:template match="*|@*|text()|comment()|processing-instruction()">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|text()|comment()|processing-instruction()"/>
	</xsl:copy>
</xsl:template>




</xsl:stylesheet>
  

  