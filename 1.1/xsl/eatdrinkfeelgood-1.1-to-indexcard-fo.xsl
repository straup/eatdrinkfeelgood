<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:e="http://www.eatdrinkfeelgood.org/1.1/ns"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                version="1.0">

<!-- ====================================================================== 
     eatdrinkfeelgood-1.1-to-indexcard-fo.xsl                                                   

     This stylesheet converts a recipe document conforming to the 
     eatdrinkfeelgood 1.1 DTD into an XSL-FO document suitable for generating 
     an index card.

     Version : 1.1
     Date    : $Date: 2006/04/05 02:43:41 $

     Copyright (c) 2002-2006 Aaron Straup Cope
     http://www.eatdrinkfeelgood.org

     Documentation: http://www.eatdrinkfeelgood.org/tools/xsl/edfg-1.1-to-indexcard-fo

     Permission to use, copy, modify and distribute this stylesheet and its 
     accompanying documentation for any purpose and without fee is hereby 
     granted in perpetuity, provided that the above copyright notice and 
     this paragraph appear in all copies.  The copyright holders make no 
     representation about the suitability of the stylesheet for any purpose.

     It is provided "as is" without expressed or implied warranty.
     ====================================================================== -->

     <xsl:output method="xml" encoding = "UTF-8" indent = "yes" />

<!-- ====================================================================== 

     Pull in shared stylesheets - requires
     
     * eatdrinkfeelgood-1.1-shared.xsl version 1.0
     ====================================================================== -->

     <xsl:include href = "eatdrinkfeelgood-1.1-shared.xsl" />

<!-- ====================================================================== 

     Parameters
     ====================================================================== -->

     <xsl:param name = "size">large</xsl:param>
     <xsl:param name = "font-size">8pt</xsl:param>
     <xsl:param name = "hide-images" />
     <xsl:param name = "hide-images-src" />
     <xsl:param name = "image-height" />

<!-- ====================================================================== 

     Variables
     ====================================================================== -->

     <xsl:variable name = "num_xincludes" select = "count(*//xi:include)" />

