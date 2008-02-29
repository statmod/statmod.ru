<?xml version="1.0" encoding="UTF-8"?>
	<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
      xmlns:pr="http://statmod.ru/staff">
	<xsl:import href="mergecells.xsl"/>
	<xsl:include href="gen_lesson_table.xsl"/>
	<!-- xsl:include href="resolve_prof.xsl"/-->
	<xsl:param name="loc_param"/>
	<xsl:param name="glob_param"/>
	<xsl:variable name="cell_width" select="'72pt'"/>
	<xsl:variable name="cell_height" select="'28pt'"/>

	<xsl:variable name="two_hours_names" select="document('../_courses/two_hours.xml')"/>

	<xsl:variable name="specs">
		<specs>
			<spec id="sa">
				<name>САПР</name>
			</spec>
			<spec id="sm">
				<name>СМ</name>
			</spec>
			<spec id="mm">
				<name>ММ</name>
			</spec>
		</specs>
	</xsl:variable>
	<xsl:variable name="weekdays">
		<week>
			<day id="mon">Понедельник</day>
			<day id="tue">Вторник</day>
			<day id="wed">Среда</day>
			<day id="thu">Четверг</day>
			<day id="fri">Пятница</day>
			<day id="sat">Суббота</day>
		</week>
	</xsl:variable>

	<!-- Match the root node -->
	<xsl:template match="/">
<span class="remove">
	<html>
		<head>
	<link href="/statmod.css" rel="stylesheet" type="text/css"/>
		</head>
		<body style="margin: 0">
<table border="0" cellspacing="0" cellpadding="5">					
				<tr>
					<td class="content_cell">
<xsl:apply-templates select="timetable"/>
					</td>
				</tr>
</table>
		</body>
	</html>
</span>
	</xsl:template>
	<xsl:template match="timetable">
		<span class="remove">
<h2><xsl:value-of select="ceiling(@semester div 2)"/>-й курс,
<xsl:value-of select="msxsl:node-set($specs)/specs/spec[@id=$glob_param/@spec]"/>,
<xsl:choose>
<xsl:when test="@semester mod 2 = 0">
весенний семестр 
<xsl:value-of select="@year - 1"/>-<xsl:number value="@year mod 100" format="01"/>
</xsl:when>
<xsl:otherwise>
осенний семестр 
<xsl:value-of select="@year"/>-<xsl:number value="(@year + 1) mod 100" format="01"/>
</xsl:otherwise>
</xsl:choose>
</h2>

<p>Просто распечатайте эту страницу, вырежьте табличку и сложите ее пополам :)</p>

			<table class="timetable_spec" border="1" cellspacing="0">
			<tr valign="top">
<td class="system"></td>
<td class="system"></td>
<xsl:for-each select="msxsl:node-set($weekdays)/week/day[position() &lt;= 3]" >
<td class="system"><img src="/_img/spacer.gif" style="height: 1pt; width:{$cell_width}" border="0"/></td>
</xsl:for-each>
			</tr>
			<xsl:call-template name="days_row">	
				<xsl:with-param name="days" select="msxsl:node-set($weekdays)/week/day[position() &lt;= 3]"/>
				<xsl:with-param name="tt" select="."/>
			</xsl:call-template>
			<xsl:call-template name="days_row">	
				<xsl:with-param name="days" select="msxsl:node-set($weekdays)/week/day[position() &gt; 3]"/>
				<xsl:with-param name="tt" select="."/>
			</xsl:call-template>
			</table>
		</span>
	</xsl:template>
	
<xsl:template name="days_row">	
	<xsl:param name="days"/>
	<xsl:param name="tt"/>
	<tr valign="top">
		<td class="system"></td>
		<td class="weekday_name"><xsl:value-of select="ceiling(@semester div 2)"/>
<spec code="nbsp"/><xsl:value-of select="substring(msxsl:node-set($specs)/specs/spec[@id=$glob_param/@spec],1,2)"/></td>
		<xsl:for-each select="$days">
			<td class="weekday_name" style="width:{$cell_width};"><xsl:value-of select="text()"/></td>
		</xsl:for-each>
	</tr>
	<xsl:for-each select="$two_hours_names//two_hours">
		<xsl:variable name="no" select="@no"/>
		<tr valign="middle">
			<td class="system"><img src="/_img/spacer.gif" width="1" style="height: {$cell_height};"/></td>
			<td class="two_h_info" valign="top">
				<span class="biginfo"><spec code="nbsp"/><xsl:value-of select="@no"/></span>
				<span class="smallinfo"><br/><br/><xsl:value-of select="@start_time"/><spec code="nbsp"/>-<br/><xsl:value-of select="@end_time"/></span>
			</td>
			<xsl:for-each select="$days" >
				<td class="lesson_cell"><xsl:apply-templates select="$tt/weekday[@id = current()/@id]/two_hours[@no=$no]"/></td>
			</xsl:for-each>
		</tr>
	</xsl:for-each>
