<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../../../leftnav.xsl"/>
	<xsl:output method="html"  omit-xml-declaration="yes" indent="yes" encoding="windows-1251"/>
	<!-- Match the root node -->
	<xsl:template match="/tree">
<!-- Function for one category -->
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php
		function my_category_item($category) {
			$full_href = get_category_link($category->cat_ID);
			$title = 0;
			if ( empty($category->category_description) )
				$tlte =  sprintf(__("Показать все записи в %s"),
						 wp_specialchars($category->cat_name));
			else
				$title= wp_specialchars(apply_filters('category_description',$category->			
											category_description,$category)) ;
			$name = apply_filters('list_cats', $category->cat_name, $category);
			
			$extra = '';
			if (! ($category->category_class === 'general') )
				$extra .= ' ('.intval($category->category_count).')';
?>
			
<?php	 if(is_category($category->cat_ID) && strlen($category->category_class) == 0) : ?>
			
]]></xsl:text>											

			<xsl:apply-templates select="item[@active_point='true']" mode="level_2"/>

<xsl:text disable-output-escaping="yes"><![CDATA[

<?php	 else: ?>

]]></xsl:text>											

			<xsl:apply-templates select="item[@active_point='false']" mode="level_2"/>

<xsl:text disable-output-escaping="yes"><![CDATA[

<?php	 endif; ?>
<?php	} ?>
]]></xsl:text>											

	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>

</xsl:stylesheet>
