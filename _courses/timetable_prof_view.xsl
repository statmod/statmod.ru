<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>

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
			<spec id="all">
				<name>вся группа</name>
			</spec>
		</specs>
	</xsl:variable>
	<xsl:variable name="weekdays" select="document('weekdays.xml')"/>
	
	<!-- Match the root node -->
	<xsl:template match="timetable" mode="prof_view">
		<span class="remove">
		<xsl:if test="weekday[descendant::lesson]">
		<a name="timetable"><h3>Расписание:</h3></a>
		<xsl:apply-templates select="weekday[descendant::lesson]"  mode="prof_view"/>
		</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="timetable" mode="common_view">
		<span class="remove">
			<xsl:apply-templates select="weekday[descendant::lesson]"  mode="prof_view"/>
		</span>
	</xsl:template>

	
	<xsl:template match="weekday"  mode="prof_view">
		<h4><xsl:value-of select="$weekdays//day[@id=current()/@id]"/></h4>
		<xsl:apply-templates select="two_hours"  mode="prof_view"/>
	</xsl:template>

	<xsl:template match="two_hours"  mode="prof_view">
		<xsl:if test="lesson">
		<p>
		<b><xsl:value-of select="@no"/>-я пара: </b>
		<xsl:choose>
			<xsl:when test="lesson/course/fortnightly">
				<ul>	
					<xsl:for-each select="lesson">
						<xsl:sort order="ascending" select="course/fortnightly/@type"/>
						<li><xsl:apply-templates select="."  mode="prof_view"/></li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="lesson"  mode="prof_view"/>
			</xsl:otherwise>
		</xsl:choose>
		</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="lesson"  mode="prof_view">
		<xsl:if test="fortnightly">
			<xsl:choose>
				<xsl:when test="fortnightly/@type = 1">числитель</xsl:when>
				<xsl:when test="fortnightly/@type = 2">знаменатель</xsl:when>
			</xsl:choose>,
		</xsl:if>
		<xsl:apply-templates select="location"  mode="prof_view"/>,
		<xsl:value-of select="@year_no"/>-й курс,
		<xsl:call-template name="spec_list">
			<xsl:with-param name="list" select="@spec"/>
		</xsl:call-template>,
		<i>"<xsl:value-of select="course/name/text()"/>"</i>.<br/>
	</xsl:template>

	<xsl:template match="location"  mode="prof_view">
		<b><xsl:value-of select="text()"/></b><xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:template name="spec_list">
		<xsl:param name="list" select="@spec"/>
		<xsl:param name="separator" select="','"/>
		<xsl:variable name="list_head">
			<xsl:choose>
				<xsl:when test="contains($list, $separator)"><xsl:value-of select="substring-before($list, $separator)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$list"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="list_tail" select="substring-after($list, $separator)"/>
		<xsl:value-of select="msxsl:node-set($specs)//spec[@id = $list_head]/name/text()"/>
		<xsl:if test="$list_tail">
			,
			<xsl:call-template name="spec_list">
				<xsl:with-param name="list" select="$list_tail"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
