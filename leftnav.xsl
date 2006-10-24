<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="path_xml"/>

	<xsl:strip-space elements="item"/>
	<!-- Match the root node -->
	<xsl:template match="/tree">

		<span class="remove">
			<table border="0" cellpadding="0">
				<tr height="1">
					<td><img class="leftmenu_indents" src="/_img/spacer.gif" width="16" height="1"/></td>
					<td><img class="leftmenu_indents" src="/_img/spacer.gif" width="16" height="1"/></td>
					<td width="100%"><img src="/_img/spacer.gif" width="50" height="1"/></td>
				</tr>
				<xsl:apply-templates select="item"/>
			</table>
		</span>
	</xsl:template>
	
	<xsl:template match="item">
		<tr>
			<xsl:if test="@level &gt; 2"><td><img src="/_img/spacer.gif" width="1" height="1"/></td></xsl:if>
			<td align="center">
				<xsl:choose>
					<xsl:when test="@active_point = 'true'"><img src="/_img/menudot.gif" alt="->" width="10" height="8"/></xsl:when>
					<xsl:otherwise>	<img src="/_img/spacer.gif" width="1" height="1"/></xsl:otherwise>
				</xsl:choose>
			</td>
			<td >
				<xsl:if test="not(@level &gt; 2)"><xsl:attribute name="colspan">2</xsl:attribute></xsl:if>
				<a href="{@full_href}"><xsl:value-of select="name/node()"/></a>
			</td>
		</tr>

		<xsl:if test="@level = 1">
			<tr>
				<td colspan="3">
					<img src="/_img/spacer.gif" alt="" height="10" class="leftmenu_firstindent"/>
				</td>
			</tr>
		</xsl:if>
		
		<xsl:if test="@level &lt; 3">
			<xsl:apply-templates select="item"/>
		</xsl:if>
			
	</xsl:template>



</xsl:stylesheet>
