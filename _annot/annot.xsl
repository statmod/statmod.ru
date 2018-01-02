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
	</specs>
</xsl:variable>

<xsl:variable name="spec" select="/an:annotations/@spec"/>



<xsl:template match="/an:annotations">
	<xsl:variable name="array_name" select="'map_course_to_id'"/>
   <html>
	   <script language="javascript">
		   var <xsl:value-of select="$array_name"/> = new Array();
		   <xsl:apply-templates select="an:cycle/an:annot" mode="gen_array">
			   <xsl:with-param name="array_name" select="$array_name"/>
		   </xsl:apply-templates>
	   </script>
      <body>
		<h2>Специализация <xsl:value-of select="msxsl:node-set($specs)/specs/spec[@id=$spec]/name/node()"/>: 
		аннотации к спецкурсам 2017/2018
		</h2>
		
		<p><a href="/3-5/spectable/{$spec}/index.htm">Список спецкурсов</a></p>
		<p>
			<xsl:apply-templates select="an:notes/node()"/>
		</p>
		<p>
		<a href="#" onclick="return toggle_text_all({$array_name}, true)">+ Раскрыть все</a>
		<spec code="nbsp"/>
		<spec code="nbsp"/>
		<a href="#" onclick="return toggle_text_all({$array_name},false)">- Свернуть все</a>
		</p>
		<ol class="annotations">
			<xsl:apply-templates select="an:cycle"/>
		</ol>
		<script language="javascript">
		    if (location.hash != '') {
			  toggle_text(<xsl:value-of select="$array_name"/>[location.hash.substr(1)]);
			}
	   </script>		
      </body>
   </html>
</xsl:template>

<xsl:template match="an:cycle">
	<li class="cycle"><span><xsl:value-of select="an:name"/></span>
		<ul>
			<xsl:apply-templates select="an:annot">
				<xsl:with-param name="style" select="@style"/>
			</xsl:apply-templates>
		</ul>
	</li>
</xsl:template>

<xsl:template match="an:annot">
	<xsl:param name="style"/>
	<li>
		<xsl:variable name="id" select="generate-id()"/>
		<span id="an_{$id}_sign" class="an_sign"><a href="#" style="text-decoration: none" onclick="return toggle_text('an_{$id}', false, false)">+</a></span>
		<spec code="#32"/>
		<xsl:apply-templates select="an:header">
			<xsl:with-param name="style" select="$style"/>
		</xsl:apply-templates>
		<div id="an_{$id}" style="display:none">
		<xsl:apply-templates select="*[name() != 'header']|text()">
			<xsl:with-param name="style" select="$style"/>
		</xsl:apply-templates>
		</div>
	</li>
</xsl:template>

<xsl:key name="year_key" match="@year" use="."/>


<xsl:template match="an:header">
		<xsl:param name="style"/>
		<xsl:for-each select="an:course">
<xsl:call-template name="format_course">
		<xsl:with-param name="courses" select="msxsl:node-set($specs)/specs/spec[@id=$spec]/co:courses/co:course[(@alias=current()/@id) and(@hours != 0)]"/>
		<xsl:with-param name="pos" select="position()"/>
		<xsl:with-param name="style" select="$style"/>
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
	<xsl:param name="style" select="''"/>
	<xsl:param name="pos"/>
	
	<xsl:if test="$courses">
		<a name="{$courses[1]/@alias}">
		<b>
		<xsl:variable name="c_info">
			<xsl:choose>
				<xsl:when test="sum($courses/@hours) &lt; 4">полугодовой </xsl:when>
				<xsl:when test="sum($courses/@hours) &gt;= 4">годовой </xsl:when>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="$courses[1]/@class='с/к'">спецкурс </xsl:when>
				<xsl:when test="$courses[1]/@class='с/с'">спецсеминар </xsl:when>
				<xsl:otherwise>курс</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>	
		
		<xsl:if test="not($style = 'no_duration')">
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

<xsl:template match="an:annot" mode="gen_array">
	 <xsl:param name="array_name"/>
   	<xsl:variable name="id" select="generate-id()"/>

	<xsl:for-each select="an:header/an:course">
		<xsl:value-of select="$array_name"/>['<xsl:value-of select="@id"/>'] = 'an_<xsl:value-of select="$id"/>';	</xsl:for-each>
</xsl:template>


</xsl:stylesheet>
  

  