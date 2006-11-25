<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../../../leftnav.xsl"/>
	<xsl:output method="html"  omit-xml-declaration="yes" indent="yes" encoding="windows-1251"/>
	<!-- Match the root node -->
	<xsl:template match="/">
<xsl:apply-templates select="tree/init_code/processing-instruction()"/>

<xsl:text disable-output-escaping="yes"><![CDATA[
<?php
	if ($show_arrow) : 
?>]]></xsl:text>		
<xsl:apply-templates select="tree/item[@id = 'arrow']" mode="level_0"/>
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php else : ?>
]]></xsl:text>				
<xsl:apply-templates select="tree/item[not(@id = 'arrow')]"
mode="level_0"/>
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php endif; ?>
]]></xsl:text>		

	</xsl:template>

	
<xsl:template match="item" mode="level_1">
<xsl:apply-templates select="/tree/list_code/processing-instruction()"/>
</xsl:template>								

	<xsl:template match="processing-instruction()">
	<xsl:text disable-output-escaping="yes"><![CDATA[<?]]></xsl:text>
<xsl:value-of select="name()"/>
<xsl:text disable-output-escaping="yes"> </xsl:text>
<xsl:value-of disable-output-escaping="yes" select="."/>

	<xsl:text disable-output-escaping="yes"><![CDATA[?>]]></xsl:text>

</xsl:template>


</xsl:stylesheet>
