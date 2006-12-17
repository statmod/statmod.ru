<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:pr="http://statmod.ru/staff"
  exclude-result-prefixes="msxsl pr">
	<xsl:param name="path_xml"/>
	<xsl:param name="glob_param"/>
	<xsl:param name="current_folder"/>

	<xsl:template match="/pr:staff">
		<build>
			<build xml="index.xml" xsl="index.xsl" xsl_glob="reslinks.xsl" output="index.htm" prof="none"/>
			<xsl:apply-templates select="pr:person"/>
		</build>
	</xsl:template>
	<xsl:template match="pr:person">
		<build xml="index.xml" xsl="index.xsl" xsl_glob="reslinks.xsl" prof="{@id}" output="{@id}.htm"/>
	</xsl:template>
</xsl:stylesheet>
