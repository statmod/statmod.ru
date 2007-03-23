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
<xsl:processing-instruction name="php">
 include "random_links.php";
$records = ReadListFromFile();
$subset = RandomSubset($records);
</xsl:processing-instruction>

<xsl:processing-instruction name="php"> foreach($subset as $record): </xsl:processing-instruction>
<tr><td><img src="/_img/spacer.gif" width="1" height="11"/></td></tr>
<tr><td class="quote_edge"><center><xsl:processing-instruction name="php"> print LinkText($record); </xsl:processing-instruction></center></td></tr>
<xsl:processing-instruction name="php"> endforeach; </xsl:processing-instruction>

</table>
</xsl:if>
</span>
</xsl:template>
</xsl:stylesheet>