<!-- ====================================================================== 

     Root
     ====================================================================== -->

     <xsl:template match="/">
         <fo:root>
             <fo:layout-master-set>
                 
                 <fo:simple-page-master>
                     <xsl:call-template name = "Attrs-Simple-Page-Master-shared" />
                     <xsl:attribute name = "master-name">default-odd</xsl:attribute>
                     
                     <xsl:call-template name = "Region-Body-default" />
                     <xsl:call-template name = "Region-After-default" />
                 </fo:simple-page-master>
                 
                 <fo:simple-page-master>
                     <xsl:call-template name = "Attrs-Simple-Page-Master-shared" />
                     <xsl:attribute name = "master-name">default-even</xsl:attribute>
                     <xsl:attribute name = "reference-orientation">180</xsl:attribute>
                     
                     <xsl:call-template name = "Region-Body-default" />
                     <xsl:call-template name = "Region-After-default" />
                 </fo:simple-page-master>
                 
                 <fo:simple-page-master>
                     <xsl:call-template name = "Attrs-Simple-Page-Master-shared" />
                     <xsl:attribute name = "master-name">first</xsl:attribute>
                     
                     <fo:region-body>
                         <xsl:attribute name = "region-name">xsl-region-body</xsl:attribute>
                         <xsl:attribute name = "margin-top">0.5in</xsl:attribute>
                         <xsl:attribute name = "column-count">2</xsl:attribute>
                     </fo:region-body>       
                     
                     <fo:region-before>
                         <xsl:attribute name = "region-name">first-before</xsl:attribute>
                         <xsl:attribute name = "extent">0.5in</xsl:attribute>
                     </fo:region-before>
                     
                 </fo:simple-page-master>
                 
                 <!-- -->
                 
                 <fo:page-sequence-master>
                     <xsl:attribute name = "master-name">recipe</xsl:attribute>
                     <fo:repeatable-page-master-alternatives>
                         <fo:conditional-page-master-reference>
                             <xsl:attribute name = "master-reference">first</xsl:attribute>
                             <xsl:attribute name = "page-position">first</xsl:attribute>
                         </fo:conditional-page-master-reference>
                         <fo:conditional-page-master-reference>
                             <xsl:attribute name = "master-reference">default-odd</xsl:attribute>
                             <xsl:attribute name = "odd-or-even">even</xsl:attribute>
                             <xsl:attribute name = "page-position">rest</xsl:attribute>
                         </fo:conditional-page-master-reference>
                         <fo:conditional-page-master-reference>
                             <xsl:attribute name = "master-reference">default-odd</xsl:attribute>
                             <xsl:attribute name = "odd-or-even">odd</xsl:attribute>
                             <xsl:attribute name = "page-position">rest</xsl:attribute>
                         </fo:conditional-page-master-reference>
                     </fo:repeatable-page-master-alternatives>
                 </fo:page-sequence-master>
                 
             </fo:layout-master-set>
             
             <!-- -->
             
             <fo:page-sequence master-reference="recipe">
                 
                 <fo:static-content>
                     <xsl:attribute name = "flow-name">first-before</xsl:attribute>
                     
                     <fo:block>
                         <xsl:call-template name = "Attrs-Static-Content-shared" />
                         <xsl:attribute name = "border-bottom-color">black</xsl:attribute>
                         <xsl:attribute name = "border-bottom-style">solid</xsl:attribute>
                         
                         <fo:block>
                             <xsl:attribute name = "font-size">
                                 <xsl:value-of select = "number(substring-before($font-size,'pt') * 2)" />pt
                             </xsl:attribute>
                             
                             <xsl:value-of select = "e:eatdrinkfeelgood/e:recipe/e:name/e:common" /> 
                         </fo:block>
                         
                         <xsl:variable name = "count" select = "count(e:eatdrinkfeelgood/e:recipe/e:name/e:other)" />
                         
                         <fo:block>
                             <xsl:call-template name = "Attrs-Header3" />
                             
                             <xsl:for-each select = "e:eatdrinkfeelgood/e:recipe/e:name/e:other">
                                 <xsl:value-of select = "." />
                                 <xsl:if test = "position() &lt; $count">,</xsl:if>
                             </xsl:for-each>
                         </fo:block>          
                         
                     </fo:block>
                 </fo:static-content>

                 <!-- -->
                 
                 <fo:static-content>
                     <xsl:attribute name = "flow-name">default-after</xsl:attribute>
                     
                     <fo:block>
                         <xsl:call-template name = "Attrs-Static-Content-shared" />
                         <xsl:attribute name = "border-top-color">black</xsl:attribute>
                         <xsl:attribute name = "border-top-style">solid</xsl:attribute>
                         <xsl:attribute name = "border-after-width">0.5mm</xsl:attribute>            
                         <xsl:attribute name = "padding-before">0.5em</xsl:attribute>
                         
                         <xsl:value-of select = "e:eatdrinkfeelgood/e:recipe/e:name/e:common" /> /<fo:page-number />
                     </fo:block>
                 </fo:static-content>
                 
                 <!-- -->
                 
                 <fo:flow>
                     <xsl:attribute name = "flow-name">xsl-region-body</xsl:attribute>
                     
                     <fo:block>
                         <xsl:attribute name = "font-family">serif</xsl:attribute>
                         <xsl:attribute name = "font-size"><xsl:value-of select = "$font-size" /></xsl:attribute>
                         
                         <fo:block>
                             <xsl:attribute name = "break-after">column</xsl:attribute>              
                             <xsl:attribute name = "start-indent">0.5em</xsl:attribute>
                             
                             <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe/e:requirements/e:time" />           
                             
                             <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe/e:yield" />
                             
                             <xsl:apply-templates select = "e:eatdrinkfeelgood/e:recipe/e:source" />
                             
                             <xsl:if test = "/e:eatdrinkfeelgood/e:recipe/e:history">
                                 <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe/e:history" />             
                             </xsl:if>
                             
                         </fo:block>
                         
                         <fo:block>
                             <xsl:attribute name = "break-after">column</xsl:attribute>
                             <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe/e:requirements/e:ingredients" />
                             <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe/e:requirements/e:equipment" />
                         </fo:block>
                         
                         <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe/e:directions" />
                         
                         <fo:block>
                             <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe/e:notes" />
                             <xsl:call-template name = "External-References" />             
                         </fo:block>
                         
                     </fo:block>
                 </fo:flow>
             </fo:page-sequence>
             
         </fo:root>
     </xsl:template>

