<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:param name="path_xml"/>
	<xsl:param name="glob_param"/>
	<xsl:param name="current_folder"/>

	<xsl:template match="/staff">
		<build>
			<build xml="index.xml" xsl="index.xsl" xsl_glob="reslinks.xsl" output="index.htm"/>
			<xsl:apply-templates select="person"/>
		</build>
	</xsl:template>
	<xsl:template match="person">
		<build xml="index.xml" xsl="index.xsl" xsl_glob="reslinks.xsl" prof="{@id}" output="{@id}.htm"/>
	</xsl:template>
</xsl:stylesheet>
