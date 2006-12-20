<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:pr="http://statmod.ru/staff"
  exclude-result-prefixes="pr">


<!-- Match the root node -->
<xsl:template match="/">
	<xsl:apply-templates select="pr:*"/>
</xsl:template>

	
<!-- Match everything else -->
<xsl:template match="pr:*">
	<xsl:element name="{name()}">
		<xsl:apply-templates select="pr:*|@*|text()|comment()|processing-instruction()"/>
	</xsl:element>
</xsl:template>

<xsl:template match="@*|text()|comment()|processing-instruction()">
	<xsl:copy>
		<xsl:apply-templates select="pr:*|@*|text()|comment()|processing-instruction()"/>
	</xsl:copy>
</xsl:template>


</xsl:stylesheet>
