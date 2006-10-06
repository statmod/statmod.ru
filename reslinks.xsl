<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="loc_param"/>
<xsl:param name="path_xml"/>

<!--
<xsl:variable name="need_resolve_links" select="not(starts-with($loc_param/@xml, '/'))"/>
-->

<xsl:variable name="need_resolve_links" select="true()"/>


<!-- Match the root node -->
<xsl:template match="/">
	<xsl:apply-templates select="*"/>
</xsl:template>

<!-- Correct 'src' attribute of 'img' tag -->
<xsl:template match="img|IMG">
	<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:if test="$need_resolve_links and not (starts-with(@src, '/') or 
                                           starts-with(@src, 'mailto') or 
                                           starts-with(@src, 'javascript') or 
                                           starts-with(@src, 'vbscript') or 
                                           starts-with(@src, 'ftp') or 
                                           starts-with(@src, 'http') or 
                                           starts-with(@src, '#'))">
  <xsl:attribute name="src"><xsl:value-of select="concat($path_xml,@src)"/></xsl:attribute>
</xsl:if>
<xsl:apply-templates select="*|text()|comment()"/>
	</xsl:copy>
</xsl:template>

<!-- Correct 'href' attribute of 'a' tag -->
<xsl:template match="a|A">
	<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:if test="$need_resolve_links and boolean(@href) and not (starts-with(@href, '/') or 
                                           starts-with(@href, 'mailto') or 
                                           starts-with(@href, 'javascript') or 
                                           starts-with(@href, 'vbscript') or 
                                           starts-with(@href, 'ftp') or 
                                           starts-with(@href, 'http') or 
                                           starts-with(@href, '#') or 
                                           starts-with(@href, '?'))">
  <xsl:attribute name="href"><xsl:value-of select="concat(translate($path_xml, '\','/'),@href)"/></xsl:attribute>
</xsl:if>
<xsl:apply-templates select="*|text()|comment()"/>
	</xsl:copy>
</xsl:template>
	
<!-- Match everything else -->
<xsl:template match="*|@*|text()|comment()">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|text()|comment()"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
