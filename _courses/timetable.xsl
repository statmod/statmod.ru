<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:import href="mergecells.xsl"/>
	<xsl:include href="gen_lesson_table.xsl"/>
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
		<xsl:variable name="no_width" select="10"/>
		<xsl:variable name="spec_width" select="200"/>
		<span class="remove">
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
			<xsl:apply-templates select="weekday"/>
		</table>
		</span>
	</xsl:template>
	
	<xsl:template match="weekday">
		<tr>
			<td colspan="{$specs_count + 1}">
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
<xsl:if test="@dataref=0"><br/><br/><br/></xsl:if>
				<xsl:apply-templates select="msxsl:node-set($lessons_with_ref)/lesson[@dataref = current()/@dataref]"/>

			</td>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="lesson">
		<b>
			<xsl:for-each select="location"><xsl:value-of select="text()"/><xsl:if test="position()!=last()">,<spec code="nbsp"/></xsl:if></xsl:for-each>
		</b><br/>
		<xsl:value-of select="course/name/text()"/><br/>
		<i>
		<xsl:choose>
			<xsl:when test="course/prof/@id">
				<a href="/_courses/prof/{course/prof/@id}.htm">
					<xsl:copy-of select="course/prof/node()"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="course/prof/node()"/>
			</xsl:otherwise>
		</xsl:choose>
		</i>
	</xsl:template>
		
	
</xsl:stylesheet>