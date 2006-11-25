<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../../../leftnav.xsl"/>
	<xsl:output method="html"  omit-xml-declaration="yes" indent="yes" encoding="windows-1251"/>
	<xsl:variable name="php_id" select="/tree/@php_id"/>
	<!-- Match the root node -->
	<xsl:template match="/">
<xsl:text disable-output-escaping="yes"><![CDATA[<?php
require_once('category_func.php');

function my_category_level_2($category) {
  $full_href = my_category_get_full_href($category);
  $name = my_category_get_name($category);
  $title = my_category_get_title($category);
  $extra = my_category_get_extra($category);

?>]]></xsl:text>		


<xsl:text disable-output-escaping="yes"><![CDATA[
<?php if(is_category($category->cat_ID) && strlen($category->category_class) == 0)  : ?>
]]></xsl:text>				
<xsl:apply-templates select="tree/item[@active_point = 'true']"
mode="level_2"/>
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php else : ?>
]]></xsl:text>				
<xsl:apply-templates select="tree/item[@active_point = 'false' and @item_in_path='false']"
mode="level_2"/>
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php endif; 
}
?>
]]></xsl:text>				
	</xsl:template>
		<xsl:template match="text()" priority="9">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>

</xsl:stylesheet>
