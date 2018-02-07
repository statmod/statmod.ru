<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:template match="staff" mode="list">
		<h2>Сотрудники кафедры Статистического Моделирования</h2>
		<table width="580" border="0" cellpadding="2" cellspacing="1" class="proftable">
			<xsl:for-each select="person[image]">
				<xsl:variable name="pos" select="position()"/>
				<xsl:if test="((position() mod 4) = 1)">
					<tr>
						<xsl:apply-templates select="." mode="list"/>
						<xsl:apply-templates select="../person[image][$pos+1]" mode="list"/>
						<xsl:apply-templates select="../person[image][$pos+2]" mode="list"/>
						<xsl:apply-templates select="../person[image][$pos+3]" mode="list"/>
					</tr>
					<tr><td colspan="4"><br/></td></tr>
				</xsl:if>
			</xsl:for-each>
		</table>
		<p></p>
		<ol>
			<xsl:apply-templates select="person[not(image)]" mode="list_noimage"/>
		</ol>
		<p>Уважаемые сотрудники, здесь представлен
далеко не полный
ваш список.<br/>
Просим присылать краткую информацию о себе вместе с
фотографиями по адресу <img src="/_img/email.gif" alt="email image"/>
</p>
	</xsl:template>
	
	<xsl:template match="person" mode="list_noimage">
		<xsl:variable name="short_name"><xsl:value-of select="ln/text()"/>&#32;<xsl:value-of select="substring(fn/text(),1,1)"/>.<xsl:value-of select="substring(mn/text(),1,1)"/>.</xsl:variable>
		<li>
			<a href="/chair/prof/{@id}.htm">
				<xsl:value-of select="$short_name"/>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="person" mode="list">
		<xsl:variable name="short_name" select="concat(ln/text(), ' ',substring(fn/text(),1,1), '.', substring(mn/text(),1,1), '.')"/>
		<td width="143" align="center" valign="bottom" bgcolor="#eeeeee">
			<a href="/chair/prof/{@id}.htm">
				<img src="{substring-before(image/@name, '.')}_t.{substring-after(image/@name, '.')}" alt="{$short_name}" border="0" width="{image/@tw}" height="{image/@th}"/>
			</a>
			<br/>
			<xsl:choose>
				<xsl:when test="duty/@academic_rank = 'prof'">Профессор</xsl:when>
				<xsl:when test="duty/@academic_rank = 'assoc_prof'">Доцент</xsl:when>
				<xsl:when test="duty/@academic_rank = 'assist_prof'">Ассистент</xsl:when>
				<xsl:when test="duty/@academic_rank = 'senior_rf'">Cт.научн.сотр.</xsl:when>
			</xsl:choose>
			<br/>
			<a href="/chair/prof/{@id}.htm">
				<xsl:value-of select="$short_name"/>
			</a>
			<br/>
			<xsl:value-of select="duty/shortname/text()"/>
			<br/>
		</td>
	</xsl:template>
	
	<xsl:template match="extlink">
<a href="{@href}" target="_blank"><xsl:copy-of select="node()"/></a> <br/>   
	</xsl:template>
</xsl:stylesheet>