<!-- ======================================================================

     caption
     ====================================================================== -->

     <xsl:template match = "e:caption" />

<!-- ======================================================================

     cooking
     ====================================================================== -->

     <xsl:template match = "e:cooking">
         <fo:block>
             <xsl:apply-templates />,
             <xsl:text> </xsl:text>
             <fo:inline>
                 <xsl:call-template name = "Attrs-Emphasize" />
                 cooking
             </fo:inline>         
         </fo:block>
     </xsl:template>

<!-- ======================================================================

     detail
     ====================================================================== -->

     <xsl:template match = "e:detail">
         <fo:inline>
             <xsl:call-template name = "Attrs-Emphasize" />
             <xsl:value-of select = "." />
         </fo:inline>
     </xsl:template>

<!-- ======================================================================

     directions
     ====================================================================== -->

     <xsl:template match = "e:directions">
         <fo:block>
             <xsl:call-template name = "Attrs-Sect" />         
             <xsl:attribute name = "space-after">2em</xsl:attribute>
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header" />         
                 Directions
             </fo:block>
             
             <xsl:choose>
                 
                 <xsl:when test = "namespace-uri(./*[position()=1])='http://www.eatdrinkfeelgood.org/1.1/ns' and local-name(./*[position()=1]) = 'step'">
                     <xsl:call-template name = "Steps" />
                 </xsl:when>
                 
                 <xsl:otherwise>
                     <xsl:apply-templates select = "e:stage" />
                 </xsl:otherwise>
                 
             </xsl:choose>
             
         </fo:block>
         
     </xsl:template>

<!-- ======================================================================

     equipment
     ====================================================================== -->

     <xsl:template match = "e:equipment">
         <fo:block>
             <xsl:call-template name = "Attrs-Sect" />
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header" />
                 Equipment
             </fo:block>
             
             <fo:list-block>
                 <xsl:for-each select = "e:device">
                     <fo:list-item>
                         <fo:list-item-label>
                             <xsl:call-template name = "List-Dot" />
                         </fo:list-item-label>
                         <fo:list-item-body>
                             <xsl:attribute name = "start-indent">1.5em</xsl:attribute>
                             <fo:block>
                                 <xsl:apply-templates />
                             </fo:block>              
                         </fo:list-item-body>
                     </fo:list-item>
                 </xsl:for-each>
             </fo:list-block>
             
         </fo:block>

     </xsl:template>

<!-- ======================================================================

     extref
     ====================================================================== -->

     <xsl:template match = "e:extref">
       
         <xsl:value-of select = "@xlink:title" />
         
         <xsl:call-template name = "Reference-Link">
             <xsl:with-param name = "uri">
                 <xsl:value-of select = "@xlink:href" />
             </xsl:with-param>
         </xsl:call-template>

     </xsl:template>

<!-- ======================================================================

     history
     ====================================================================== -->

     <xsl:template match = "e:history">
         <fo:block>
             <xsl:call-template name = "Attrs-Emphasize" />
             <xsl:attribute name = "space-before">0.5em</xsl:attribute>
             <xsl:attribute name = "start-indent">0.5em</xsl:attribute>
             <xsl:attribute name = "end-indent">0.5em</xsl:attribute>
             <xsl:attribute name = "color">#666</xsl:attribute>            
             <xsl:attribute name = "text-align">justify</xsl:attribute>
             
             <xsl:apply-templates select = "e:para" />
             <xsl:apply-templates select = "e:image" />
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header3" />
                 <xsl:attribute name = "font-style">normal</xsl:attribute>
                 <xsl:apply-templates select = "e:author" />
             </fo:block>
         </fo:block>
         
     </xsl:template>

