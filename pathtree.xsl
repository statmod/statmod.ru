<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:include href="path_tokenize.xsl"/>
	<xsl:param name="path_xml"/>
	<xsl:param name="current_folder"/>
	<xsl:variable name="show_parent" select="true()"/>
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
		
		<xsl:choose>
			<xsl:when test="$path_items/path_item">
				<xsl:apply-templates select="item" mode="search">
					<xsl:with-param name="path_items" select="$path_items"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<item>
					<xsl:apply-templates select="item/item[not(@hreftype = 'special')]" mode="two_levels">
						<xsl:with-param name="path_parent" select="$path_xml"/>
						<xsl:with-param name="level" select="1"/>
					</xsl:apply-templates>
				</item>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="item" mode="search">
		<xsl:param name="path_items"/>
		<xsl:variable name="next_path_items" select="$path_items/path_item"/>
		<xsl:variable name="next2_path_items" select="$next_path_items/path_item"/>
		<xsl:variable name="show_subs" select="not($next2_path_items) or (not($next2_path_items/path_item) and not(item[@href = $next_path_items/@href]/item/item))"/>
		
		<xsl:choose>
			<xsl:when test="$show_subs">
				<item>
					<xsl:if test="$show_parent">
						<full_href><xsl:value-of select="concat($path_items/@output_path,'index.htm')"/></full_href>
						<xsl:attribute name="item_in_path">true</xsl:attribute>
						<xsl:attribute name="active_point"><xsl:value-of select="not($next_path_items)"/></xsl:attribute>
						<name>...</name>
						<title><xsl:copy-of select="name/node()"/></title>
					</xsl:if>
					<xsl:apply-templates select="item[not(@hreftype = 'special')]">
						<xsl:with-param name="path_items" select="$next_path_items"/>
						<xsl:with-param name="path_item" select="$next_path_items/@href"/>
						<xsl:with-param name="parent_output_path" select="$path_items/@output_path"/>
					</xsl:apply-templates>
				</item>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="item[@href = $next_path_items/@href]" mode="search">
					<xsl:with-param name="path_items" select="$next_path_items"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="item">
		<xsl:param name="path_items"/>
		<xsl:param name="path_item"/>
		<xsl:param name="parent_output_path"/>
		<xsl:variable name="item_in_path" select="@href = $path_item"/>
		<xsl:variable name="next_path_items" select="$path_items/path_item"/>
		<xsl:variable name="active_point" select="$item_in_path and not($next_path_items)"/>
		
		
		<!-- output current point -->
		<item  item_in_path="{$item_in_path}" active_point="{$active_point}">
			<full_href>
<xsl:value-of select="concat($parent_output_path,@href,'/index.htm')"/>
			</full_href>
			<xsl:copy-of select="name"/> 
				<!-- output children -->
			
			<xsl:if test="$item_in_path">
				<xsl:apply-templates select="item[not(@hreftype = 'special')]">
					<xsl:with-param name="path_item" select="$next_path_items/@href"/>
					<xsl:with-param name="path_items" select="$next_path_items"/>
					<xsl:with-param name="parent_output_path" select="$path_items/@output_path"/>
				</xsl:apply-templates>
			</xsl:if>
		</item>
	</xsl:template>

	<xsl:template match="item" mode="two_levels">
		<xsl:param name="path_parent"/>
		<xsl:param name="level"/>
		<xsl:variable name="this_path" select="concat($path_parent,@href,'/')"/>
		
		<item  item_in_path="'false'" active_point="'false'">
			<full_href>
<xsl:value-of select="concat($this_path,'index.htm')"/>
			</full_href>
			<xsl:copy-of select="name"/> 
			<xsl:if test="$level &lt; 2">
				<xsl:apply-templates select="item" mode="two_levels">
					<xsl:with-param name="path_parent" select="$this_path"/>
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:apply-templates>
			</xsl:if>
		</item>
	</xsl:template>
</xsl:stylesheet>


