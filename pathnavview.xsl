<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path_xml"/>
	<xsl:strip-space elements="item"/>
	<!-- Match the root node -->
	<xsl:template match="/">
		<span class="remove">
			<xsl:apply-templates select="//item"/>
		</span>
	</xsl:template>
	<xsl:template match="item">
		<a href="{@full_href}">
			<xsl:value-of select="name/node()"/>
		</a>
		<xsl:if test="position() != last()"> -&gt; </xsl:if>
	</xsl:template>
</xsl:stylesheet>
