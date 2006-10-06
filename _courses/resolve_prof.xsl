<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="person" mode="short_name">
<xsl:value-of select="ln/text()"/>&#32;<xsl:value-of select="substring(fn/text(),1,1)"/>.<xsl:value-of select="substring(mn/text(),1,1)"/>.
</xsl:template>
</xsl:stylesheet>

