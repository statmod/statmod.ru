<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:pr="http://statmod.ru/staff"
      exclude-result-prefixes="msxsl pr">

<xsl:param name="glob_param"/>
<xsl:include href="../_courses/resolve_prof.xsl"/>
<xsl:param name="path_xml"/>
<xsl:variable name="profs" select="document('../_staff/prof.xml')"/>

<xsl:variable name="specs">
	<specs>
		<spec id="sa">
			<name>САПР</name>
		</spec>
		<spec id="sm">
			<name>СМ</name>
		</spec>
		<spec id="mm">
			<name>ММ</name>
		</spec>
		<spec id="bs">
			<name>Био. Стат.</name>
		</spec>
	</specs>
</xsl:variable>


<xsl:template match="/diploma">
   <html>
	<head>
		<title>Защита дипломных работ <xsl:value-of select="@year"/></title>
</head>
      <body>
		<h2>Слайды с защит <xsl:value-of select="@year"/></h2>

<table width="100%" border="1" cellspacing="0" class="spectable">
	<tr>
		<th>
  			<spec code="nbsp" /> 
  		</th>
		<th>Сп.</th>
		<th>Тема</th>
		<th><spec code="nbsp"/></th>
		<th>Научный руководитель</th>
		<th>Рецензент</th>
	</tr>
	<xsl:apply-templates select="person"/>
</table>
      </body>
   </html>
</xsl:template>


<xsl:template match="person">
	<tr>
<td>
<xsl:value-of select="ln"/><br/>
<xsl:value-of select="fn"/><br/>
<xsl:value-of select="mn"/>
</td>
<td><xsl:value-of select="msxsl:node-set($specs)/specs/spec[@id=current()/@spec]/name/node()"/></td>
<td><xsl:value-of select="name"/></td><td><a target="_blank" href="{$path_xml}{slides/text()}"><img src="/_img/pdf.png" border="0" align="right"/></a></td>
<td><xsl:apply-templates select="advisor" mode="prof"/></td>
<td><xsl:apply-templates select="reviewer" mode="prof"/></td>
	</tr>
</xsl:template>


<xsl:template match="advisor|reviewer" mode="prof">
	<xsl:variable name="prof" select="$profs//pr:person[@id = current()/@id]"/>
	<xsl:choose>
		<xsl:when test="boolean(@id)">
<a href="/chair/prof/{@id}.htm"><xsl:apply-templates select="$prof" mode="short_name"/></a>
		</xsl:when>
		<xsl:otherwise>
<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
  

  