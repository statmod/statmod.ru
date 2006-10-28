<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<xsl:strip-space elements="item"/>
	<!-- Match the root node -->
	<xsl:template match="/item">
		<xsl:variable name="path_parent" select="'/'"/>
		<xsl:variable name="cut_path" select="substring-after($current_folder, $path_parent)"/>
		<xsl:choose>
			<xsl:when test="$cut_path != ''">
				<xsl:variable name="path_item" select="substring-before($cut_path, '/')"/>
				<xsl:variable name="path_remainder" select="substring-after($cut_path, '/')"/>

				<xsl:apply-templates select="item[$path_item = @href]">
					<xsl:with-param name="path_remainder" select="$path_remainder"/>
					<xsl:with-param name="path_item" select="$path_item"/>
					<xsl:with-param name="path_parent" select="$path_parent"/>
				</xsl:apply-templates>
				<xsl:if test="not(item[$path_item = @href])">
				<item/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<item/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="item">
		<xsl:param name="path_remainder"/>
		<xsl:param name="path_item"/>
		<xsl:param name="path_parent"/>
		<xsl:param name="level"/>
		<xsl:variable name="item_in_path" select="$path_item = @href"/>
		<xsl:variable name="active_point" select="$item_in_path and ($path_remainder = '')"/>
		<xsl:variable name="next_path_item" select="substring-before($path_remainder, '/')"/>

		
		<!-- output current point -->
		<item full_href="{$path_parent}{@href}/index.htm" item_in_path="{$item_in_path}" active_point="{$active_point}">
			<xsl:copy-of select="name"/>
			<!-- output children -->
			<xsl:if test="$item_in_path">
				<xsl:apply-templates select="item">
					<xsl:with-param name="path_parent" select="concat($path_parent, $path_item,'/')"/>
					<xsl:with-param name="path_item" select="$next_path_item"/>
					<xsl:with-param name="path_remainder" select="substring-after($path_remainder, '/')"/>
				</xsl:apply-templates>
			</xsl:if>
		</item>
	</xsl:template>
</xsl:stylesheet>
