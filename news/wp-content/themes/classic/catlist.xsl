<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../../../../leftnav.xsl"/>
	<xsl:output method="html"  omit-xml-declaration="yes" indent="yes" encoding="windows-1251"/>
	<!-- Match the root node -->
	<xsl:template match="/item">
		<xsl:apply-templates select="item" mode="level_1"/>
	</xsl:template>

	
	<xsl:template match="item" mode="level_2">
<xsl:choose>
	<xsl:when test="@php_id = 'category'">
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php require('category_item.php'); ?>
<?php
	$file = get_settings('home') . '/';
	// Получить список категорий, отсортированный по ID
	$sort_column = 'cat_ID';

	$query = "
		SELECT cat_ID, cat_name, category_nicename, category_description, category_parent, category_count, category_class, cat_menu_order  
			FROM $wpdb->categories
			WHERE cat_ID > 0 $exclusions
			ORDER BY $sort_column $sort_order";
	$categories = $wpdb->get_results($query);

foreach ( $categories as $category ) {
		if ($category->category_count) { // Если категория не пуста
			my_category_item($category, $wp_query);
		}
}
?>
]]></xsl:text>				
</xsl:when>							
<xsl:when test="@php_id = 'archive'">
<xsl:text disable-output-escaping="yes"><![CDATA[
<?php require('archive_item.php'); ?>
<?php	
	global $wpdb;
	
	$limit = '';
	if ( '' != $limit ) {
		$limit = (int) $limit;
		$limit = ' LIMIT '.$limit;
	}

	$now = current_time('mysql');

	$arcresults = $wpdb->get_results("SELECT DISTINCT YEAR(post_date) AS `year`, MONTH(post_date) AS `month`, count(ID) as posts FROM $wpdb->posts WHERE post_date < '$now' AND post_date != '0000-00-00 00:00:00' AND post_status = 'publish' GROUP BY YEAR(post_date), MONTH(post_date) ORDER BY post_date DESC" . $limit);
	if ( $arcresults ) {
		foreach ( $arcresults as $arcresult ) {
			my_archive_item($arcresult);
		}
	}
?>
]]></xsl:text>				
</xsl:when>							
</xsl:choose>

	</xsl:template>								
</xsl:stylesheet>
