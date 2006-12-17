<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  exclude-result-prefixes="msxsl">
	<xsl:import href="_staff/profsinglepage.xsl"/>
	<xsl:import href="_staff/proftable.xsl"/>
	<xsl:import href="_courses/timetable_prof_view.xsl"/>

	<xsl:param name="glob_param"/>
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<xsl:template match="/profinfo">
		<span class="remove">
			<xsl:choose>
				<xsl:when test="not($glob_param/@prof) or $glob_param/@prof = 'none'">
					<xsl:apply-templates select="staff" mode="list"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="staff/person[@id=$glob_param/@prof]" mode="single">
						<xsl:with-param name="has_timetable" select="boolean(timetable/weekday[descendant::lesson])"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="timetable" mode="prof_view"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
</xsl:stylesheet>