<!-- ======================================================================

     image
     ====================================================================== -->

     <xsl:template match = "e:image/e:extref">

         <!-- This should be accomplished by setting the 
              'visibility' property once it's actually been
              implemented by the processors. -->
         
         <xsl:if test = "$hide-images = ''">         
             
             <fo:block>
                 <xsl:attribute name = "font-family">sans-serif</xsl:attribute>
                 <xsl:attribute name = "font-size">0.9em</xsl:attribute>
                 <xsl:attribute name = "font-style">normal</xsl:attribute>
                 <xsl:attribute name = "color">#ccc</xsl:attribute>
                 <xsl:attribute name = "start-indent">3em</xsl:attribute>
                 <xsl:attribute name = "space-before">0.4em</xsl:attribute>
                 
                 <xsl:if test = "$hide-images-src = ''">         
                     <fo:block>
                         <xsl:attribute name = "space-after">1em</xsl:attribute>
                         <fo:external-graphic>
                             <xsl:attribute name = "src">url(<xsl:value-of select = "@xlink:href" />)</xsl:attribute>
                             <xsl:if test = "$image-height != ''">
                                 <xsl:attribute name = "height"><xsl:value-of select = "$image-height" /></xsl:attribute>
                             </xsl:if>
                         </fo:external-graphic>
                     </fo:block>
                 </xsl:if>
                 
                 <fo:block>
                     <xsl:attribute name = "text-align">left</xsl:attribute>
                     <xsl:attribute name = "font-weight">bold</xsl:attribute>
                     <xsl:attribute name = "space-after">0.4em</xsl:attribute>
                     
                     <xsl:if test = "$hide-images-src != ''">
                         <fo:inline>
                             <xsl:value-of select = "../@rel" /><xsl:text>: </xsl:text>
                         </fo:inline>
                     </xsl:if>
                     
                     <xsl:value-of select = "@xlink:title" />
                     <xsl:call-template name = "Reference-Link">
                         <xsl:with-param name = "uri">
                             <xsl:value-of select = "@xlink:href" />
                         </xsl:with-param>
                     </xsl:call-template>
                 </fo:block>
                 
                 <fo:block>
                     <xsl:call-template name = "Attrs-Emphasize" />
                     <xsl:attribute name = "text-align">left</xsl:attribute>
                     <xsl:apply-templates select = "../e:caption/e:para" />
                 </fo:block>
                 
             </fo:block>
         </xsl:if>
     </xsl:template>

<!-- ======================================================================

     ingredients
     ====================================================================== -->

     <xsl:template match = "e:ingredients">
         <fo:block>
             <xsl:call-template name = "Attrs-Sect" />         
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header" />
                 Ingredients
             </fo:block>
             
             <!-- this is returning the count of all the ing element 
                  rather than a count of unique ing/item; to be fixed -->
             
             <fo:block>
                 <xsl:attribute name = "space-after">1em</xsl:attribute>
                 
                 <xsl:variable name = "num-ings" select = "count(ancestor-or-self::*//e:ing)" />
                 
                 <xsl:for-each select = "ancestor-or-self::*//e:ing[count(.|key('ings', e:item)[1]) = 1]">
                     <xsl:sort select="e:item" data-type="text" order="ascending"/>
                     <xsl:value-of select = "e:item" /> 
                     <xsl:if test = "position() &lt; $num-ings">, </xsl:if>
                 </xsl:for-each>
             </fo:block>
             
             <xsl:choose>
                 <xsl:when test = "namespace-uri(./*[position()=1])='http://www.eatdrinkfeelgood.org/1.1/ns' and local-name(./*[position()=1]) = 'ing'">
                     <xsl:call-template name = "IngList" />
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:apply-templates select = "e:set" />
                 </xsl:otherwise>
             </xsl:choose>
             
         </fo:block>
         
     </xsl:template>

<!-- ======================================================================

     item
     ====================================================================== -->

     <xsl:template match = "item">
         <fo:inline>
             <xsl:value-of select = "item" />
         </fo:inline>
     </xsl:template>

<!-- ====================================================================== 

     n
     ====================================================================== -->

     <xsl:template match = "e:n">
         <fo:inline>
             <xsl:value-of select = "@value" />
         </fo:inline>
     </xsl:template>

<!-- ======================================================================

     note
     ====================================================================== -->

     <xsl:template match = "e:note">
         <fo:block>
             <xsl:apply-templates select = "e:para" />
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header3" />
                 <xsl:attribute name = "text-align">left</xsl:attribute>
                 <xsl:apply-templates select = "e:author" />
                 <xsl:text> </xsl:text>
                 <xsl:apply-templates select = "dc:date" />
             </fo:block>
         </fo:block>  
     </xsl:template>

