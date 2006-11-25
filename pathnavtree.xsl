<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:include href="path_tokenize.xsl"/>
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<xsl:strip-space elements="item"/>

	<!-- Match the root node -->
	<xsl:template match="/">
		<xsl:variable name="path_parent" select="substring($path_xml, 0, string-length($path_xml))"/>
		<xsl:variable name="cut_path" select="substring-after($current_folder, $path_parent)"/>
		
		<xsl:variable name="tokenized_path">
			<xsl:call-template name="path.tokenize">
				<xsl:with-param name="path" select="$cut_path"/>
				<xsl:with-param name="output_prefix" select="$path_xml"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="path_items" select="msxsl:node-set($tokenized_path)/path_item"/>
		
		<xsl:apply-templates select="item">
			<xsl:with-param name="path_items" select="$path_items"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="item">
		<xsl:param name="path_items"/>
		<xsl:variable name="next_path_items" select="$path_items/path_item"/>
		
		<!-- output current point -->
		<item full_href="{$path_items/@output_path}index.htm" active_point="{not($next_path_items)}">
			<xsl:copy-of select="name"/> 
			<!-- output children -->
			<xsl:apply-templates select="item[@href = $next_path_items/@href]">
				<xsl:with-param name="path_items" select="$next_path_items"/>
			</xsl:apply-templates>
		</item>
	</xsl:template>
</xsl:stylesheet>