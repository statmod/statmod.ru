<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
	<xsl:param name="loc_param"/>
	<xsl:variable name="prof_id" select="'ka_timofeev'"/>
	<xsl:template match="/specs">
		<courses prof_id="{$prof_id}">
			<xsl:apply-templates select="spec"/>
		</courses>
	</xsl:template>
	<xsl:template match="spec">
		<xsl:apply-templates select="courses/course[descendant::prof/@id = $prof_id]">
			<xsl:with-param name="spec_id" select="@id"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="course">
		<xsl:param name="spec_id"/>
		<xsl:copy>
			<xsl:attribute name="spec_id"><xsl:value-of select="$spec_id"/></xsl:attribute>
			<xsl:copy-of select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
