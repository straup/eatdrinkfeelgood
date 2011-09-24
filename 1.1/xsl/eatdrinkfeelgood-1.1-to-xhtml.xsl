<!-- ====================================================================== 
     eatdrinkfeelgood-1.1-to-xhtml.xsl                                                   

     This stylesheet converts a document conforming to the eatdrinkfeelgood
     1.1 DTD into a document conforming to the XHTML 1.1 DTD.

     Version : 1.01
     Date    : $Date: 2002/12/20 04:44:27 $

     Copyright (c) 2002 Aaron Straup Cope
     http://www.eatdrinkfeelgood.info

     Documentation: http://www.eatdrinkfeelgood.info/tools/xsl/edfg-1.1-to-xhtml

     Permission to use, copy, modify and distribute this stylesheet and its 
     accompanying documentation for any purpose and without fee is hereby 
     granted in perpetuity, provided that the above copyright notice and 
     this paragraph appear in all copies.  The copyright holders make no 
     representation about the suitability of the stylesheet for any purpose.

     It is provided "as is" without expressed or implied warranty.

     ====================================================================== 
     Changes
     
     1.01    December 02, 2002

             - Updated namespace uri for eatdrinkfeelgood elements. Gah!

             - Removed namespace-less 'lang' attribute.

     ====================================================================== -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:e="http://www.eatdrinkfeelgood.info/1.1/ns"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:x="http://www.w3.org/XML/1998/namespace"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xml e dc xlink xi"
                version="1.0">

  <xsl:output method = "xml" encoding = "UTF-8" indent = "yes" doctype-public = "-//W3C//DTD XHTML 1.1//EN" doctype-system = "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" />

    <xsl:param name = "css_screen" />
    <xsl:param name = "css_tty" />
    <xsl:param name = "css_tv" />
    <xsl:param name = "css_projection" />
    <xsl:param name = "css_handheld" />
    <xsl:param name = "css_print" />
    <xsl:param name = "css_braille" />
    <xsl:param name = "css_aural" />
    <xsl:param name = "css_all" />
    <xsl:param name = "lang" />

    <xsl:key name = "ings"    match = "e:ing"                     use = "e:item" />
    <xsl:key name = "extrefs" match = "//*[@xlink:href]"          use = "@xlink:href" />

    <!-- These are depecated; the extref key and the name()
         function should be used in their place. -->

    <xsl:key name = "recipes" match = "xi:include"                use = "@href" />
    <xsl:key name = "authors" match = "e:author/e:extref"         use = "@xlink:href" />
    <xsl:key name = "pubs"    match = "e:publication/@xlink:href" use = "@xlink:href" />

