<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<xsl:strip-space elements="span"/>
	<!-- Match the root node -->
	<xsl:template match="/item">
		<span class="remove">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<img src="/_img/spacer.gif" alt="" width="18" height="21"/>
					</td>
					<xsl:apply-templates select="item[not(@hreftype = 'special')]" mode="single"/>
				</tr>
			</table>
		</span>
	</xsl:template>
	<xsl:template match="item" mode="single">
		<xsl:variable name="real_href" select="concat($path_xml, @href, '/')"/>
		<xsl:variable name="img_src_suffix">
			<xsl:if test="contains($current_folder, $real_href)">_h</xsl:if>
		</xsl:variable>
		<td>
			<a href="{concat($real_href, 'index.htm')}">
				<img border="0" src="/_img/topnav/{@href}{normalize-space($img_src_suffix)}.gif" alt="{name/text()}"/>
			</a>
		</td>
		<xsl:if test="not(position()=last())">
			<td>
				<img src="/_img/spacer.gif" width="36" height="1" alt=""/>
			</td>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
