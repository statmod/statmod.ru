<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>

	<xsl:variable name="weekdays" select="document('weekdays.xml')"/>
	<xsl:variable name="two_hours" select="document('two_hours.xml')"/>
	
	<!-- Match the root node -->
	<xsl:template match="/timetables">
		<timetable>
			<xsl:variable name="this" select="."/>
			<xsl:for-each select="$weekdays//day">
				<xsl:variable name="weekday_id" select="@id"/>
				<weekday id="{$weekday_id}">
					<xsl:for-each select="$two_hours//two_hours">
						<xsl:variable name="two_hours_no" select="@no"/>
						<two_hours no="{$two_hours_no}">
							<xsl:for-each select="$this/timetable">
								<xsl:apply-templates select="weekday[@id=$weekday_id]/two_hours[@no=$two_hours_no]/lesson">
									<xsl:with-param name="year_no"  select="ceiling(@semester div 2)"/>
								</xsl:apply-templates>
							</xsl:for-each>
						</two_hours>
					</xsl:for-each>
				</weekday>
			</xsl:for-each>
		</timetable>
	</xsl:template>
	
	<xsl:template match="lesson">
		<xsl:param name="year_no"/>
		<lesson year_no="{$year_no}">
			<xsl:apply-templates select="@*|node()"/>
		</lesson>
	</xsl:template>
	
	<!-- Match everything else -->
	<xsl:template match="*|@*|text()|comment()">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()|comment()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