<!-- ======================================================================
     Match templates

     /
     ====================================================================== -->

     <xsl:template match="/">
      <html>
       <xsl:attribute name = "x:lang"><xsl:value-of select = "$lang" /></xsl:attribute>

       <head>
        <title><xsl:call-template name = "Title" /></title>

         <xsl:for-each select = "*//xi:include[count(.|key('recipes', @href)[1]) = 1]">
          <link>
           <xsl:attribute name = "rel">recipes</xsl:attribute>
           <xsl:attribute name = "type">application/eatdrinkfeelgood+xml</xsl:attribute>              
           <xsl:attribute name = "href"><xsl:value-of select = "href" /></xsl:attribute>
           <xsl:attribute name = "title"><xsl:value-of select = "xi:fallback/e:extref/@xlink:title" /></xsl:attribute>
          </link>
         </xsl:for-each>

          <xsl:for-each select = "*//e:author/e:extref[count(.|key('authors', @xlink:href)[1]) = 1]">
           <link>
            <xsl:attribute name = "rel">authors</xsl:attribute>
            <xsl:attribute name = "type"><xsl:value-of select = "../@content-type" /></xsl:attribute>
            <xsl:attribute name = "href"><xsl:value-of select = "@xlink:href" /></xsl:attribute>
            <xsl:attribute name = "title"><xsl:value-of select = "@xlink:title" /></xsl:attribute>
           </link>
         </xsl:for-each>

         <xsl:for-each select = "*//e:publication[count(.|key('pubs', @xlink:href)[1]) = 1]">
         <link>
          <xsl:attribute name = "rel">publications</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "@xlink:href" /></xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "e:name/e:common" /></xsl:attribute>
         </link>
        </xsl:for-each>

        <xsl:if test = "$css_all">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_all,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">all</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_all,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

        <xsl:if test = "$css_tty">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_tty,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">tty</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_tty,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

        <xsl:if test = "$css_tv">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_tv,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">tv</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_tv,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

        <xsl:if test = "$css_projection">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_projection,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">projection</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_projection,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

        <xsl:if test = "$css_braille">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_braille,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">braille</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_braille,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

        <xsl:if test = "$css_aural">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_aural,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">aural</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_aural,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

        <xsl:if test = "$css_screen">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_screen,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">screen</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_screen,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

        <xsl:if test = "$css_print">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_print,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">print</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_print,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

        <xsl:if test = "$css_handheld">
         <link>
          <xsl:attribute name = "rel">stylesheet</xsl:attribute>
          <xsl:attribute name = "type">text/css</xsl:attribute>
          <xsl:attribute name = "href"><xsl:value-of select = "substring-before($css_handheld,' ')" /></xsl:attribute>
          <xsl:attribute name = "media">handheld</xsl:attribute>
          <xsl:attribute name = "title"><xsl:value-of select = "substring-after($css_handheld,' ')" /></xsl:attribute>
         </link>
        </xsl:if>

       </head>
       <body>
         
        <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe" />
        <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:menu" />
        <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:revhistory" />
        <xsl:call-template name = "Extrefs" />

        <div>
         <xsl:attribute name = "style">clear:both;</xsl:attribute>
        </div>

       </body>
      </html>
     </xsl:template>

<!-- ======================================================================

     abstract
     ====================================================================== -->

     <xsl:template match = "e:abstract">
      <div>
       <xsl:attribute name = "class">abstract</xsl:attribute>
       <xsl:apply-templates select = "e:para" />
      </div>
     </xsl:template>

<!-- ======================================================================

     amount
     ====================================================================== -->

     <xsl:template match = "e:amount">
      <xsl:apply-templates select = "e:quantity" />&#160;

      <xsl:choose>
       <xsl:when test = "e:measure/e:unit">
        <xsl:value-of select = "e:measure/e:unit/@content" />&#160;
       </xsl:when>        
       <xsl:otherwise>
        <xsl:if test = "string(e:measure/e:customunit)">
         <xsl:value-of select = "e:measure/e:customunit" />&#160;
        </xsl:if>       
       </xsl:otherwise>
      </xsl:choose>
      
      <xsl:apply-templates select = "e:detail" />
     </xsl:template>

<!-- ======================================================================

     author
     ====================================================================== -->

     <xsl:template match = "e:author">
      <xsl:apply-templates select = "e:extref" />
     </xsl:template>

<!-- ======================================================================

     cooking
     ====================================================================== -->

     <xsl:template match = "e:cooking">
      <div>
       <xsl:attribute name = "class">cooking</xsl:attribute>
       <h4>cooking</h4>
       <xsl:apply-templates />
      </div>
     </xsl:template>

<!-- ======================================================================

     course
     ====================================================================== -->

     <xsl:template match = "e:course">
      <div>
       <xsl:attribute name = "class">course</xsl:attribute>

       <h2><xsl:apply-templates select = "e:name" /></h2>
       <xsl:apply-templates select = "e:abstract" />

       <div style = "font-size:.8em;">
        <xsl:for-each select = "./*">
         <xsl:choose>
          <xsl:when test = "name()='recipe'">
           <xsl:apply-templates select = "." />
          </xsl:when>        
          <xsl:when test = "name()='xi:include'">
           <h1><xsl:apply-templates select = "." /></h1>
          </xsl:when>        
          <xsl:otherwise />    
          </xsl:choose>

        </xsl:for-each>
       </div>

       <xsl:apply-templates select = "e:notes" />
     </div>
     </xsl:template>

<!-- ======================================================================

     date
     ====================================================================== -->

     <xsl:template match = "dc:date">
      <xsl:value-of select = "." />
     </xsl:template>

<!-- ======================================================================

     days
     ====================================================================== -->

     <xsl:template match = "e:days">
      <xsl:value-of select = "e:n/@value" /> days
     </xsl:template>

