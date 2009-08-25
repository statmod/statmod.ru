<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<!-- Match the root node -->

	<xsl:template match="/item">
<span class="remove">
	<xsl:apply-templates select="." mode="map">
<xsl:with-param name="parent_path" select="substring($path_xml, 0, string-length($path_xml) - 1)"/>
</xsl:apply-templates>
</span>
	</xsl:template>

	<xsl:template match="item" mode="map">
<xsl:param name="parent_path"/>
<xsl:variable name="this_path" select="concat($parent_path, @href, '/')"/>

<li><xsl:apply-templates select="." mode="mapitem">
<xsl:with-param name="this_path" select="$this_path"/>
</xsl:apply-templates>

<ul>
<xsl:apply-templates select="item" mode="map">
<xsl:with-param name="parent_path" select="$this_path"/>
</xsl:apply-templates>
</ul>
</li>
	</xsl:template>

	
	<xsl:template match="item" mode="mapitem">
		<xsl:param name="this_path"/>
		<xsl:variable name="this_file">
		<xsl:choose>
		<xsl:when test="@href = 'sitemap'">/sitemap.xml</xsl:when>
		<xsl:otherwise><xsl:value-of select="$this_path"/>contents.xml</xsl:otherwise>
		</xsl:choose>
           </xsl:variable>


		<a target="_blank">
		<xsl:attribute name="href"><xsl:choose>
<xsl:when test="@hreftype = 'special'"><xsl:value-of select="@href"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$this_path"/>index.htm</xsl:otherwise>
</xsl:choose></xsl:attribute>

 			<xsl:value-of select="name/node()"/>
		</a>
<xsl:if test="not(@hreftype = 'special')">
<!-- , --> <br/>		
<!--	
		Последнее изменение:		
		<timestamp file="{normalize-space($this_file)}"/> 
-->
</xsl:if> 
		<xsl:if test="@forumlink">,
			<a href="{@forumlink}"  target="_blank">Обсуждение в форуме</a>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
