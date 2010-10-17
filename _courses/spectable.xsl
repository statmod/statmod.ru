<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:co="http://statmod.ru/courses"
	xmlns:pr="http://statmod.ru/staff"
      exclude-result-prefixes="msxsl co pr">
<xsl:param name="glob_param"/>
<xsl:include href="resolve_prof.xsl"/>
<xsl:variable name="profs" select="document('../_staff/prof.xml')"/>
<xsl:variable name="specs">
	<specs>
		<spec id="sa">
			<name>САПР</name>
			<xsl:copy-of select="document('sa_spec.xml')"/>
		</spec>
		<spec id="sm">
			<name>СМ</name>
			<xsl:copy-of select="document('sm_spec.xml')"/>
		</spec>
		<spec id="mm">
			<name>ММ</name>
			<xsl:copy-of select="document('mm_spec.xml')"/>
		</spec>
	</specs>
</xsl:variable>

<xsl:variable name="spec" select="/co:courses/@spec"/>
<xsl:variable name="current_year" select="/co:courses/@year"/>

<xsl:template match="/">
   <html>
      <body>
		<h2>Специализация <xsl:value-of select="msxsl:node-set($specs)/specs/spec[@id=$spec]/name/node()"/>:
		список спецкурсов <xsl:value-of select="$current_year"/>
		</h2>
		<p><a href="/chair/annotatedspecs/{$spec}/index.htm">Аннотации к спецкурсам</a><br/>
		</p>	

		<table width="100%" border="1" cellspacing="0" class="spectable">
         		<tr>
				<th><spec code="nbsp"/></th>
				<th>преподаватель</th>
				<th>название</th>
				<th>зач./<br/>экз.</th>
				<th><font color="red">вопросы</font><sup>1</sup></th>
				<th>час.<sup>2</sup></th>
				<th>длит.<sup>3</sup></th>
				<th><spec code="nbsp"/><sup>4</sup></th>
			</tr>
			<xsl:apply-templates select="co:courses"/>
		</table>
		<p><sup>1</sup> Значок <img alt="" src="/_img/ok.gif"/> означает, что вопросы к экзаменам
up-to-date.</p>
		<p><sup>2</sup> Число часов курса в текущем семестре.</p>
		<p><sup>3</sup> Объем курса, по которому нужно сдавать зачет/экзамен (0.5 соответствует семестру занятий по 2 часа в неделю). Для курсов, состоящих из двух частей, обозначение 0.5(1) означает, что материал курса составляет половину годового экзамена.</p>
		<p><sup>4</sup> Формальный номер спецкурса/спецсеминара. Если спецкурс годовой и состоит из двух частей, то эти части обозначаются 
как (1) и (2). В скобках указано неофициальное название таких частей.</p>
      </body>
   </html>
</xsl:template>

<xsl:key name="semester_key" match="@semester" use="."/>

<xsl:template match="co:courses">
		<!-- This 'for-each' selects unique semester attribute -->
		<xsl:for-each select="co:course/@semester[generate-id() = generate-id(key('semester_key', .))]">
			<tr>
				<td class="semname" colspan="10"><xsl:value-of select="."/> семестр</td>
			</tr>
	   		<xsl:apply-templates select="../../co:course[@semester=current()]"/>
		</xsl:for-each>
</xsl:template>

<xsl:template match="co:course">
	<tr>
		<td align="right"><xsl:value-of select="@class"/></td>
		<td><xsl:apply-templates select=".//co:prof"/></td>
		<td class="specname"><a href="/chair/annotatedspecs/{$spec}/index.htm#{@alias}"><xsl:value-of select="co:name"/></a></td>
		<td align="right"><xsl:value-of select="@exam"/></td>
		<td align="right">
			<xsl:variable name="questions" select="msxsl:node-set($specs)/specs/spec/co:courses/co:course[@alias = current()/@alias]/co:questions"/>
			<xsl:if test="not($questions and @exam != '')"><spec code="nbsp"/></xsl:if>
			<xsl:if test="$questions and @exam != ''">
				<xsl:apply-templates select="$questions"/>
			</xsl:if>
		</td>
		<td align="right"><xsl:value-of select="@hours"/></td>
		<td align="right">	<xsl:value-of select="@year_equiv"/></td>
		<td align="right"><xsl:value-of select="@extras"/></td>
		
	</tr>	
</xsl:template>

<xsl:template match="co:prof">
	<a href="/chair/prof/{@id}.htm">
	<xsl:apply-templates select="$profs//pr:person[@id = current()/@id]" mode="short_name"/>
	</a>
	<xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

<xsl:template match="co:questions">
	<xsl:attribute name="valign">bottom</xsl:attribute>
	<a href="/_files/questions/{@file}" target="_blank">
		<img alt="{co:file_name}" src="/_img/pdf.png">
			<xsl:variable name="ext" select="substring-after(@file, '.')"/>
			<xsl:attribute name="src">/_img/<xsl:choose>
					<xsl:when test="$ext = 'pdf'"><xsl:value-of select="$ext"/></xsl:when>
					<xsl:otherwise>file</xsl:otherwise>
				</xsl:choose>.png
			</xsl:attribute>
		</img>
	</a>
	<xsl:if test="co:file_name = $current_year"><img alt="" src="/_img/ok.gif"/></xsl:if>
</xsl:template>



</xsl:stylesheet>
  

  