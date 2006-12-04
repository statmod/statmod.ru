<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:template match="person" mode="single">
<xsl:param name="has_timetable"/>
<xsl:variable name="long_name"><xsl:value-of select="ln/text()"/>&#32;<xsl:value-of select="fn/text()"/>&#32;<xsl:value-of select="mn/text()"/></xsl:variable>

	<h2>
			<xsl:choose>
				<xsl:when test="@academic_rank = 'prof'">Профессор</xsl:when>
				<xsl:when test="@academic_rank = 'assoc_prof'">Доцент</xsl:when>
				<xsl:when test="@academic_rank = 'senior_rf'">Cт.научн.сотр.</xsl:when>
			</xsl:choose>&#32;
<xsl:value-of select="$long_name"/>
</h2>
<table cellspacing="20">
    <tr valign="top">
      <td width="178"> 
 <img src="_img/spacer.gif" alt="" width="178" height="1"/> <br/>
<xsl:if test="image/@name">
<img src="{image/@name}" alt="{$long_name}" width="{image/@w}" height="{image/@h}"/> 
</xsl:if>
</td>
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

      </td>
    </tr>
    <tr valign="top">
      <td> <p>
	<xsl:if test="$has_timetable">
	      <a href="#timetable">К расписанию</a> 
	      <br/>
	</xsl:if>
      <a href="/chair/prof/index.htm">К списку сотрудников</a> 
	</p>
      </td>
      <td>
	 <xsl:if test="extlink">
<p>
      <b>Ссылки:</b> <spec code="#32"/> <xsl:apply-templates select="extlink"/>
      </p>
	 </xsl:if>
	</td>
    </tr>
    <tr>
      <td colspan="2"> 
	      <p>
      	<xsl:copy-of select="about/node()"/>
		</p>
      </td>
    </tr>
</table>

	</xsl:template>
	<xsl:template match="extlink">
<a href="{@href}" target="_blank"><xsl:copy-of select="node()"/></a> <br/>   
	</xsl:template>
</xsl:stylesheet>
