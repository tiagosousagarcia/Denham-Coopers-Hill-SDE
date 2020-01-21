<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xhtml"/>

    <xsl:template match="/">
        <html>
            <style type="text/css">
                span.sideNote {
                    margin-left: 3em;
                    font-size: 0.8em;
                    font-style: italic;
                }
                
                span.dropCap{
                margin-left: -0.5em;
                font-size: 5em;
                font-weight: bold;
                vertical-align: -webkit-baseline-middle;}
                
                span.italic { font-style: italic;}
                
                span.pageBreak {
                font-size: 0.8em;
                color: grey;
                float:right;}
                
                span.colophon {
                font-size: 0.8em;
                color: SlateGrey;
                line-height: 1.5em;
                }
                
                p.back{
                font-size: 0.8em;
                text-align: right;
                line-height: 0.5em;
                }
                
                .content {
                    max-width: 600px;
                    margin: auto;
                }
                h1,
                h2,
                h3,
                p.imprint {
                    text-align: center;
                }
                
                p,
               {
                    line-height: 2em;
                }
                
                span.lineNumber1 {
                    font-size: 0.8em;
                    color: grey;
                    margin-right: -0.5em;
                }
                span.lineNumber10 {
                font-size: 0.8em;
                color: grey;
                margin-right: -1em;
                }
                span.lineNumber100 {
                font-size: 0.8em;
                color: grey;
                margin-right: -1.5em;
                }
                span.verseLine {
                    padding-left: 3em;
                    line-height: 2em;
                }
            </style>
            <head>
                <xsl:apply-templates select="//titleStmt/title" mode="head"/>
            </head>
            <body>
                <div class="content">
                    <xsl:apply-templates/>
                    <hr/>
                    <ol>
                        <xsl:apply-templates select="//note[@type = 'gloss']" mode="footnotes"/>
                    </ol>
                    <br/>
                    <hr/>
                    <xsl:apply-templates select="//back/div[@type='colophon']" mode="colophon"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Add your templates here! -->

    <xsl:template match="teiHeader | back"/>

    <xsl:template match="//titleStmt/title" mode="head">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>


    <xsl:template match="body/div">
        <div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="//body/div[@type = 'poem']">
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
            <strong>
                <xsl:apply-templates/>
            </strong>
        </h2>
    </xsl:template>

    <xsl:template match="//front/div[@type = 'imprint']/p">
        <p class="imprint">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="body/div/head">
        <hr/>
        <p>
            <em>
                <strong>
                    <xsl:apply-templates/>
                </strong>
            </em>
        </p>
    </xsl:template>

    <xsl:template match="l">
        <!-- Tests whether the line is a multiple of 5, if so, adds line number and styles it, depending on the number of characters (1, 10, 100) -->
        <xsl:variable name="lineN">
            <xsl:number/>
        </xsl:variable>
        <xsl:if test="$lineN mod 5 = 0">
            <xsl:choose>
                <xsl:when test="$lineN &gt; 99">
                    <span class="lineNumber100">
                        <xsl:value-of select="$lineN"/>
                    </span>
                </xsl:when>
                <xsl:when test="$lineN &gt; 9">
                    <span class="lineNumber10">
                        <xsl:value-of select="$lineN"/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="lineNumber1">
                        <xsl:value-of select="$lineN"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- Always applies span class verse line and break -->
        <span class="verseLine">
            <xsl:apply-templates/>
        </span>
        <br/>
    </xsl:template>

    <xsl:template match="lb">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <xsl:template match="//note[@type = 'side-note']">
        <span class="sideNote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="//note[@type = 'gloss']">
        <xsl:variable name="num">
            <xsl:number count="note[@type = 'gloss']" from="body" level="any"/>
        </xsl:variable>
        <a href="{concat('#note', $num)}">
            <sup>
                <xsl:value-of select="$num"/>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="//note[@type = 'gloss']" mode="footnotes">
        <xsl:variable name="num">
            <xsl:number count="note[@type = 'gloss']" from="body" level="any"/>
        </xsl:variable>
        <li id="{concat('note', $num)}" onclick="javascript:history.back()">
            <xsl:apply-templates/>
        </li>
        <p class="back">
            <a href="javascript:history.back()">Back</a>
        </p>
    </xsl:template>

    <xsl:template match="//hi[@rend = 'initial']">
        <span class="dropCap">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="//hi[@rend = 'italic'] | title">
        <span class="italic">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="//ref">
        <xsl:variable name="link">
            <xsl:value-of select="@target"/>
        </xsl:variable>
        <a href="{$link}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="//pb">
        <xsl:variable name="link">
            <xsl:value-of select="@facs"/>
        </xsl:variable>
        <span class="pageBreak"><a href="{$link}">[<xsl:value-of select="@xml:id"/><xsl:apply-templates/>]</a></span>
        <br/>
    </xsl:template>
    
    <xsl:template match="//back/div[@type='colophon']" mode="colophon">
        <span class="colophon"><xsl:apply-templates/><br/><br/>Laste update: <xsl:value-of select="format-date(current-date(), 
            '[FNn], the [D1o] of [MNn], [Y]')"/></span>
    </xsl:template>








</xsl:stylesheet>
