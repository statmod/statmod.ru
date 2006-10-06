<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="file://s:/_quot/singlequote.xsl"/>

<xsl:variable name="mixquotes" select="document('/_quot/mixquotes.xml')"
/>
<!-- Match the root node -->
<xsl:template match="/">
	<xsl:apply-templates select="*"/>
</xsl:template>

<xsl:template match="q">
	<xsl:choose>
		<xsl:when test="starts-with(@cite, 'quot://')">
<xsl:apply-templates select="." mode="insert_quote"/>
		</xsl:when>
		<xsl:otherwise>
<xsl:copy-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


	
<!-- Match everything else -->
<xsl:template match="*|@*|text()|comment()">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|text()|comment()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="q" mode="insert_quote">
	<xsl:variable name="temp1" select="substring-after(@cite, 'quot://')"/>
 	<xsl:variable name="file_name" select="substring-before($temp1, '#')"/>
 	<xsl:variable name="quote_id" select="substring-after($temp1, '#')"/>
	<xsl:if test="$file_name = 'mixquotes'">
		<xsl:variable name="quotesgroup" select="$mixquotes//group[@id=$quote_id]"/>
<a href="#" onclick="return toggle_quote('q_{$quote_id}');" class="imagelink">
<img border="0" name="q_{$quote_id}_img" src="/_img/a_red_small.gif" alt="посмотреть цитату"/>
</a>
<spec code="nbsp"/>
		<span class="quotform" id="q_{$quote_id}"  style="display:none">
<div>		
<xsl:apply-templates select="$quotesgroup//quote[1]" mode="insert_quote"/>			
</div>		
<xsl:if test="count($quotesgroup//quote) &gt; 1">
<a href="/graduates/quotes/mixquotes/index.htm#{$quote_id}" target="_blank">далее</a>
<xsl:value-of select="text()"/>
<br/>
</xsl:if>
		</span>
		<span id="q_{$quote_id}_add">
			<xsl:value-of select="text()"/>
		</span>
		<script language="javascript">toggle_quote('q_{$quote_id}');</script>
	</xsl:if>

</xsl:template>


</xsl:stylesheet>
