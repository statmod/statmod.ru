<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Match the root node  -->
	<xsl:template match="/table">
		<table>
			<xsl:apply-templates select="." mode="merge"/>
		</table>
	</xsl:template>

	<!-- Match table -->
	<xsl:template match="table" mode="merge">
		<table>
			<xsl:apply-templates select="row" mode="merge"/>
		</table>
	</xsl:template>

	<!-- Match row -->
	<xsl:template match="row" mode="merge">
		<xsl:copy>
			<xsl:apply-templates select="cell" mode="merge"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="cell" mode="merge">
		<xsl:variable name="pos" select="position()"/>
				<xsl:variable name="up_colspan"><xsl:apply-templates select="(parent::row)/preceding-sibling::row[1]/cell[$pos]" mode="count_colspan"><xsl:with-param name="dataref" select="@dataref"/></xsl:apply-templates></xsl:variable>
				<xsl:variable name="colspan"><xsl:apply-templates select="." mode="count_colspan"><xsl:with-param name="dataref" select="@dataref"/></xsl:apply-templates></xsl:variable>
				<xsl:variable name="rowspan"><xsl:apply-templates select="." mode="count_rowspan"><xsl:with-param name="dataref" select="@dataref"/><xsl:with-param name="colspan" select="$colspan"/><xsl:with-param name="pos" select="$pos"/></xsl:apply-templates></xsl:variable>
		
<xsl:choose>
			<!-- Skip if already merged -->
			<xsl:when test="preceding-sibling::cell[1]/@dataref = current()/@dataref"/>
			<xsl:when test="not((parent::row)/preceding-sibling::row[1]/cell[$pos - 1]/@dataref = current()/@dataref) and ($up_colspan=$colspan)"/>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@dataref"/>
					<xsl:if test="(parent::row)/following-sibling::row[1]/cell[$pos]/@dataref = current()/@dataref">
						<xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="following-sibling::cell[1]/@dataref = current()/@dataref">
						<xsl:attribute name="colspan"><xsl:value-of select="$colspan"/></xsl:attribute>
					</xsl:if>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="cell" mode="count_colspan">
		<xsl:param name="dataref"/>
		<xsl:variable name="count_next">
			<xsl:apply-templates select="following-sibling::cell[1][@dataref = $dataref]" mode="count_colspan">
				<xsl:with-param name="dataref" select="$dataref"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="not($dataref=@dataref)">0</xsl:when>
			<xsl:when test="$count_next=''">1</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number($count_next) + 1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="cell" mode="count_rowspan">
		<xsl:param name="dataref"/>
		<xsl:param name="colspan"/>
		<xsl:param name="pos"/>
		<xsl:variable name="this_colspan">
			<xsl:apply-templates select="." mode="count_colspan">
				<xsl:with-param name="dataref" select="$dataref"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="count_next">
			<xsl:apply-templates select="(parent::row)/following-sibling::row[1]/cell[$pos][@dataref = $dataref]" mode="count_rowspan">
				<xsl:with-param name="dataref" select="$dataref"/>
				<xsl:with-param name="pos" select="$pos"/>
				<xsl:with-param name="colspan" select="$colspan"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="not($this_colspan=$colspan) or (preceding-sibling::cell[1]/@dataref = $dataref)">0</xsl:when>
			<xsl:when test="$count_next=''">1</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number($count_next) + 1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
