<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:pr="http://statmod.ru/staff"
  exclude-result-prefixes="pr msxsl">
	<xsl:import href="../../_courses/timetable_prof_view.xsl"/>

	<xsl:param name="glob_param"/>
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<xsl:template match="/pr:staff">
		<html>
<head>
<title>StatMod.Ru :: Расписание преподавателей</title>
<link href="/statmod.css" rel="stylesheet" type="text/css"/>
</head>
<body>
			<xsl:for-each select="pr:person">
				<xsl:variable name="timetable" select="document(concat('tt_',@id,'.xml'))"/>
				<xsl:if test="boolean($timetable/timetable/weekday[descendant::lesson])">
				<h2>
<xsl:value-of select="concat(pr:ln, ' ', substring(pr:fn, 1, 1), '.', substring(pr:mn, 1, 1), '.')"/>
				</h2>
				<xsl:apply-templates select="$timetable" mode="common_view"></xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
