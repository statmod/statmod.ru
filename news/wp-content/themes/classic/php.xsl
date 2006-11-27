<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XML Spy v3.5 NT (http://www.xmlspy.com) by  () -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:cl="http://www.climbing.spb.ru" exclude-result-prefixes="msxsl cl">
	<xsl:output method="html"  omit-xml-declaration="yes" indent="yes" encoding="windows-1251"/>
	<xsl:param name="glob_param"/>
	<xsl:param name="current_folder"/>
	<xsl:preserve-space elements="p"/>


	<xsl:variable name="contents_filename"><xsl:value-of select="$current_folder"/>contents.xml</xsl:variable>
	<xsl:variable name="locale" select="'ru-ru'"/>


	<!--                                 -->
	<!-- Match the root node            -->
	<!--                                 -->
	<xsl:template match="/">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<!--                                 -->
	<!-- Match everything else -->
	<!--                                 -->

	<xsl:template match="span[@class='remove'] | SPAN[@class='remove'] | div[@class='remove'] | DIV[@class='remove']">
		<xsl:apply-templates select="node()"/>
	</xsl:template>

	<xsl:template match="spec">
		<xsl:text disable-output-escaping="yes"><![CDATA[&]]></xsl:text>
		<xsl:value-of select="@code"/>;</xsl:template>
	<xsl:template match="speclt">
		<xsl:text disable-output-escaping="yes"><![CDATA[<]]></xsl:text>
	</xsl:template>
	<xsl:template match="specgt">
		<xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
	</xsl:template>
	<xsl:template match="specamp">
		<xsl:text disable-output-escaping="yes"><![CDATA[&]]></xsl:text>
	</xsl:template> 

	<xsl:template match="timestamp">
		<xsl:variable name="filename">
			<xsl:choose>
				<xsl:when test="@file">
					<xsl:value-of select="@file"/>
				</xsl:when>
					<xsl:otherwise>
					<xsl:value-of select="$contents_filename"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dt" select="cl:LastModified(string($filename))"/>
		<xsl:value-of select="cl:format_date($dt,'dd MMMM yyyy',$locale)"/>,
		<xsl:value-of select="cl:format_time($dt,'HH:mm',$locale)"/> 
	</xsl:template>

	<xsl:template match="img">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:if test="@alt">
			<xsl:attribute name="title"><xsl:value-of select="@alt"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="*|text()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template> 
	<!-- 								 -->
	<!-- Convert text  and attributes -->
	<!-- 								 -->
<!-- Match everything else -->
<xsl:template match="processing-instruction()">
	<xsl:text disable-output-escaping="yes"><![CDATA[<?]]></xsl:text>
<xsl:value-of select="name()"/>
<xsl:text disable-output-escaping="yes"> </xsl:text>
<xsl:value-of disable-output-escaping="yes" select="."/>

	<xsl:text disable-output-escaping="yes"><![CDATA[?>]]></xsl:text>

</xsl:template>

	<xsl:template match="text()" priority="9">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>

<!--	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template> -->
</xsl:stylesheet>
