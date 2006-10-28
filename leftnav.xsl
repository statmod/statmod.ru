<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path_xml"/>
	<xsl:strip-space elements="item"/>
	<!-- Match the root node -->
	<xsl:template match="/item">
		<span class="remove">
			<table border="0" cellpadding="0">
				<tr height="1">
					<td>
						<img class="leftmenu_indents" src="/_img/spacer.gif" width="16" height="1"/>
					</td>
					<td>
						<img class="leftmenu_indents" src="/_img/spacer.gif" width="16" height="1"/>
					</td>
					<td width="100%">
						<img src="/_img/spacer.gif" width="50" height="1"/>
					</td>
				</tr>
				<xsl:if test="@full_href">
					<tr>
						<td align="center">
							<xsl:choose>
								<xsl:when test="@active_point = 'true'">
									<img src="/_img/menudot.gif" alt="->" width="10" height="8"/>
								</xsl:when>
								<xsl:otherwise>
									<img src="/_img/spacer.gif" width="1" height="1"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td colspan="2">
							<a href="{@full_href}">
								<xsl:value-of select="name/node()"/>
							</a>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<img src="/_img/spacer.gif" alt="" height="10" class="leftmenu_firstindent"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="item"/>
			</table>
		</span>
	</xsl:template>
	<xsl:template match="item">
		<xsl:param name="level" select="1"/>
		
		<tr>
			<xsl:if test="$level &gt; 1">
				<td>
					<img src="/_img/spacer.gif" width="1" height="1"/>
				</td>
			</xsl:if>
			<td align="center">
				<xsl:choose>
					<xsl:when test="@active_point = 'true'">
						<img src="/_img/menudot.gif" alt="->" width="10" height="8"/>
					</xsl:when>
					<xsl:otherwise>
						<img src="/_img/spacer.gif" width="1" height="1"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="$level = 1">
					<xsl:attribute name="colspan">2</xsl:attribute>
				</xsl:if>
				<a href="{@full_href}">
					<xsl:value-of select="name/node()"/>
				</a>
			</td>
		</tr>

		<xsl:apply-templates select="item">
			<xsl:with-param name="level" select="$level + 1"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
