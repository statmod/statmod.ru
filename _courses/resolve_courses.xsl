<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:co="http://statmod.ru/courses"
	xmlns:pr="http://statmod.ru/staff"
      exclude-result-prefixes="msxsl co pr">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
	<xsl:param name="glob_param"/>
	<xsl:param name="loc_param"/>
	<xsl:include href="resolve_prof.xsl"/>
	<xsl:variable name="prof_id" select="$glob_param/@prof"/>
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



	<xsl:template match="/">
		<xsl:apply-templates select="timetable"/>
	</xsl:template>
	
	
	<xsl:template match="lesson">
		<xsl:variable name="error_location" select="concat('Day: ', ../../@id, ', Two hours: ', ../@no)"/>
		
		<xsl:choose>
			<xsl:when test="not(course/@id)">
				<xsl:if test="not($prof_id)">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!--  Resolve course reference -->
				<xsl:variable name="course_id" select="course/@id"/>
				<xsl:variable name="spec_to_select">
					<xsl:choose>
						<xsl:when test="@spec = 'all'">sm</xsl:when>
						<xsl:when test="contains(@spec, ',')"><xsl:value-of select="substring-before(@spec,',')"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="@spec"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="course_info" select="msxsl:node-set($specs)/specs/spec[@id=$spec_to_select]/co:courses/co:course[@alias = $course_id][1]"/>
				<xsl:if test="not($course_info)">
					<xsl:message terminate="yes">Unknown course id '<xsl:value-of select="$course_id"/>' for specializaion '<xsl:value-of select="$spec_to_select"/>'. Occured at <xsl:value-of select="$error_location"/>.</xsl:message>
				</xsl:if>
				
				<xsl:variable name="course_part" select="$course_info/co:part[@type = current()/course/@part]"/>
				<xsl:if test="course/@part and not($course_part)">
						<xsl:message terminate="yes">Course  '<xsl:value-of select="$course_id"/>' doesn't have part '<xsl:value-of select="course/@part"/>'. Occured at <xsl:value-of select="$error_location"/>
.</xsl:message>
				</xsl:if>

				<xsl:variable name="course_prof_id">
					<xsl:choose>
						<xsl:when test="$course_part/co:prof/@id"><xsl:value-of select="$course_part/co:prof/@id"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$course_info/co:prof/@id"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable> 
				
				<xsl:if test="not($prof_id) or ($course_prof_id = $prof_id)">
					<lesson>
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="location|fortnightly"/>
						<course id="{$course_id}">
							<xsl:if test="$course_part"><xsl:attribute name="part"><xsl:value-of select="course/@part"/></xsl:attribute></xsl:if>
							<xsl:copy-of select="course/name"/>
							<xsl:copy-of select="course/prof"/>
							
							<xsl:apply-templates select="$course_info/co:name"/>
							<xsl:if test="$course_prof_id != ''">
								<xsl:variable name="course_prof_info" select="$profs//pr:person[@id = $course_prof_id]"/>
								<xsl:if test="not($course_prof_info)">
									<xsl:message terminate="yes">Unresolved prof id for course '<xsl:value-of select="$course_id"/>'.</xsl:message>
								</xsl:if>

								<prof id="{$course_prof_id}">
									<xsl:apply-templates select="$course_prof_info" mode="short_name">
									</xsl:apply-templates>	
								</prof>
							</xsl:if>
						</course>
					</lesson>
				</xsl:if> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template for namespace removal -->
	<xsl:template match="co:name">
		<name><xsl:copy-of select="node()"/></name>
	</xsl:template>

	<!-- Match everything else -->
	<xsl:template match="*|@*|text()|comment()">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()|comment()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