<!-- ======================================================================

     notes
     ====================================================================== -->

     <xsl:template match = "e:notes">
         <fo:block>
             <xsl:call-template name = "Attrs-Sect" />         
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header" />         
                 Notes
             </fo:block>
             
             <fo:list-block>
                 <xsl:for-each select = "e:note">
                     <fo:list-item>
                         <fo:list-item-label>
                             <fo:block /> 
                         </fo:list-item-label>
                         <fo:list-item-body>
                             <xsl:attribute name = "start-indent">0.5em</xsl:attribute>
                             <fo:block>
                                 <xsl:apply-templates select = "." />
                             </fo:block>              
                         </fo:list-item-body>
                     </fo:list-item>          
                 </xsl:for-each>
             </fo:list-block>
             
             <xsl:apply-templates select = "e:image" />
         </fo:block>

     </xsl:template>

<!-- ======================================================================

     other
     ====================================================================== -->

     <xsl:template match = "e:other">
         <fo:inline>
             <xsl:call-template name = "Attrs-Emphasize" />
             <xsl:value-of select = "." />
         </fo:inline>
     </xsl:template>

<!-- ======================================================================

     para
     ====================================================================== -->

     <xsl:template match = "e:para">
         <fo:block>
             <xsl:attribute name = "space-after">0.4em</xsl:attribute>
             <xsl:value-of select = "." />
         </fo:block>
     </xsl:template>

<!-- ======================================================================

     publication
     ====================================================================== -->

     <xsl:template match = "e:publication">

         <xsl:value-of select = "e:name" />
         
         <xsl:if test = "@xlink:href">
             <xsl:call-template name = "Reference-Link">
                 <xsl:with-param name = "uri">
                     <xsl:value-of select = "@xlink:href" />
                 </xsl:with-param>
             </xsl:call-template>
         </xsl:if>
         
         <xsl:if test = "@isbn">
             <fo:block>
                 <xsl:value-of select = "@isbn" />
             </fo:block>
         </xsl:if>
         
     </xsl:template>

<!-- ======================================================================

     preparation
     ====================================================================== -->

     <xsl:template match = "e:preparation">
         <fo:block>      
             <xsl:apply-templates />
             <xsl:text>, </xsl:text>
             <fo:inline>
                 <xsl:call-template name = "Attrs-Emphasize" />
                 preparation
             </fo:inline> 
         </fo:block>
     </xsl:template>

<!-- ====================================================================== 

     requirements
     ====================================================================== -->

     <xsl:template match = "e:requirements" />

<!-- ====================================================================== 

     set
     ====================================================================== -->

     <xsl:template match = "e:set">
         <fo:block>
             <xsl:call-template name = "Attrs-Sect2" /> 
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header3" />
                 <xsl:value-of select = "e:name/e:common" />
             </fo:block>
             
             <xsl:choose>
                 <xsl:when test = "xi:include">
                     <fo:list-block>
                         <xsl:for-each select = "xi:include">
                             <fo:list-item>
                                 <fo:list-item-label>
                                     <xsl:call-template name = "List-Dot" />
                                 </fo:list-item-label>
                                 <fo:list-item-body>
                                     <xsl:attribute name = "start-indent">1.5em</xsl:attribute>
                                     <fo:block>
                                         <xsl:apply-templates select = "." />
                                     </fo:block>
                                 </fo:list-item-body>              
                             </fo:list-item>
                         </xsl:for-each>
                     </fo:list-block>
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:call-template name = "IngList" />           
                 </xsl:otherwise>
             </xsl:choose>
       </fo:block>

     </xsl:template>

<!-- ====================================================================== 

     source
     ====================================================================== -->

     <xsl:template match = "e:source">
         <fo:block>
             <xsl:call-template name = "Attrs-Sect" />
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header" />
                 Source
             </fo:block>
             
             <fo:block>
                 <xsl:apply-templates select = "e:publication" />
             </fo:block>
             
             <fo:block>
                 <xsl:if test = "e:publication">
                     <xsl:attribute name = "space-before">0.5em</xsl:attribute>           
                 </xsl:if>
                 
                 <xsl:variable name = "count" select = "count(e:author)" />
                 <xsl:for-each select = "e:author">
                     <xsl:apply-templates select = "." />
                     <xsl:if test = "position() &lt; $count">, </xsl:if>
                 </xsl:for-each>
             </fo:block>
             
         </fo:block>

     </xsl:template>

