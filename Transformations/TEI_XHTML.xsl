<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="xhtml"/>
    <!-- Main Template -->
    <xsl:template match="/">
        <html>
            <!-- CSS included inline so that the edition can be reduced to one file (and thus avoid hosting elsewhere) -->
            <style type="text/css">
                <!-- Styles side notes in the original edition -->
                span.sideNote {
                    margin-left: 3em;
                    font-size: 0.8em;
                    font-style: italic;
                }<!-- Styles dropCaps in the original edition -->
                span.dropCap {
                    margin-left: -0.5em;
                    font-size: 5em;
                    font-weight: bold;
                    vertical-align: -webkit-baseline-middle;
                }<!-- Styles any undefined hilights in italic -->
                span.italic {
                    font-style: italic;
                }<!-- Styles information about page breaks -->
                span.pageBreak {
                    font-size: 0.8em;
                    color: grey;
                    float: right;
                }<!-- Styles the colophon of the digital edition -->
                span.colophon {
                    font-size: 0.8em;
                    color: SlateGrey;
                    line-height: 1.5em;
                }<!-- Styles the back buttons in the footnotes -->
                p.back {
                    font-size: 0.8em;
                    text-align: right;
                    line-height: 0.5em;
                }<!-- Styles main content, to allow for centred text in large displays -->
                .content {
                    max-width: 600px;
                    margin: auto;
                    font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
                }<!-- Centers titles, headers, and other paratextual information from the original edition -->
                h1,
                h2,
                h3,
                p.imprint {
                    text-align: center;
                    font-variant: historical-ligatures oldstyle-nums;
                }<!-- Sets relative font sizes for title page elements -->
                h1 {
                    font-size: 3.5em;
                }
                h2 {
                    font-size: 2.5em;
                }
                h3 {
                    font-size: 1.5em;
                }
                p.imprint {
                    font-size: 1.1em;
                }<!-- Defines line spacing for every paragraph -->
                p,
               {
                    line-height: 2em;
                }
                
                <!-- Styles and positions line numbers for lines less than 10 (i.e., with one digit) -->
                span.lineNumber1 {
                    font-size: 0.8em;
                    color: grey;
                    margin-right: -0.5em;
                }<!-- Styles and positions line numbers for lines more than 10 and less than 100 (i.e., with two digits) -->
                span.lineNumber10 {
                    font-size: 0.8em;
                    color: grey;
                    margin-right: -1em;
                }<!-- Styles and positions line numbers for lines more than 100 (i.e., with three digits) -->
                span.lineNumber100 {
                    font-size: 0.8em;
                    color: grey;
                    margin-right: -1.5em;
                }<!-- Styles and positions regular verse lines -->
                span.verseLine {
                    padding-left: 3em;
                    line-height: 2em;
                }</style>
            <head>
                <!-- Adds metadata to page from teiHeader (head mode) -->
                <xsl:apply-templates select="//titleStmt/title" mode="head"/>
            </head>
            <body>
                <div class="content">
                    <!-- main content goes here -->
                    <xsl:apply-templates/>
                    <hr/>
                    <ol>
                        <!-- Footnotes go here (in footnotes mode) -->
                        <xsl:apply-templates select="//note[@type = 'gloss']" mode="footnotes"/>
                    </ol>
                    <br/>
                    <hr/>
                    <!-- Colophon goes here (in colophon mode) -->
                    <xsl:apply-templates select="//back/div[@type = 'colophon']" mode="colophon"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Other Templates -->


    <!-- Ignores teiHeader and back in default mode -->
    <xsl:template match="teiHeader | back"/>

    <!-- Gets title for the page in head mode -->
    <xsl:template match="//titleStmt/title" mode="head">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>


    <!-- Creates HTML divs based on TEI divs -->
    <xsl:template match="body/div">
        <div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Creates div from class poem based on TEI poem div -->
    <xsl:template match="//body/div[@type = 'poem']">
        <div class="poem">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Creates h1 based on title from front matter -->
    <xsl:template match="//front/div/head[@type = 'title']">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>

    <!-- Creates h2 based on title from front matter -->
    <xsl:template match="//front/div/head[@type = 'subtitle']">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <!-- Creates h3 based on other info in front matter (i.e., publishers colophon) -->
    <xsl:template match="//front/div/head[@type = 'addInformation']">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <!-- Adds author of original poem as h2 -->
    <xsl:template match="//front/div[@type = 'Author']/p">
        <h2>
            <strong>
                <xsl:apply-templates/>
            </strong>
        </h2>
    </xsl:template>

    <!-- Adds imprint information from front matter -->
    <xsl:template match="//front/div[@type = 'imprint']/p">
        <p class="imprint">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- Adds title from body of text (styling should probably all be in css, but too lazy to change that now)-->
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

    <!-- Creates lines from TEI l elements -->
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

    <!-- Creates breaks based on lb elements -->
    <xsl:template match="lb">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>

    <!-- Creates spans for side notes in the original poem -->
    <xsl:template match="//note[@type = 'side-note']">
        <span class="sideNote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Turns gloss notes into footnotes, creating a link to the bottom of the page -->
    <xsl:template match="//note[@type = 'gloss']">
        <xsl:variable name="num">
            <xsl:number count="note[@type = 'gloss']" from="body" level="any"/>
        </xsl:variable>
        <a href="{concat('#note', $num)}" alt="{concat('Link to note ', $num)}">
            <sup>
                <xsl:value-of select="$num"/>
            </sup>
        </a>
    </xsl:template>

    <!-- Creates an ordered list of footnotes at the end of the document, in footnotes mode -->
    <xsl:template match="//note[@type = 'gloss']" mode="footnotes">
        <xsl:variable name="num">
            <xsl:number count="note[@type = 'gloss']" from="body" level="any"/>
        </xsl:variable>
        <!-- Creates back buttons from footnotes to main text -->
        <li id="{concat('note', $num)}">
            <xsl:apply-templates/>
        </li>
        <p class="back">
            <a href="javascript:history.back()">Back</a>
        </p>
    </xsl:template>

    <!-- Creates a span for dropped cap -->
    <xsl:template match="//hi[@rend = 'initial']">
        <span class="dropCap">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Applies a span to any generic italic highlight  -->
    <xsl:template match="//hi[@rend = 'italic'] | title">
        <span class="italic">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Turns ref elements into links, using the target attribute value -->
    <xsl:template match="//ref">
        <xsl:variable name="link">
            <xsl:value-of select="@target"/>
        </xsl:variable>
        <!--
        This would select an appropriate alt text for the link, depending on he parent
        However, accessibility norms say you don't need alt text if the link is already text 
        Commented out, kept here only for reference.
        
        <xsl:variable name="parent">
            <xsl:value-of select="name(..)"/>
        </xsl:variable>
        <xsl:variable name="altText">
            <xsl:choose>
                <xsl:when test="$parent = 'note'">
                    <xsl:text>This links to additional information about this note</xsl:text>
                </xsl:when>
                <xsl:when test="$parent = 'p'">
                    <xsl:text>This links to addional information.</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>null</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        -->
        <a href="{$link}"> <!--alt="{$altText}"-->
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <!-- Prints page break information using the xml:id value and turns them into links using the facs attribute value -->
    <xsl:template match="//pb">
        <xsl:variable name="link">
            <xsl:value-of select="@facs"/>
        </xsl:variable>
        <span class="pageBreak">
            <a href="{$link}">[<xsl:value-of select="@xml:id"/><xsl:apply-templates/>]</a>
        </span>
        <br/>
    </xsl:template>

    <!-- Prints the colophon in colophon mode and adds update information, formatting it as text-->
    <xsl:template match="//back/div[@type = 'colophon']" mode="colophon">
        <span class="colophon"><xsl:apply-templates/><br/><br/>Laste update: <xsl:value-of
                select="
                    format-date(current-date(),
                    '[FNn], [D1o] [MNn] [Y]')"
            /></span>
    </xsl:template>

    <!-- Copies the 'Finis' into an h3 -->
    <xsl:template match="//div[@type = 'end']">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

</xsl:stylesheet>
