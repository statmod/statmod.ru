<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:template match="lesson" mode="add_ref">
		<xsl:copy>
			<xsl:attribute name="dataref"><xsl:value-of select="position()"/></xsl:attribute>
			<xsl:copy-of select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="gen_table_part">
		<xsl:param name="error_location"/>
		<xsl:param name="lessons_with_ref"/>
		<table>
			<!-- Two row table  -->
			<row>
				<xsl:call-template name="gen_table_row">
					<xsl:with-param name="lessons" select="msxsl:node-set($lessons_with_ref)/lesson[fortnightly/@type=1 or not(fortnightly)]"/>
					<xsl:with-param name="error_location" select="$error_location"/>
				</xsl:call-template>
			</row>
			<row>
				<xsl:call-template name="gen_table_row">
					<xsl:with-param name="lessons" select="msxsl:node-set($lessons_with_ref)/lesson[fortnightly/@type=2 or not(fortnightly)]"/>
					<xsl:with-param name="error_location" select="$error_location"/>
				</xsl:call-template>
			</row>
		</table>
	</xsl:template>

	<xsl:template name="gen_table_row">
		<xsl:param name="error_location"/>
		<xsl:param name="lessons"/>

		<!-- This bound is needed because there can be no lessons -->
		<xsl:variable name="lessons_bounded">
			<lessons><xsl:copy-of select="$lessons"/></lessons>
		</xsl:variable>
		
		<xsl:for-each select="msxsl:node-set($specs)/specs/spec">
			<xsl:variable name="cur_lesson" select="msxsl:node-set($lessons_bounded)/lessons/lesson[@spec = 'all' or contains(@spec, current()/@id)]"/>
			
			<xsl:choose>
				<xsl:when test="not(boolean($cur_lesson))"><cell dataref="0"/></xsl:when>
				<xsl:when test="count($cur_lesson) = 1"><cell dataref="{$cur_lesson/@dataref}"/></xsl:when>
				<xsl:otherwise>  <!-- Error! lessons can't overlap  -->
					<xsl:message terminate="yes">Lessons can't overlap. Occured at <xsl:value-of select="$error_location"/>.</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>

