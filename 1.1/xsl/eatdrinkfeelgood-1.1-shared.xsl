<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:e="http://www.eatdrinkfeelgood.org/1.1/ns"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                version="1.0">

<!-- ====================================================================== 
     eatdrinkfeelgood-1.1-shared.xsl                                                   

     Version : 1.0
     Date    : $Date: 2003/01/03 05:34:02 $

     Copyright (c) 2003 Aaron Straup Cope
     http://www.eatdrinkfeelgood.org

     Permission to use, copy, modify and distribute this stylesheet and its 
     accompanying documentation for any purpose and without fee is hereby 
     granted in perpetuity, provided that the above copyright notice and 
     this paragraph appear in all copies.  The copyright holders make no 
     representation about the suitability of the stylesheet for any purpose.

     It is provided "as is" without expressed or implied warranty.
     ====================================================================== -->

     <xsl:key name = "extrefs"  match = "//*[@xlink:href]"  use = "@xlink:href" />

<!-- ======================================================================

     abstract
     ====================================================================== -->

     <xsl:template match = "e:abstract">
         <xsl:apply-templates select = "e:para" />
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

     hours
     ====================================================================== -->

     <xsl:template match = "e:hours">
         <xsl:value-of select = "e:n/@value" /> hours
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

     FIN - $Id: eatdrinkfeelgood-1.1-shared.xsl,v 1.3 2003/01/03 05:34:02 asc Exp $
     ====================================================================== -->

</xsl:stylesheet>