<!-- ======================================================================

     detail
     ====================================================================== -->

     <xsl:template match = "e:detail">
      <em><xsl:value-of select = "." /></em>
     </xsl:template>

<!-- ======================================================================

     directions
     ====================================================================== -->

     <xsl:template match = "e:directions">
      <div>
       <xsl:attribute name = "class">directions</xsl:attribute>
       <h2>Directions</h2>

       <xsl:choose>
        <xsl:when test = "name(./*[position()=1]) = 'step'">
         <xsl:call-template name = "Steps" />
        </xsl:when>
        <xsl:otherwise>
         <xsl:apply-templates select = "e:stage" />
        </xsl:otherwise>
       </xsl:choose>
      </div>
     </xsl:template>

<!-- ======================================================================

     equipment
     ====================================================================== -->

     <xsl:template match = "e:equipment">
      <div>
       <xsl:attribute name = "class">equipment</xsl:attribute>
       <h3>Equipment</h3>
       <ul>
        <xsl:for-each select = "e:device">
         <li><xsl:apply-templates /></li>      
        </xsl:for-each>
       </ul>
      </div>        
     </xsl:template>

<!-- ======================================================================

     extref
     ====================================================================== -->

     <xsl:template match = "e:extref">
      <a>
       <xsl:attribute name = "href">
        <xsl:value-of select = "@xlink:href" />
       </xsl:attribute>
       <xsl:value-of select = "@xlink:title" />
      </a>
      <span>
       <xsl:attribute name = "class">footnote</xsl:attribute>
       <xsl:call-template name = "ExtrefPos" />
      </span>
     </xsl:template>

<!-- ======================================================================

     history
     ====================================================================== -->

     <xsl:template match = "e:history">
      <div>
       <xsl:attribute name = "class">history</xsl:attribute>
       <h2>History</h2>
       <xsl:apply-templates select = "e:para" />
       <xsl:apply-templates select = "e:image" />
       <xsl:call-template name = "Authored" />
      </div>
     </xsl:template>

<!-- ======================================================================

     hours
     ====================================================================== -->

     <xsl:template match = "e:hours">
      <xsl:value-of select = "e:n/@value" /> hours
     </xsl:template>

<!-- ======================================================================

     image
     ====================================================================== -->

     <xsl:template match = "e:image">
      <xsl:choose>

       <xsl:when test = "e:extref">
        <a>
         <xsl:attribute name = "href"><xsl:value-of select = "e:extref/@xlink:href" /></xsl:attribute>        
         <img>
          <xsl:attribute name = "src"><xsl:value-of select = "e:extref/@xlink:href" /></xsl:attribute>
          <xsl:attribute name = "alt"><xsl:value-of select = "e:extref/@alt" /></xsl:attribute>
         </img>
        </a>
        <span>
         <xsl:attribute name = "class">footnote</xsl:attribute>
         <xsl:call-template name = "ExtrefPos" />
        </span>
       </xsl:when>    

       <xsl:otherwise>
        <img>
         <xsl:attribute name = "src"><xsl:value-of select = "e:bin64b" /></xsl:attribute>
         <xsl:attribute name = "alt"><xsl:value-of select = "e:title" /></xsl:attribute>
        </img>
       </xsl:otherwise>

      </xsl:choose>
     </xsl:template>

<!-- ======================================================================

     ingredients
     ====================================================================== -->

     <xsl:template match = "e:ingredients">
      <div>
       <xsl:attribute name = "class">ingredients</xsl:attribute>
       <h3>Ingredients</h3>

       <xsl:choose>
        <xsl:when test = "name(./*[position()=1]) = 'ing'">
         <xsl:call-template name = "IngList" />
        </xsl:when>
        <xsl:otherwise>
         <xsl:apply-templates select = "e:set" />
        </xsl:otherwise>
       </xsl:choose>

       <div>
        <xsl:attribute name = "class">ingredients-summary</xsl:attribute>

        <!-- this is returning the count of all the ing element 
             rather than a count of unique ing/item; to be fixed -->

        <xsl:variable name = "num-ings" select = "count(ancestor-or-self::*//e:ing)" />

        <h4>Summary</h4>

        <xsl:for-each select = "ancestor-or-self::*//e:ing[count(.|key('ings', e:item)[1]) = 1]">
         <xsl:sort select="e:item" data-type="text" order="ascending"/>
         <xsl:value-of select = "e:item" /> 
         <xsl:if test = "position() &lt; $num-ings">, </xsl:if>
        </xsl:for-each>
       </div>

      </div>  
     </xsl:template>

