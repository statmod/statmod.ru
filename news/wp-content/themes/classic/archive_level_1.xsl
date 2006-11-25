<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../../../leftnav.xsl"/>
	<xsl:output method="html"  omit-xml-declaration="yes" indent="yes" encoding="windows-1251"/>
	<!-- Match the root node -->
	<xsl:template match="/">
<!-- Function for one category -->
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php
require_once('archive_level_2.php');
global $wpdb;
	
	$limit = '';
	if ( '' != $limit ) {
		$limit = (int) $limit;
		$limit = ' LIMIT '.$limit;
	}

	$now = current_time('mysql');

	$arc_items = $wpdb->get_results("SELECT DISTINCT YEAR(post_date) AS `year`, MONTH(post_date) AS `month`, count(ID) as posts FROM $wpdb->posts WHERE post_date < '$now' AND post_date != '0000-00-00 00:00:00' AND post_status = 'publish' GROUP BY YEAR(post_date), MONTH(post_date) ORDER BY post_date DESC" . $limit);
?>
<?php	 if($m) : ?>
			
]]></xsl:text>											
<xsl:apply-templates select="tree/item[@item_in_path='true' and @active_point='false']" mode="level_1"/>
<xsl:text disable-output-escaping="yes"><![CDATA[

<?php	 else: ?>

]]></xsl:text>											
<xsl:apply-templates select="tree/item[@item_in_path='false']" mode="level_1"/>
<xsl:text disable-output-escaping="yes"><![CDATA[

<?php	 endif; ?>
]]></xsl:text>											

	</xsl:template>
	
<xsl:template match="item" mode="level_2">
<xsl:text disable-output-escaping="yes"><![CDATA[<?php
if ($arc_items) {
	foreach ($arc_items as $item) {
		my_archive_level_2($item, $m);
	}
}
?>]]></xsl:text>
	</xsl:template>	
	
	<xsl:template match="text()" priority="9">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>

</xsl:stylesheet>