</xsl:template>	
	
	<xsl:template match="two_hours">
		<xsl:variable name="filtered_lessons" >
			<lessons><xsl:copy-of select="lesson[@spec = 'all' or contains(@spec, $glob_param/@spec)]"/></lessons>
		</xsl:variable>
		<xsl:variable name="this_error_location" select="concat('Weekday:', ../@id, ', Two hours: ', @no)"/>
		<xsl:variable name="les_cnt" select="count(msxsl:node-set($filtered_lessons)/lessons/lesson) "/>

		<xsl:choose>
			<xsl:when test="$les_cnt = 0">
<table><tr><td></td></tr></table>
			</xsl:when>
			<xsl:when test="msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly]">
				<xsl:if test="msxsl:node-set($filtered_lessons)/lessons/lesson[not(fortnightly)] 				or (count(msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly/@type=1]) &gt; 1) or (count(msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly/@type=2]) &gt; 1)">
					<xsl:message terminate="yes">	
						Lessons can't overlap. Occured at <xsl:value-of select="$error_location"/>.
					</xsl:message>
				</xsl:if>
<table border="0" cellspacing="0" cellpadding="0" width="100%" valign="middle"><tr><td class="fortnightly">
<xsl:call-template name="lesson">
<xsl:with-param name="lesson" select="msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly/@type=1]"/>
<xsl:with-param name="shorten" select="1"/>
</xsl:call-template></td></tr>
<tr><td style="padding: 1pt"><!--hr style="padding:1pt;"/--><img src="/_img/bspacer.gif" alt="" style="width: 100%; height: 1pt; padding: 0pt; "/></td></tr><tr><td class="fortnightly">
<xsl:call-template name="lesson">
<xsl:with-param name="lesson" select="msxsl:node-set($filtered_lessons)/lessons/lesson[fortnightly/@type=2]"/>
<xsl:with-param name="shorten" select="1"/>
</xsl:call-template></td></tr></table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$les_cnt &gt; 1">
					<xsl:message terminate="yes">	
						Too many lessons. Occured at <xsl:value-of select="$error_location"/>.
					</xsl:message>
				</xsl:if>
<table border="0" cellspacing="0" cellpadding="0"><tr><td class="common">
<xsl:call-template name="lesson">
<xsl:with-param name="lesson" select="msxsl:node-set($filtered_lessons)/lessons/lesson"/>
<xsl:with-param name="shorten" select="0"/>
</xsl:call-template></td></tr></table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="lesson">
<xsl:param name="shorten"/>
<xsl:param name="lesson"/>
<span class="biginfo"><b>
			<xsl:for-each select="$lesson/location"><xsl:value-of select="text()"/><xsl:if test="position()!=last()">,<spec code="nbsp"/></xsl:if></xsl:for-each>
		</b><spec code="nbsp"/><xsl:copy-of select="$lesson/course/prof/node()"/></span><br/>
<span class="smallinfo">
<xsl:choose>
<xsl:when test="$shorten=1">
	<xsl:call-template name="shorten_text">
		<xsl:with-param name="text" select="string($lesson/course/name/text())"/>
		<xsl:with-param name="len" select="25"/>
	</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$lesson/course/name/text()"/>
</xsl:otherwise>
</xsl:choose><spec code="nbsp"/>
</span>
	</xsl:template>
	
	<xsl:template name="shorten_text">
		<xsl:param name="text"/>
		<xsl:param name="len"/>
		<xsl:choose>
			<xsl:when test="string-length($text) &gt; $len">
				<xsl:call-template name="tokenize_text">
					<xsl:with-param name="text" select="$text"/>
					<xsl:with-param name="separator" select="' '"/>
					<xsl:with-param name="max_len" select="$len"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
					<xsl:copy-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="tokenize_text">
		<xsl:param name="text"/>
		<xsl:param name="separator"/>
		<xsl:param name="max_len"/>

		<xsl:if test="$text != ''">
			<xsl:choose>
				<xsl:when test="not(contains($text,$separator))">
					<xsl:if test="string-length($text) &lt;= $max_len"><xsl:value-of select="$text"/></xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="word" select="substring-before($text, $separator)"/>
					<xsl:variable name="word_w_sep" select="concat($word,$separator)"/>
					
					<xsl:if test="string-length($word_w_sep) &lt;= $max_len">
						<xsl:value-of select="$word_w_sep"/>
						<xsl:call-template name="tokenize_text">
							<xsl:with-param name="text" select="substring-after($text, $separator)"/>
							<xsl:with-param name="separator" select="$separator"/>
							<xsl:with-param name="max_len" select="$max_len - string-length($word_w_sep)"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
	</xsl:template>

	
</xsl:stylesheet>
