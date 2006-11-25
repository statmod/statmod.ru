<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="vspace_before_arrow" select="73"/>
	<xsl:variable name="arrow_cell_height" select="23"/>
	<xsl:variable name="vspace_after_arrow" select="4"/>

	<xsl:variable name="level_1_height" select="23"/>
	<xsl:variable name="level_2_height" select="23"/>
	
	<xsl:variable name="menu_width" select="169"/>
	
	<xsl:variable name="hl_line_start" select="2"/>
	<xsl:variable name="hl_first_line_end" select="23"/>
	<xsl:variable name="hl_line_end" select="4"/>
	<xsl:variable name="level_1_indent" select="18"/>
	<xsl:variable name="level_2_indent_rel" select="14"/>
	<xsl:variable name="dot_cell_width" select="5"/>

	<xsl:variable name="after_1_indents" select="$menu_width - $level_1_indent"/>
	<xsl:variable name="after_2_indents" select="$menu_width - $level_1_indent - $level_2_indent_rel - $dot_cell_width"/>
	<!-- Match the root node -->
	<xsl:template match="/">
		<span class="remove">
			<xsl:apply-templates select="item" mode="level_0"/>
		</span>
	</xsl:template>
	
	<xsl:template match="item" mode="level_0">
		<table cellpadding="0" cellspacing="0" border="0" width="{$menu_width}">
			<tr>
				<td colspan="5">
					<img src="/_img/spacer.gif" width="1" height="{$vspace_before_arrow}" alt=""/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<img src="/_img/spacer.gif" width="{$level_1_indent}" height="{$arrow_cell_height}" alt=""/>
				</td>
				<td colspan="3" id="arrow_cell">
					<xsl:apply-templates select="." mode="arrow"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<img src="/_img/spacer.gif" width="{$level_1_indent}" height="{$vspace_after_arrow}" alt=""/>
				</td>
				<td>
					<img src="/_img/spacer.gif" width="{$level_2_indent_rel}" height="{$vspace_after_arrow}" alt=""/>
				</td>
				<td><img src="/_img/spacer.gif" width="{$dot_cell_width}" height="1" alt=""/></td>
				<td><img src="/_img/spacer.gif" width="{$after_2_indents}" height="1" alt=""/></td>
			</tr>
		
			<xsl:apply-templates select="item" mode="level_1"/>
		</table>
	</xsl:template>
	
	<xsl:template match="item" mode="level_1">
		<xsl:call-template name="level_1_around">
			<xsl:with-param name="highlight" select="@item_in_path = 'true'"/>
		</xsl:call-template>

		<tr>
			<td colspan="2">
				<img src="/_img/spacer.gif" width="{$level_1_indent}" height="{$level_1_height}" alt=""/>
			</td>
			<td class="l1" colspan="3" valign="middle">
				<xsl:choose>
					<xsl:when test="full_href">
						<a href="{normalize-space(full_href)}" title="{normalize-space(title)}">
							<xsl:apply-templates select="name/node()"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="name/node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>

		<xsl:call-template name="level_1_around">
			<xsl:with-param name="highlight" select="@item_in_path = 'true'"/>
		</xsl:call-template>
		
		<xsl:apply-templates select="item" mode="level_2"/>
		<xsl:if test="not(item) or not(item/name)">
			<tr>
				<td colspan="5">
					<img src="/_img/spacer.gif" width="{$menu_width}" height="22" alt=""/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="item" mode="level_2">
		<tr>
			<td colspan="3">
				<img src="/_img/spacer.gif" width="1" height="{$level_2_height}" alt=""/>
			</td>
			<td valign="top">
				<img src="/_img/spacer.gif" width="1" height="7" alt=""/>
				<br/>
				<xsl:choose>
					<xsl:when test="@active_point='true'">
						<img src="/_img/lmenu_dot.gif" width="5" height="5" alt="*"/>
					</xsl:when>
					<xsl:otherwise>
						<img src="/_img/spacer.gif" width="{$dot_cell_width}" height="1" alt=""/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="l2" valign="top">
				<a href="{normalize-space(full_href)}" title="{normalize-space(title)}">
					<!--xsl:attribute name="href"><xsl:value-of select="full_href" disable-output-escaping="yes"/></xsl:attribute-->
					<xsl:apply-templates select="name/node()"/>
				</a>
				<xsl:apply-templates select="extra/node()"/>
			</td>
		</tr>
	</xsl:template>
	
		<xsl:template match="item" mode="arrow">
		<xsl:choose>
			<xsl:when test="full_href">
				<a href="{normalize-space(full_href)}">
					<img src="/_img/lmenu_arrow.gif" alt="{normalize-space(title)}" title="{normalize-space(title)}" width="48" height="23"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<img src="/_img/spacer.gif" width="1" height="{$arrow_cell_height}" align="left" alt=""/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="level_1_around">
		<xsl:param name="highlight"/>
		
		<tr>
			<xsl:choose>
				<xsl:when test="boolean($highlight)">
					<td><img src="/_img/ll_start.gif" width="{$hl_line_start}" height="1" alt=""/></td>
					<td><img src="/_img/ll_tail.gif" width="{$level_1_indent - $hl_line_start}" height="1" alt=""/></td>
					<td colspan="3">
						<img src="/_img/ll_tail.gif" height="1" alt="" width="{$after_1_indents - $hl_line_end}"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="5"><img src="/_img/spacer.gif" width="1" height="1" alt=""/></td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>

</xsl:stylesheet>
