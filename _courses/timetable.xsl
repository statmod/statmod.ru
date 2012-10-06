<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
      xmlns:pr="http://statmod.ru/staff">
	<xsl:import href="mergecells.xsl"/>
<xsl:param name="current_folder"/>
	<xsl:include href="gen_lesson_table.xsl"/>
	<xsl:include href="resolve_prof.xsl"/>
	<xsl:variable name="no_width" select="10"/>
	<xsl:variable name="spec_width" select="164"/>
	<xsl:variable name="cell_height" select="36"/>

	<xsl:variable name="specs">
		<specs>
			<spec id="sa">
				<name>САПР</name>
			</spec>
			<spec id="sm">
				<name>СМ</name>
			</spec>
			<spec id="mm">
				<name>ММ</name>
			</spec>
		</specs>
	</xsl:variable>
	<xsl:variable name="weekdays">
		<week>
			<day id="mon">Понедельник</day>
			<day id="tue">Вторник</day>
			<day id="wed">Среда</day>
			<day id="thu">Четверг</day>
			<day id="fri">Пятница</day>
			<day id="sat">Суббота</day>
		</week>
	</xsl:variable>
	<xsl:variable name="specs_count" select="count(msxsl:node-set($specs)/specs/spec)"/>

	<!-- Match the root node -->
	<xsl:template match="/timetable">
		<span class="remove">
<h2><xsl:value-of select="ceiling(@semester div 2)"/>-й курс,
<xsl:choose>
<xsl:when test="@semester mod 2 = 0">
весенний семестр 
<xsl:value-of select="@year - 1"/>-<xsl:number value="@year mod 100" format="01"/>
</xsl:when>
<xsl:otherwise>
осенний семестр 
<xsl:value-of select="@year"/>-<xsl:number value="(@year + 1) mod 100" format="01"/>
</xsl:otherwise>
</xsl:choose>
</h2>
<p>Версия 2.1 расписания на 31.08.2012, возможно, окончательная, но изменения не исключаются - обновляйте страницу (!) чтобы увидеть последний вариант. Неделя с 3 сентября (включая 1 сентября) - по числителю.</p>
<p/>
<p>Карманное расписание<sup><font color="red">NEW</font></sup> для специализаций: 
<xsl:for-each select="msxsl:node-set($specs)/specs/spec"><spec code="nbsp"/><a target="_blank" href="{$current_folder}pocket/{@id}.htm"><xsl:value-of select="name"/></a></xsl:for-each></p>


		<table class="timetable" width="{$no_width + count(msxsl:node-set($specs)/specs/spec)*$spec_width}" align="center" border="1">
			<tr>
				<td class="head" width="{$no_width}">	<spec code="nbsp"/></td>
				<xsl:for-each select="msxsl:node-set($specs)/specs/spec">
					<td  class="head" width="{$spec_width}">
						<img src="/_img/spacer.gif" alt="" width="{$spec_width}" height="0"/><br/>
						<xsl:value-of select="name/text()"/>
					</td>
				</xsl:for-each>
			</tr>
			<xsl:apply-templates select="weekday[two_hours]"/>
		</table>
		</span>
	</xsl:template>
	
	<xsl:template match="weekday">
		<tr>
			<td colspan="{$specs_count + 1}" class="weekday">
				<xsl:value-of select="msxsl:node-set($weekdays)/week/day[@id=current()/@id]/text()"/>
			</td>
		</tr>
		<xsl:apply-templates select="two_hours">
			<xsl:with-param name="error_location" select="concat('Weekday: ', @id)"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="two_hours">
		<xsl:param name="error_location"/>
		<xsl:variable name="this_error_location" select="concat($error_location, ', Two hours: ', @no)"/>

		<xsl:variable name="lessons_with_ref">
			<xsl:apply-templates select="lesson" mode="add_ref"/>
		</xsl:variable>	
		<xsl:variable name="lessons_table">
			<xsl:call-template name="gen_table_part">
				<xsl:with-param name="lessons_with_ref" select="$lessons_with_ref"/>
				<xsl:with-param name="error_location" select="$this_error_location"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="lessons_table_merged">
			<xsl:apply-templates select="msxsl:node-set($lessons_table)/table" mode="merge"/>
		</xsl:variable>
	
		<tr>
			<td class="two_hours_no" rowspan="2">
				<xsl:value-of select="@no"/>
			</td>
			<xsl:apply-templates select="msxsl:node-set($lessons_table_merged)/table/row[1]">
				<xsl:with-param name="lessons_with_ref" select="$lessons_with_ref"/>
			</xsl:apply-templates>
		</tr>
		<tr>
			<xsl:apply-templates select="msxsl:node-set($lessons_table_merged)/table/row[2]">
				<xsl:with-param name="lessons_with_ref" select="$lessons_with_ref"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>
	
	
	
	<xsl:template match="row">
		<xsl:param name="lessons_with_ref"/>
		<xsl:for-each select="cell">
			<td><xsl:copy-of select="@colspan"/><xsl:copy-of select="@rowspan"/>
<xsl:if test="@dataref!=0"><xsl:attribute name="bgcolor">lightgrey</xsl:attribute></xsl:if>
				<xsl:variable name="rows" select="number(concat('0',@rowspan)) + number(not(@rowspan))"/>
				<img src="/_img/spacer.gif" alt="" width="1" height="{$cell_height * $rows}" align="left"/>
			
<xsl:if test="@dataref=0"><br/></xsl:if>
				<xsl:apply-templates select="msxsl:node-set($lessons_with_ref)/lesson[@dataref = current()/@dataref]"/>

			</td>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="lesson">
		<b>
			<xsl:for-each select="location"><xsl:value-of select="text()"/><xsl:if test="position()!=last()">,<spec code="nbsp"/></xsl:if></xsl:for-each>
		</b>
 <spec code="#32"/>
			<i>
			<xsl:choose>
				<xsl:when test="course/prof/@id">
					<a href="/chair/prof/{course/prof/@id}.htm">
						<xsl:copy-of select="course/prof/node()"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="course/prof/node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</i><br/>
		<xsl:value-of select="course/name/text()"/>
	</xsl:template>
		
	
</xsl:stylesheet>