<!-- ======================================================================

     item
     ====================================================================== -->

     <xsl:template match = "item">
      <span>
       <xsl:attribute name = "class">item</xsl:attribute>
       <xsl:value-of select = "item" />
      </span>
     </xsl:template>

<!-- ======================================================================

     menu
     ====================================================================== -->

     <xsl:template match = "e:menu">
      <div>
       <xsl:attribute name = "class">menu</xsl:attribute>

       <h1><xsl:apply-templates select = "e:name" /></h1>

       <xsl:apply-templates select = "e:abstract" />
       <xsl:apply-templates select = "e:course" />
     </div>
     </xsl:template>

<!-- ======================================================================

     min
     ====================================================================== -->

     <xsl:template match = "e:min">
      <xsl:apply-templates select = "e:n" />
     </xsl:template>

<!-- ======================================================================

     minutes
     ====================================================================== -->

     <xsl:template match = "e:minutes">
      <xsl:value-of select = "e:n/@value" /> minutes
     </xsl:template>

<!-- ======================================================================

     max
     ====================================================================== -->

     <xsl:template match = "e:max">
      <xsl:apply-templates select = "e:n" />
     </xsl:template>

<!-- ====================================================================== 

     n
     ====================================================================== -->

     <xsl:template match = "e:n">
      <span>
       <xsl:attribute name = "class">number</xsl:attribute>
       <xsl:value-of select = "@value" />
      </span>
     </xsl:template>

<!-- ======================================================================

     name
     ====================================================================== -->

     <xsl:template match = "e:name">
      <xsl:value-of select = "e:common" />
      <span>
       <xsl:attribute name = "class">other-names</xsl:attribute>
       <xsl:value-of select = "e:other" />
      </span>
     </xsl:template>

<!-- ======================================================================

     note
     ====================================================================== -->

     <xsl:template match = "e:note">
      <div>
       <xsl:attribute name = "class">note</xsl:attribute>
       <xsl:apply-templates select = "e:para" />
       <xsl:apply-templates select = "e:image" />
       <xsl:call-template name = "Authored" />
      </div>  
     </xsl:template>

<!-- ======================================================================

     notes
     ====================================================================== -->

     <xsl:template match = "e:notes">
      <div>
       <xsl:attribute name = "class">notes</xsl:attribute>
       <h2>Notes</h2>
       <xsl:apply-templates select = "e:note" />
      </div>  
     </xsl:template>

<!-- ======================================================================

     other
     ====================================================================== -->

     <xsl:template match = "e:other">
      <em><xsl:value-of select = "." /></em>
     </xsl:template>

<!-- ======================================================================

     para
     ====================================================================== -->

     <xsl:template match = "e:para">
      <p><xsl:value-of select = "." /></p>
     </xsl:template>

<!-- ======================================================================

     publication
     ====================================================================== -->

     <xsl:template match = "e:publication">
      <div>
       <xsl:attribute name = "class">publication</xsl:attribute>

       <xsl:choose>
        <xsl:when test = "string(@xlink:href)">
         <a>
          <xsl:attribute name = "href">
           <xsl:value-of select = "@xlink:href" />
          </xsl:attribute>
          <xsl:value-of select = "e:name" />
         </a>
         <span>
          <xsl:attribute name = "class">footnote</xsl:attribute>
          <xsl:call-template name = "ExtrefPos" />
         </span>
        </xsl:when>           
        <xsl:otherwise>
         <xsl:value-of select = "e:name" />         
        </xsl:otherwise>
       </xsl:choose>
      </div>
     </xsl:template>

<!-- ======================================================================

     preparation
     ====================================================================== -->

     <xsl:template match = "e:preparation">
      <div>
       <xsl:attribute name = "class">preparation</xsl:attribute>
       <h4>preparation</h4> 
       <xsl:apply-templates />
      </div>
     </xsl:template>