<!-- ====================================================================== 

     stage
     ====================================================================== -->

     <xsl:template match = "e:stage">
         <fo:block>
             <xsl:attribute name = "start-indent">0.5em</xsl:attribute>
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header3" />
                 <xsl:value-of select = "e:name/e:common" />           
             </fo:block>
             
             <xsl:choose>
                 <xsl:when test = "xi:include">
                     <fo:list-block>
                         <xsl:for-each select = "xi:include">
                             <fo:list-item>
                                 <fo:list-item-label>
                                     <xsl:call-template name = "List-Dot" />
                                 </fo:list-item-label>
                                 <fo:list-item-body>
                                     <xsl:attribute name = "start-indent">1.5em</xsl:attribute>
                                     <fo:block>
                                         <xsl:apply-templates select = "." />
                                     </fo:block>              
                                 </fo:list-item-body>
                             </fo:list-item>
                         </xsl:for-each>
                     </fo:list-block>
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:call-template name = "Steps" />
                 </xsl:otherwise>
             </xsl:choose>
         </fo:block>

     </xsl:template>

<!-- ====================================================================== 

     time
     ====================================================================== -->

     <xsl:template match = "e:time">
         <fo:block>
             <xsl:call-template name = "Attrs-Sect" />
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Header" />
                 Time
             </fo:block>
             
             <fo:block>
                 <xsl:call-template name = "Attrs-Sect" />
                 <xsl:apply-templates select = "e:preparation" />
                 
                 <xsl:apply-templates select = "e:cooking" />
             </fo:block>
         </fo:block>

     </xsl:template>

<!-- ====================================================================== 

     xi:include
     ====================================================================== -->

     <xsl:template match = "xi:include">

         <fo:inline>
             <xsl:call-template name = "Attrs-Emphasize" />
             see :
         </fo:inline>
         <xsl:apply-templates />
         
     </xsl:template>
     
     <!-- ====================================================================== 
          
     yield
     ====================================================================== -->

     <xsl:template match = "e:yield">

         <fo:block>
             <xsl:call-template name = "Attrs-Sect" />
             <fo:block>
                 <xsl:call-template name = "Attrs-Header" />
                 Yield
             </fo:block>
             <xsl:for-each select = "e:amount">
                 <fo:block>
                     <xsl:apply-templates />
                 </fo:block>
             </xsl:for-each>
         </fo:block>
         
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Emphasize
     ====================================================================== -->

     <xsl:template name = "Attrs-Emphasize">
         <xsl:attribute name = "font-style">italic</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Footnote-Body
     ====================================================================== -->

     <xsl:template name = "Attrs-Footnote-Body">
         <xsl:attribute name = "start-indent">0em</xsl:attribute>
         <xsl:attribute name = "font-family">sans-serif</xsl:attribute>
         <xsl:attribute name = "font-size">.8em</xsl:attribute>
         <xsl:attribute name = "text-align">left</xsl:attribute>
         <xsl:attribute name = "color">#000</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Footnote-Content
     ====================================================================== -->

     <xsl:template name = "Attrs-Footnote-Content">
         <xsl:attribute name = "start-indent">1.5em</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Footnote-Label
     ====================================================================== -->

     <xsl:template name = "Attrs-Footnote-Label" />

