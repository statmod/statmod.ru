<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Match the root node -->
<xsl:template match="/">
     <span class="remove">
		<xsl:apply-templates select="html/head/title/node()"/>
     </span>
</xsl:template>

	
<!-- Match everything else -->
<xsl:template match="*|@*|text()|comment()">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|text()|comment()"/>
	</xsl:copy>
</xsl:template>


</xsl:stylesheet>
