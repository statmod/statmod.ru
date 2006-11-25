<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Match the root node -->
	<xsl:template name="path.tokenize">
		<xsl:param name="path"/>
		<xsl:param name="output_prefix"/>

		<xsl:if test="$path != ''">
			<xsl:variable name="path_item" select="substring-before($path, '/')"/>
			<xsl:variable name="next_path" select="substring-after($path, '/')"/>
			<xsl:variable name="next_output">
				<xsl:value-of select="$output_prefix"/>
				<xsl:if test="$path_item != ''">
					<xsl:value-of select="$path_item"/>/</xsl:if>
			</xsl:variable>
			
			<path_item href="{$path_item}" output_path="{$next_output}">
				<xsl:call-template name="path.tokenize">
					<xsl:with-param name="path" select="$next_path"/>
					<xsl:with-param name="output_prefix" select="$next_output"/>
				</xsl:call-template>
			</path_item>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
