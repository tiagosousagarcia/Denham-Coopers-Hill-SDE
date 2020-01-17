<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xhtml"/>

    <xsl:template match="/">
        <html>
            <style type="text/css">
                p.sideNote {
                    float: right;
                }
                
                .content {
                    max-width: 500px;
                    margin: auto;
                }
                h1,
                h2,
                h3, p.imprint {
                    text-align: center;
                }
                
                p, div.poem{
                line-height: 2em;
                }
            
            </style>
            <body>
                <div class="content">
                    <xsl:apply-templates/>
                    <ol>
                        <xsl:apply-templates select="//note[@type = 'gloss']" mode="footnotes"/>
                    </ol>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Add your templates here! -->

    <xsl:template match="teiHeader"/>

    <xsl:template match="//titleStmt/title">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>


    <xsl:template match="body/div">
        <div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="//body/div[@type='poem']">
        <div class="poem">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="//front/div/head[@type = 'title']">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>

    <xsl:template match="//front/div/head[@type = 'subtitle']">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <xsl:template match="//front/div/head[@type = 'addInformation']">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="//front/div[@type = 'Author']/p">
        <h2>
            <strong><xsl:apply-templates/></strong>
        </h2>
    </xsl:template>

    <xsl:template match="//front/div[@type = 'imprint']/p">
        <p class="imprint">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="body/div/head">
        <p>
            <em>
                <strong>
                    <xsl:apply-templates/>
                </strong>
            </em>
        </p>
    </xsl:template>

    <xsl:template match="l">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="lb">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="//note[@type = 'side-note']">
        <p class="sideNote">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//note[@type = 'gloss']">
        <xsl:variable name="num">
            <xsl:number count="note" from="body" level="any"/>
        </xsl:variable>
        <a href="{concat('#note', $num)}">
            <sup>
                <xsl:value-of select="$num"/>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="//note[@type = 'gloss']" mode="footnotes">
        <xsl:variable name="num">
            <xsl:number count="note" from="body" level="any"/>
        </xsl:variable>
        <li id="{concat('note', $num)}">
            <xsl:apply-templates/>
        </li>
    </xsl:template>







</xsl:stylesheet>
