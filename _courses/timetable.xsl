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
			<td class="two_hours_no">
				<xsl:if test="count(msxsl:node-set($lessons_table_merged)/table/row) = 2">
					<xsl:attribute name="rowspan">2</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@no"/>
			</td>
			<xsl:apply-templates select="msxsl:node-set($lessons_table_merged)/table/row[1]">
				<xsl:with-param name="lessons_with_ref" select="$lessons_with_ref"/>
				<xsl:with-param name="error_location" select="$this_error_location"/>
			</xsl:apply-templates>
		</tr>
		<xsl:if test="count(msxsl:node-set($lessons_table_merged)/table/row)  = 2">
			<tr>
				<xsl:apply-templates select="msxsl:node-set($lessons_table_merged)/table/row[2]">
					<xsl:with-param name="lessons_with_ref" select="$lessons_with_ref"/>
					<xsl:with-param name="error_location" select="$this_error_location"/>
				</xsl:apply-templates>
			</tr>
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="row">
		<xsl:param name="error_location"/>
		<xsl:param name="lessons_with_ref"/>
		<xsl:for-each select="cell">
			<td><xsl:copy-of select="@colspan"/><xsl:copy-of select="@rowspan"/>
<xsl:if test="@dataref=0"><br/><br/><br/></xsl:if>
				<xsl:apply-templates select="msxsl:node-set($lessons_with_ref)/lesson[@dataref = current()/@dataref]">
				<xsl:with-param name="error_location" select="$error_location"/>
				</xsl:apply-templates>

			</td>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="lesson">
		<xsl:param name="error_location"/>
		<xsl:variable name="gather_course_info">
			<course>
			<xsl:copy-of select="location"/>
			<xsl:copy-of select="course/name"/>
			<xsl:copy-of select="course/prof"/>
			<xsl:if test="course/@id">
				<xsl:variable name="course_id" select="course/@id"/>
				<xsl:variable name="spec_to_select">
					<xsl:choose>
						<xsl:when test="@spec = 'all'">sm</xsl:when>
						<xsl:when test="contains(@spec, ',')"><xsl:value-of select="substring-before(@spec,',')"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="@spec"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="course_info" select="msxsl:node-set($specs)/specs/spec[@id=$spec_to_select]/courses/course[@alias = $course_id]"/>

				<xsl:if test="not($course_info)">
					<xsl:message terminate="yes">Unknown course id '<xsl:value-of select="$course_id"/>' for specializaion '<xsl:value-of select="$spec_to_select"/>'. Occured at <xsl:value-of select="$error_location"/>.</xsl:message>
				</xsl:if>
				
				<xsl:copy-of select="$course_info/name"/>
				<xsl:variable name="course_info_prof" select="$profs//person[@id = $course_info/prof/@id]"/>
				<xsl:if test="$course_info/prof/@id and not($course_info_prof)">
					<xsl:message terminate="yes">Unresolved prof id for course '<xsl:value-of select="$course_id"/>'.</xsl:message>
				</xsl:if>
				<xsl:apply-templates select="$course_info_prof" mode="short_name"/>

				<xsl:if test="course/@part">
					<xsl:variable name="course_part" select="$course_info/part[@type = current()/course/@part]"/>
					
					<xsl:if test="not($course_part)">
						<xsl:message terminate="yes">Course  '<xsl:value-of select="$course_id"/>' doesn't have part '<xsl:value-of select="course/@part"/>'. Occured at <xsl:value-of select="$error_location"/>
.</xsl:message>
					</xsl:if>
				
					<xsl:copy-of select="$course_part/name"/>
					<xsl:variable name="course_part_prof" select="$profs//person[@id = $course_part/prof/@id]"/>
					<xsl:if test="$course_part/prof/@id and not($course_part_prof)">
						<xsl:message terminate="yes">Unresolved prof id for course '<xsl:value-of select="$course_id"/>', '<xsl:value-of select="course/@part"/>'.</xsl:message>
					</xsl:if>
					<xsl:apply-templates select="$course_part_prof" mode="short_name"/>
				</xsl:if>
			</xsl:if>
			</course>
		</xsl:variable>
		
		<xsl:apply-templates select="msxsl:node-set($gather_course_info)/course"/>
	</xsl:template>
		
	<xsl:template match="course">
		<b>
			<xsl:for-each select="location"><xsl:value-of select="text()"/><xsl:if test="position()!=last()">,<spec code="nbsp"/></xsl:if></xsl:for-each>
		</b><br/>
		<xsl:value-of select="name/text()"/><br/>
		<i><xsl:copy-of select="prof/node()"/></i>
	</xsl:template>
	
</xsl:stylesheet>
