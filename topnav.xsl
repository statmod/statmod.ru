<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<xsl:strip-space elements="span"/>

	
	<!-- Match the root node -->
	<xsl:template match="/item">
<span class="remove">
<xsl:apply-templates select="item" mode="single"/>
</span>
	</xsl:template>

	<xsl:template match="item" mode="single">
<xsl:variable name="real_href" select="concat($path_xml, @href, '/')"/>
<xsl:variable name="page_name" select="translate(name/node(),'абвгдеёжзийклмнопрстуфхцчшщъыьэюя', 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ')"/>

<span>
	<xsl:if test="starts-with($current_folder, $real_href)">
	<xsl:attribute name="class">tn_sel</xsl:attribute>
	</xsl:if>
<a>
<xsl:attribute name="href"><xsl:choose>
<xsl:when test="@hreftype = 'special'"><xsl:value-of select="@href"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$real_href"/>index.htm</xsl:otherwise>
</xsl:choose></xsl:attribute>

<xsl:value-of select="$page_name"/>
</a>
</span>
	<xsl:if test="not(position()=last())">
<img src="/_img/spacer.gif" width="40" height="1" alt=""/>
	</xsl:if>
	</xsl:template>

</xsl:stylesheet>
