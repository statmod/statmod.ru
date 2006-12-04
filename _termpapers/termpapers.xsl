<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="current_folder"/>
<xsl:variable name="profs" select="document('../_staff/prof.xml')"/>
<xsl:template match="/termpapers">
   <html>
      <head>
         <title>Список курсовых работ (2-й курс)</title>
      </head>
      <body>
         <h2>Курсовые работы для второго курса (2006-2007 гг.)</h2>
	   <xsl:apply-templates select="prof"/>
      </body>
   </html>
</xsl:template>

<xsl:template match="/html">
	<xsl:copy>
		<xsl:apply-templates select="*|node()|text()|comment"/>
	</xsl:copy>
</xsl:template>
<xsl:template match="body">
	<xsl:copy>
		<xsl:apply-templates select="*|node()|text()|comment"/>
		<p><a href="{$current_folder}index.htm">К списку курсовых</a></p>
	</xsl:copy>
</xsl:template>


<xsl:template match="prof">
	<h3>
<xsl:value-of select="$profs/staff/person[@id=current()/@id]/ln"/>&#32;
<xsl:value-of select="$profs/staff/person[@id=current()/@id]/fn"/>&#32;
<xsl:value-of select="$profs/staff/person[@id=current()/@id]/mn"/>
&#32;<span class="msg_info">(<xsl:value-of select="location"/>)</span>
</h3>
	<ol>
	<xsl:for-each select="paper">
		<li><xsl:copy-of select="title/node()"/></li>
		<xsl:apply-templates select="biblitem"/>
	</xsl:for-each>
	</ol>
	<xsl:apply-templates select="comment"/>
	<xsl:if test="@comments = 'yes'">
<p><a href="{$current_folder}{@id}.htm"><spec code="raquo"/><spec code="nbsp"/>подробные комментарии</a></p>
	</xsl:if>
</xsl:template>

<xsl:template match="comment">
	<div class="body_text">
Комментарий:<br/>
<xsl:copy-of select="node()"/>
	</div>
</xsl:template>

<xsl:template match="biblitem">
	<div class="body_text">Литература:<br/>
	<xsl:apply-templates select="author | title | pages | publisher"/>
	</div>
</xsl:template>

<xsl:template match="author | pages | publisher">
	<xsl:copy-of select="node()"/>
	<xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

<xsl:template match="title">
	<i><xsl:copy-of select="node()"/></i>
	<xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

<!-- Match everything else -->
<xsl:template match="*|@*|text()|comment()|processing-instruction()">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|text()|comment()|processing-instruction()"/>
	</xsl:copy>
</xsl:template>


</xsl:stylesheet>