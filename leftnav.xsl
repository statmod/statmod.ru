<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<xsl:strip-space elements="item"/>
	<!-- Match the root node -->
	<xsl:template match="/item">
		<xsl:variable name="path_parent" select="'/'"/>
		<xsl:variable name="cut_path" select="substring-after($current_folder, $path_parent)"/>
		<span class="remove">
			<xsl:if test="$cut_path != ''">
				<xsl:variable name="path_item" select="substring-before($cut_path, '/')"/>
				<xsl:variable name="path_remainder" select="substring-after($cut_path, '/')"/>
				<table border="0" cellpadding="0">
					<tr height="1">
						<td><img class="leftmenu_indents" src="/_img/spacer.gif" width="16" height="1"/></td>
						<td><img class="leftmenu_indents" src="/_img/spacer.gif" width="16" height="1"/></td>
						<td width="100%"><img src="/_img/spacer.gif" width="50" height="1"/></td>
					</tr>
					<xsl:apply-templates select="item[$path_item = @href]" mode="tree">
						<xsl:with-param name="path_remainder" select="$path_remainder"/>
						<xsl:with-param name="path_item" select="$path_item"/>
						<xsl:with-param name="path_parent" select="$path_parent"/>
						<xsl:with-param name="level" select="1"/>
					</xsl:apply-templates>
				</table>
			</xsl:if>
		</span>
	</xsl:template>
	
	<xsl:template match="item" mode="tree">
		<xsl:param name="path_remainder"/>
		<xsl:param name="path_item"/>
		<xsl:param name="path_parent"/>
		<xsl:param name="level"/>
		<xsl:variable name="item_in_path" select="$path_item = @href"/>
		<xsl:variable name="active_point" select="$item_in_path and ($path_remainder = '')"/>
		<xsl:variable name="next_path_item" select="substring-before($path_remainder, '/')"/>

		
		<!-- output current point -->
		<xsl:apply-templates select="." mode="single">
			<xsl:with-param name="path_parent" select="$path_parent"/>
			<xsl:with-param name="active_point" select="$active_point"/>
			<xsl:with-param name="level" select="$level"/>
		</xsl:apply-templates>
		
		<!-- output children -->
		<xsl:choose>
			<xsl:when test="$item_in_path and ($level &lt; 3)">
				<xsl:apply-templates select="item" mode="tree">
					<xsl:with-param name="path_parent" select="concat($path_parent, $path_item,'/')"/>
					<xsl:with-param name="path_item" select="$next_path_item"/>
					<xsl:with-param name="path_remainder" select="substring-after($path_remainder, '/')"/>
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>
	
	
	
	<xsl:template match="item" mode="single">
		<xsl:param name="path_parent"/>
		<xsl:param name="active_point" />
		<xsl:param name="level"/>

		<tr>
			<xsl:if test="$level &gt; 2"><td><img src="/_img/spacer.gif" width="1" height="1"/></td></xsl:if>
			<td align="center">
				<xsl:choose>
					<xsl:when test="$active_point = true()"><img src="/_img/menudot.gif" alt="->" width="10" height="8"/></xsl:when>
					<xsl:otherwise>	<img src="/_img/spacer.gif" width="1" height="1"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<td >
				<xsl:if test="not($level &gt; 2)"><xsl:attribute name="colspan">2</xsl:attribute></xsl:if>
				<xsl:choose>
					<xsl:when test="$active_point = true()"><a href="{$current_folder}index.htm"><xsl:value-of select="name/node()"/></a></xsl:when>
					<xsl:otherwise>	<a href="{$path_parent}{@href}/index.htm"><xsl:value-of select="name/node()"/></a></xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>

		<xsl:if test="$level = 1">
			<tr>
				<td colspan="3">
					<img src="/_img/spacer.gif" alt="" height="10" class="leftmenu_firstindent"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>



</xsl:stylesheet>
