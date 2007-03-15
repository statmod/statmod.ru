<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="glob_param"/>
<xsl:param name="current_folder"/>
<xsl:template match="/">
<span class="remove">
<xsl:if test="$current_folder = '/'">
<table border="0" cellpadding="0" cellspacing="0" id="right_pane">
<tr><td>
<img src="/_img/spacer.gif" width="196" height="62"/>
</td></tr>
<tr><td><img src="/_img/news_head.gif" width="196" height="51"/></td></tr>
<xsl:processing-instruction name="php">
include "./news/wp-shortnews.php";
</xsl:processing-instruction>
<tr><td><img src="/_img/news_edge_b.gif" width="196" height="4"/></td></tr>
</table>
</xsl:if>
</span>
</xsl:template>
</xsl:stylesheet>