<!-- ====================================================================== 

     Attrs-Footnote-Marker
     ====================================================================== -->

     <xsl:template name = "Attrs-Footnote-Marker">
         <xsl:attribute name = "font-size">0.8em</xsl:attribute>
         <xsl:attribute name = "baseline-shift">super</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Header
     ====================================================================== -->

     <xsl:template name = "Attrs-Header">
         <xsl:attribute name = "font-family">sans-serif</xsl:attribute>
         <xsl:attribute name = "font-weight">bold</xsl:attribute>
         <xsl:attribute name = "space-after">0.5em</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Header3
     ====================================================================== -->

     <xsl:template name = "Attrs-Header3">
         <xsl:attribute name = "font-family">sans-serif</xsl:attribute>
         <xsl:attribute name = "font-size">0.9em</xsl:attribute>
         <xsl:attribute name = "space-after">0.5em</xsl:attribute>
         <xsl:attribute name = "color">#ccc</xsl:attribute>
         <xsl:attribute name = "text-align">right</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Sect
     ====================================================================== -->

     <xsl:template name = "Attrs-Sect">
         <xsl:attribute name = "space-after">0.5em</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Sect2
     ====================================================================== -->

     <xsl:template name = "Attrs-Sect2">
         <xsl:attribute name = "start-indent">0.5em</xsl:attribute>
         <xsl:attribute name = "space-after">0.5em</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Simple-Page-Master-shared
     ====================================================================== -->

     <xsl:template name = "Attrs-Simple-Page-Master-shared">
         <xsl:attribute name = "page-height"><xsl:call-template name = "Page-Height" /></xsl:attribute>
         <xsl:attribute name = "page-width"><xsl:call-template name = "Page-Width" /></xsl:attribute>
         <xsl:attribute name = "margin-top">0.5in</xsl:attribute>
         <xsl:attribute name = "margin-bottom">0.5in</xsl:attribute>
         <xsl:attribute name = "margin-left"><xsl:call-template name = "Margin-Left-Right" /></xsl:attribute>
         <xsl:attribute name = "margin-right"><xsl:call-template name = "Margin-Left-Right" /></xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     Attrs-Static-Content-shared
     ====================================================================== -->

     <xsl:template name = "Attrs-Static-Content-shared">
         <xsl:attribute name = "font-size"><xsl:value-of select = "$font-size" /></xsl:attribute>
         <xsl:attribute name = "font-family">sans-serif</xsl:attribute>
         <xsl:attribute name = "text-align">right</xsl:attribute>
     </xsl:template>

<!-- ====================================================================== 

     External-References
     ====================================================================== -->

     <xsl:template name = "External-References">

         <fo:block>
             <xsl:call-template name = "Attrs-Sect" />         
             <fo:block>
                 <xsl:call-template name = "Attrs-Header" />         
                 External References
             </fo:block>
             <fo:list-block>
                 <xsl:call-template name = "Attrs-Footnote-Body" />

                 <xsl:for-each select="//*[namespace-uri()='http://www.eatdrinkfeelgood.org/1.1/ns' and (local-name()='extref' or local-name()='publication') and @xlink:href != '#'][count(.|key('extrefs', @xlink:href)[1]) = 1]">
                     <fo:list-item>
                         <fo:list-item-label>
                             <fo:block>
                                 <xsl:call-template name = "Attrs-Footnote-Label" />
                                 <xsl:number value = "position()" format = "1" />.
                             </fo:block>
                         </fo:list-item-label>
                         <fo:list-item-body>
                             <fo:block>
                                 <xsl:call-template name = "Attrs-Footnote-Content" />
                                 <!--<fo:inline><xsl:value-of select = "name(..)" />: </fo:inline>-->
                                 <xsl:value-of select = "@xlink:href" />
                             </fo:block>
                         </fo:list-item-body>
                     </fo:list-item>
                     
                 </xsl:for-each>
                 
             </fo:list-block>
         </fo:block>

     </xsl:template>

<!-- ====================================================================== 

     IngList
     ====================================================================== -->

     <xsl:template name = "IngList">

         <fo:list-block>
             <xsl:for-each select = "e:ing">
                 <fo:list-item>
                     <fo:list-item-label>
                         <xsl:call-template name = "List-Dot" />
                     </fo:list-item-label>
                     <fo:list-item-body>
                         <xsl:attribute name = "start-indent">1.5em</xsl:attribute>
                         <fo:block>
                             <xsl:apply-templates select = "." />
                         </fo:block>
                     </fo:list-item-body>              
                 </fo:list-item> 
             </xsl:for-each>
         </fo:list-block>

     </xsl:template>

