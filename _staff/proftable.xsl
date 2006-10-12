<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:param name="path_xml"/>
	<xsl:param name="glob_param"/>
	<xsl:param name="current_folder"/>
	<xsl:template match="/staff">
		<span class="remove">
			<xsl:choose>
				<xsl:when test="not($glob_param/@prof) or $glob_param/@prof = 'none'">
					<xsl:apply-templates select="." mode="list"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="person[@id=$glob_param/@prof]" mode="single"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
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
фотографиями по адресу info[at]statmod.ru
</p>
	</xsl:template>
	
	<xsl:template match="person" mode="list_noimage">
		<xsl:variable name="short_name"><xsl:value-of select="ln/text()"/>&#32;<xsl:value-of select="substring(fn/text(),1,1)"/>.<xsl:value-of select="substring(mn/text(),1,1)"/>.</xsl:variable>
		<li>
			<a href="/_courses/prof/{@id}.htm">
				<xsl:value-of select="$short_name"/>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="person" mode="list">
		<xsl:variable name="short_name" select="concat(ln/text(), ' ',substring(fn/text(),1,1), '.', substring(mn/text(),1,1), '.')"/>
		<td width="143" align="center" valign="bottom" bgcolor="#eeeeee">
			<xsl:choose>
				<xsl:when test="duty/@academic_rank = 'prof'">Профессор</xsl:when>
				<xsl:when test="duty/@academic_rank = 'assoc_prof'">Доцент</xsl:when>
				<xsl:when test="duty/@academic_rank = 'senior_rf'">Cт.научн.сотр.</xsl:when>
			</xsl:choose>
			<br/>
			<a href="/_courses/prof/{@id}.htm">
				<xsl:value-of select="$short_name"/>
			</a>
			<br/>
			<xsl:value-of select="duty/shortname/text()"/>
			<br/>
			<a href="/_courses/prof/{@id}.htm">
				<img src="{substring-before(image/@name, '.')}_t.{substring-after(image/@name, '.')}" alt="{$short_name}" border="0" width="{image/@tw}" height="{image/@th}"/>
			</a>
		</td>
	</xsl:template>
	
	<xsl:template match="person" mode="single">
<xsl:variable name="long_name"><xsl:value-of select="ln/text()"/>&#32;<xsl:value-of select="fn/text()"/>&#32;<xsl:value-of select="mn/text()"/>.</xsl:variable>

	<h2>
					<xsl:choose>
				<xsl:when test="@academic_rank = 'prof'">Профессор</xsl:when>
				<xsl:when test="@academic_rank = 'assoc_prof'">Доцент</xsl:when>
				<xsl:when test="@academic_rank = 'senior_rf'">Cт.научн.сотр.</xsl:when>
			</xsl:choose>&#32;
<xsl:value-of select="$long_name"/>
</h2>
<table cellspacing="20">
  <tbody>
    <tr valign="top">
      <td> <img src="{image/@name}" alt="{$long_name}" width="{image/@w}" height="{image/@h}"/> </td>
      <td width="100%">
      <p>
 <xsl:if test="@degree != ''">
      <b>Ученая степень:</b> <spec code="#32"/>					<xsl:choose>
				<xsl:when test="@degree = 'phd_d'">доктор физ.-мат. наук</xsl:when>
				<xsl:when test="@degree = 'phd'">кандидат физ.-мат. наук</xsl:when>
			</xsl:choose>
 </xsl:if>
 <br/>
 <xsl:if test="@academic_rank != ''">
      <b>Ученое звание:</b>	 <spec code="#32"/>	<xsl:choose>
				<xsl:when test="@academic_rank = 'prof'">профессор</xsl:when>
				<xsl:when test="@academic_rank = 'assoc_prof'">доцент</xsl:when>
				<xsl:when test="@academic_rank = 'senior_rf'">старший научный сотрудник</xsl:when>
			</xsl:choose>
</xsl:if>			
<br/>
      <b>Должность:</b> <spec code="#32"/> <xsl:choose>
				<xsl:when test="duty/@academic_rank = 'prof'">профессор</xsl:when>
				<xsl:when test="duty/@academic_rank = 'assoc_prof'">доцент</xsl:when>
				<xsl:when test="duty/@academic_rank = 'senior_rf'">старший научный сотрудник</xsl:when>
			</xsl:choose><xsl:if test="duty/name/node()">, <xsl:copy-of select="duty/name/node()"/></xsl:if>			
</p>
      <p><b>Область научных интересов:</b> <xsl:copy-of select="field/node()"/></p>
      <br/>
	 <xsl:if test="extlink">
<p>
      <b>Ссылки:</b>
<xsl:apply-templates select="extlink"/>
      </p>
	 </xsl:if>
      </td>
    </tr>
    <tr>
      <td colspan="2"> <br/>
      <p>
      <xsl:copy-of select="about/node()"/>
      </p>
      <br/>
      <br/>
      <a href="/_courses/prof/index.htm">Вернуться к списку сотрудников</a> 
      </td>
    </tr>
  </tbody>
</table>

	</xsl:template>
	<xsl:template match="extlink">
<a href="{@href}" target="_blank"><xsl:copy-of select="node()"/></a> <br/>   
	</xsl:template>
</xsl:stylesheet>