<!-- ======================================================================

     quantity
     ====================================================================== -->

     <xsl:template match = "e:quantity">
      <xsl:choose>
       <xsl:when test = "e:range">
        <xsl:apply-templates select = "e:range" />
       </xsl:when>
       <xsl:otherwise>
        <xsl:apply-templates select = "e:n" />
       </xsl:otherwise>
      </xsl:choose>
     </xsl:template>

<!-- ======================================================================

     range
     ====================================================================== -->

     <xsl:template match = "e:range">
      <xsl:apply-templates select = "e:min" />-<xsl:apply-templates select = "e:max" />
     </xsl:template>

<!-- ====================================================================== 

     recipe                                                      
     ====================================================================== -->

     <xsl:template match = "e:recipe">
      <div>
       <xsl:attribute name = "class">recipe</xsl:attribute>

       <h1><xsl:apply-templates select = "e:name" /></h1>

       <div>
        <xsl:attribute name = "class">wrapper-meta</xsl:attribute>
        <xsl:apply-templates select = "e:source" />
       </div>

       <div>
        <xsl:attribute name = "class">wrapper-requirements</xsl:attribute>
        <xsl:apply-templates select = "e:requirements" />
       </div>

       <div>
        <xsl:attribute name = "class">wrapper-directions</xsl:attribute>
        <xsl:apply-templates select = "e:directions" />
        <xsl:apply-templates select = "e:yield" />
       </div>

       <div>
        <xsl:attribute name = "class">wrapper-notes</xsl:attribute>
        <xsl:apply-templates select = "e:notes" />
        <xsl:apply-templates select = "e:history" />
        </div>

      </div>
     </xsl:template>

<!-- ====================================================================== 

     requirements
     ====================================================================== -->

     <xsl:template match = "e:requirements">
      <div>
       <xsl:attribute name = "class">requirements</xsl:attribute>
       <h2>Requirements</h2>
       <xsl:apply-templates select = "e:time" />
       <xsl:apply-templates select = "e:ingredients" />
       <xsl:apply-templates select = "e:equipment" />
      </div>
     </xsl:template>

<!-- ====================================================================== 

     rev                                                     
     ====================================================================== -->

     <xsl:template match = "e:rev">
      <h3><xsl:value-of select = "e:version" /></h3>
      <xsl:apply-templates select = "e:changes" />
      <xsl:call-template name = "Authored" />
     </xsl:template>

<!-- ====================================================================== 

     revhistory
     ====================================================================== -->

     <xsl:template match = "e:revhistory">
      <div>
       <xsl:attribute name = "class">revhistory</xsl:attribute>
       <h2>Revision History</h2>
       <ul>
        <xsl:for-each select = "e:rev">
          <li><xsl:apply-templates select = "." /></li>
        </xsl:for-each>
       </ul>
      </div>
     </xsl:template>

<!-- ====================================================================== 

     set
     ====================================================================== -->

     <xsl:template match = "e:set">
      <div>  
       <xsl:attribute name = "class">ingset</xsl:attribute>
       <h4><xsl:apply-templates select = "e:name" /></h4>
       <xsl:choose>
        <xsl:when test = "xi:include">
         <ul>
         <xsl:for-each select = "xi:include">
          <li><xsl:apply-templates select = "." /></li>
         </xsl:for-each>
         </ul>
        </xsl:when>
        <xsl:otherwise>
         <xsl:call-template name = "IngList" />           
        </xsl:otherwise>
       </xsl:choose>
      </div>
     </xsl:template>

<!-- ====================================================================== 

     source
     ====================================================================== -->

     <xsl:template match = "e:source">
      <div>
       <xsl:attribute name = "class">source</xsl:attribute>
       <h2>Source</h2>
       <xsl:apply-templates select = "e:publication" />
       <xsl:apply-templates select = "e:author" />
      </div>
     </xsl:template>