<!-- ====================================================================== 

     List-Dot
     ====================================================================== -->

     <xsl:template name = "List-Dot">

         <fo:block>
             <fo:inline>
                 <xsl:attribute name = "font-family">Symbol</xsl:attribute>
                 <xsl:attribute name = "color">#ccc</xsl:attribute>
                 &#x2022;
             </fo:inline>
         </fo:block>       
         
     </xsl:template>

<!-- ====================================================================== 

     Margin-Left-Right
     ====================================================================== -->

     <xsl:template name = "Margin-Left-Right">

         <xsl:choose>
             <xsl:when test = "$size = 'small'">0.25in</xsl:when>
             <xsl:otherwise>0.5in</xsl:otherwise>
         </xsl:choose>

     </xsl:template>

<!-- ====================================================================== 

     Page-Height
     ====================================================================== -->

     <xsl:template name = "Page-Height">

         <xsl:choose>
             <xsl:when test = "$size = 'small'">4in</xsl:when>
             <xsl:otherwise>5in</xsl:otherwise>
         </xsl:choose>
         
     </xsl:template>

<!-- ====================================================================== 

     Page-Width
     ====================================================================== -->

     <xsl:template name = "Page-Width">

         <xsl:choose>
             <xsl:when test = "$size = 'small'">6in</xsl:when>
             <xsl:otherwise>8in</xsl:otherwise>
         </xsl:choose>
         
     </xsl:template>

<!-- ====================================================================== 

     Reference-Link
     ====================================================================== -->

     <xsl:template name = "Reference-Link">

         <xsl:param name = "uri" />
         <xsl:for-each select="//*[namespace-uri()='http://www.eatdrinkfeelgood.org/1.1/ns' and (local-name()='extref' or local-name()='publication') and @xlink:href != '#'][count(.|key('extrefs', @xlink:href)[1]) = 1]">
             <xsl:if test = "$uri = @xlink:href">
                 <xsl:text>  </xsl:text>
                 [<fo:inline>
                 <xsl:call-template name = "Attrs-Footnote-Marker" />
                 <xsl:number  value = "position()" format = "1" />
                 </fo:inline>]
             </xsl:if>
         </xsl:for-each>
         
     </xsl:template>

<!-- ====================================================================== 

     Region-After-default
     ====================================================================== -->

     <xsl:template name = "Region-After-default">

         <fo:region-after>
             <xsl:attribute name = "region-name">default-after</xsl:attribute>
             <xsl:attribute name = "extent">0.25in</xsl:attribute>
         </fo:region-after>
         
     </xsl:template>

<!-- ====================================================================== 

     Region-Body-default
     ====================================================================== -->

     <xsl:template name = "Region-Body-default">

         <fo:region-body>
             <xsl:attribute name = "region-name">xsl-region-body</xsl:attribute>
             <xsl:attribute name = "margin-bottom">0.5in</xsl:attribute>
             <xsl:attribute name = "column-count">2</xsl:attribute>
         </fo:region-body>       
         
     </xsl:template>

<!-- ====================================================================== 

     Steps
     ====================================================================== -->

     <xsl:template name = "Steps">
         
         <xsl:choose>
             <xsl:when test="count(e:step)>1">
                 <fo:list-block>
                     <xsl:attribute name = "space-before">0.7em</xsl:attribute>
                     
                     <xsl:for-each select = "e:step">
                         <fo:list-item>
                             <fo:list-item-label>
                                 <fo:block><xsl:value-of select = "position()" />.</fo:block>
                             </fo:list-item-label>
                             <fo:list-item-body>
                                 <xsl:attribute name = "start-indent">1.5em</xsl:attribute>
                                 <fo:block>
                                     <xsl:apply-templates select = "." />
                                 </fo:block>
                             </fo:list-item-body>              
                         </fo:list-item> 
                     </xsl:for-each>
                     
                 </fo:list-block>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:for-each select = "e:step">
                     <fo:block>
                         <xsl:apply-templates select = "." />
                     </fo:block>
                 </xsl:for-each>
             </xsl:otherwise>
         </xsl:choose>
         
         <xsl:apply-templates select = "e:image" />
         
     </xsl:template>

<!-- ======================================================================

     FIN - $Id: eatdrinkfeelgood-1.1-to-indexcard-fo.xsl,v 1.16 2006/04/05 02:43:41 asc Exp $
     ====================================================================== -->

</xsl:stylesheet>
