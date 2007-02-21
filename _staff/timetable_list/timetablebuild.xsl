<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:pr="http://statmod.ru/staff"
  exclude-result-prefixes="pr">
	<xsl:param name="path_xml"/>
	<xsl:param name="glob_param"/>
	<xsl:param name="current_folder"/>

	<xsl:template match="/pr:staff">
		<build>
			<xsl:apply-templates select="pr:person"/>
			<build xml="/_staff/prof.xml" xsl="timetablelist.xsl" output="list.htm"/>
		</build>
	</xsl:template>
	<xsl:template match="pr:person">
		<build 
 xml="/_courses/all_timetables.xml" xsl="/_courses/merge_timetables.xsl" prof_required="yes"
 prof="{@id}" output="tt_{@id}.xml"/>
	</xsl:template>
</xsl:stylesheet>