<!-- ====================================================================== 

     stage
     ====================================================================== -->

     <xsl:template match = "e:stage">
      <div>  
       <xsl:attribute name = "class">stage</xsl:attribute>
       <h4><xsl:apply-templates select = "e:name" /></h4>
       <xsl:choose>
        <xsl:when test = "xi:include">
         <ol>
         <xsl:for-each select = "xi:include">
          <li><xsl:apply-templates select = "." /></li>
         </xsl:for-each>
         </ol>
        </xsl:when>
        <xsl:otherwise>
         <xsl:call-template name = "Steps" />
        </xsl:otherwise>
       </xsl:choose>
      </div>
     </xsl:template>

<!-- ====================================================================== 

     time
     ====================================================================== -->

     <xsl:template match = "e:time">
      <div>
       <xsl:attribute name = "class">time</xsl:attribute>
       <h3>Time</h3>
        <xsl:apply-templates select = "e:preparation" />
        <xsl:apply-templates select = "e:cooking" />
      </div>       
     </xsl:template>

<!-- ====================================================================== 

     xi:include
     ====================================================================== -->

     <xsl:template match = "xi:include">
      <xsl:apply-templates />
     </xsl:template>

<!-- ====================================================================== 

     yield
     ====================================================================== -->

     <xsl:template match = "e:yield">
      <div>
       <xsl:attribute name = "class">yield</xsl:attribute>
       <h2>Yield</h2>
       <xsl:for-each select = "e:amount">
        <div>
         <xsl:attribute name = "class">amount</xsl:attribute>         
         <xsl:apply-templates />
        </div>
       </xsl:for-each>
      </div>
     </xsl:template>

<!-- ====================================================================== 

     Authored
     ====================================================================== -->

     <xsl:template name = "Authored">
      <div>
       <xsl:attribute name = "class">meta</xsl:attribute>
       <span>
        <xsl:attribute name = "class">author</xsl:attribute>
        <xsl:apply-templates select = "e:author" />
       </span>

       <span>
        <xsl:attribute name = "class">date</xsl:attribute>
        <xsl:apply-templates select = "dc:date" />
       </span>
      </div>             
     </xsl:template>

<!-- ====================================================================== 

     ExtrefPos

     This has got to be a viciously inefficient way of doing this.
     If anyone has some more elegant XSLT kung-fu they'd like to 
     share I'd be grateful...
     ====================================================================== -->

     <xsl:template name = "ExtrefPos">
      <xsl:variable name = "href" select = "@xlink:href" />
      <xsl:for-each select = "//*[@xlink:href][count(.|key('extrefs', @xlink:href)[1]) = 1]">
       <xsl:if test = "$href = @xlink:href">
        <sup> [ <xsl:value-of select = "position()" /> ]</sup>
       </xsl:if>
      </xsl:for-each>
     </xsl:template>

<!-- ====================================================================== 

     Extrefs
     ====================================================================== -->

     <xsl:template name = "Extrefs">
      <div>
      <xsl:attribute name = "class">extrefs</xsl:attribute>
       <h2>External Links</h2>
       <ol>
       <xsl:for-each select = "//*[@xlink:href][count(.|key('extrefs', @xlink:href)[1]) = 1]">
        <li><xsl:value-of select = "@xlink:href" /></li>
       </xsl:for-each>
       </ol>
      </div>
     </xsl:template>

<!-- ====================================================================== 

     IngList
     ====================================================================== -->

     <xsl:template name = "IngList">
      <ul>
       <xsl:for-each select = "e:ing">
        <li><xsl:apply-templates /></li>
       </xsl:for-each>
      </ul>
     </xsl:template>

<!-- ====================================================================== 

     Steps
     ====================================================================== -->

     <xsl:template name = "Steps">
      <ol>
       <xsl:for-each select = "e:step">
        <li><xsl:apply-templates select = "." /></li>      
       </xsl:for-each>
      </ol>       
     </xsl:template>

<!-- ====================================================================== 

     Title                                                        
     ====================================================================== -->

     <xsl:template name = "Title">  
      <xsl:choose>
       <xsl:when test = "/e:eatdrinkfeelgood/e:menu">
        <xsl:value-of select = "/e:eatdrinkfeelgood/e:menu/e:name/e:common" />           
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select = "/e:eatdrinkfeelgood/e:recipe/e:name/e:common" />
       </xsl:otherwise>
      </xsl:choose>
     </xsl:template>

<!-- ======================================================================
     FIN
     ====================================================================== -->

</xsl:stylesheet>
