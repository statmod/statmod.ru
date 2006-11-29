<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../../../leftnav.xsl"/>
	<xsl:output method="html"  omit-xml-declaration="yes" indent="yes" encoding="windows-1251"/>
	<!-- Match the root node -->
	<xsl:template match="/">
<!-- Function for one category -->
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php
		function my_archive_level_2($arcresult, $m, $show_post_count = 1) {
			global $month;
		
			$full_href = get_month_link($arcresult->year,	$arcresult->month);
			$extra = '';
/*			if ( $show_post_count ) {
				$extra = '&nbsp;('.$arcresult->posts.')' . $afterafter;
			} */
			
			$name = sprintf('%s %d', $month[zeroise($arcresult->month,2)], $arcresult->year);
			$name = wptexturize($name);
			$title = wp_specialchars($name, 1); 
?>
<?php	 if($m == ($arcresult->year) . (zeroise($arcresult->month, 2))) : ?>
			
]]></xsl:text>											
<xsl:apply-templates select="tree/item[@active_point='true' and @item_in_path='true']" mode="level_2"/>
<xsl:text disable-output-escaping="yes"><![CDATA[

<?php	 else: ?>

]]></xsl:text>											
<xsl:apply-templates select="tree/item[@item_in_path='false']" mode="level_2"/>
<xsl:text disable-output-escaping="yes"><![CDATA[

<?php	 endif; ?>
<?php	} ?>
]]></xsl:text>											

	</xsl:template>
	
	<xsl:template match="text()" priority="9">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>


</xsl:stylesheet>
