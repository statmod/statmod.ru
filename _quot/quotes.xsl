<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="file://s:/_quot/singlequote.xsl"/>

<!-- Match the root node -->
<xsl:template match="/quotes">
	<span class="remove">
		<h2><xsl:copy-of select="title/node()"/></h2>
		<xsl:apply-templates select="group"/>
<script language="javascript" src="/_script/highlight_quote.js"/>
	</span>
</xsl:template>

	
<!-- Match everything else -->
<xsl:template match="group">
	<a name="{@id}"/>
	<h4><xsl:copy-of select="group_title/node()"/></h4>
	<span id="qa_{@id}">
<!--	<ul>
		<xsl:for-each select="quote">
		<li><xsl:apply-templates select="." mode="insert_quote"/></li>
		</xsl:for-each>
	</ul> -->
	<xsl:for-each select="quote"><blockquote>
	<xsl:apply-templates select="." mode="insert_quote"/>
</blockquote>
	</xsl:for-each>

     </span>
</xsl:template>


<xsl:template match="*|@*|text()|comment()">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|text()|comment()"/>
	</xsl:copy>
</xsl:template>


</xsl:stylesheet>
