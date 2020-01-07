<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    >
    
    <xsl:output method="xhtml"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <xsl:apply-templates/>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    
    <!-- Add your templates here! -->
    
    <xsl:template match="teiHeader | front"/>
    
    <xsl:template match="//titleStmt/title">
        <title><xsl:apply-templates/></title>
    </xsl:template>
    
    
    <xsl:template match="body/div">
        <div><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="body/div/head">
        <h1><xsl:apply-templates/></h1>
    </xsl:template>
    
    <xsl:template match="body/div/div/head">
        <h2><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="l">
        <xsl:apply-templates/> <br/>
    </xsl:template>
    
    
    
    
    
    
    
</xsl:stylesheet>