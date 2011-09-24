<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns="http://www.eatdrinkfeelgood.info/1.1/ns"
                version="1.0">

<!-- ====================================================================== 
     eatdrinkfeelgood-1.0-to-1.1.xsl                                                   

     This stylesheet converts a document conforming to the eatdrinkfeelgood
     1.0 DTD into a document conforming to the eatdrinkfeelgood 1.1 DTD.

     Version : 1.01
     Date    : $Date: 2002/12/20 04:44:27 $

     Copyright (c) 2002 Aaron Straup Cope
     http://www.eatdrinkfeelgood.info

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

     ====================================================================== -->

  <xsl:output method="xml" encoding = "UTF-8" indent = "yes" doctype-public = "-//Aaron Straup Cope//DTD Eatdrinkfeelgood 1.1//EN//XML" doctype-system = "http://www.eatdrinkfeelgood.info/1.1/eatdrinkfeelgood.dtd" />

  <xsl:strip-space elements = "*"/>

<!-- ====================================================================== 
     Parameters

     name : the name of the person who should be listed in the revhistory/rev
            entry

     ====================================================================== -->

  <xsl:param name = "name" />

<!-- ====================================================================== 

     date : the date to be listed in the revhistory/rev entry. Should be 
            formatted as "%Y-%m-%dT%H:%M:%S -%H%M"
     ====================================================================== -->
  
  <xsl:param name = "date" />

<!-- ====================================================================== 
     Matching templates

     /
     ====================================================================== -->

  <xsl:template match="/">
   <eatdrinkfeelgood>
    <xsl:copy-of select = "eatdrinkfeelgood/head" />
    <xsl:apply-templates select = "eatdrinkfeelgood" />
   </eatdrinkfeelgood>
  </xsl:template>

<!-- ====================================================================== 

     amount
     ====================================================================== -->

  <xsl:template match = "amount">
   <quantity>
    <n>
     <xsl:attribute name = "value"><xsl:value-of select = "." /></xsl:attribute>
    </n>
   </quantity>            
  </xsl:template>

<!-- ====================================================================== 

     author
     ====================================================================== -->

     <xsl:template match = "author">
      <author>
       <xsl:attribute name = "content-type">text</xsl:attribute>
       <extref>
        <xsl:attribute name = "xlink:href">#</xsl:attribute>
        <xsl:attribute name = "xlink:title">
        <xsl:value-of select = "firstname" />&#160;<xsl:value-of select = "surname" />
        </xsl:attribute>
       </extref>
      </author>
     </xsl:template>

<!-- ====================================================================== 

     course
     ====================================================================== -->

  <xsl:template match = "course">
   <course>
    <xsl:copy-of select = "name" />
    <xsl:copy-of select = "abstract" />
    <xsl:apply-templates select = "recipe" />          
    <xsl:apply-templates select = "notes" />
    <xsl:apply-templates select = "history" />
   </course>
  </xsl:template>

<!-- ====================================================================== 

     date
     ====================================================================== -->

  <xsl:template match = "date">
   <dc:date>
     <xsl:value-of select = "year" />-<xsl:value-of select = "month" />-<xsl:value-of select = "day" />T00:00:00 <xsl:value-of select = "substring-after($date,' ')" />
   </dc:date>    
  </xsl:template>

<!-- ====================================================================== 

     history
     ====================================================================== -->

  <xsl:template match = "history">
   <history>
    <xsl:apply-templates select = "para" />
    <xsl:apply-templates select = "image" />
    <xsl:apply-templates select = "author" />
    <xsl:apply-templates select = "date" />               
   </history>
  </xsl:template>

<!-- ====================================================================== 

     image
     ====================================================================== -->

     <xsl:template match = "image">
      <xsl:variable name = "src">
       <xsl:value-of select = "src" />
      </xsl:variable>

      <image>
      <xsl:attribute name = "rel"><xsl:value-of select = "@type" /></xsl:attribute>
       <extref>
        <xsl:attribute name = "xlink:show">replace</xsl:attribute>
        <xsl:attribute name = "xlink:href"><xsl:value-of select = "src" /></xsl:attribute>
        <xsl:attribute name = "type">
         <xsl:value-of select = "substring($src,(string-length($src) -2),3)" />
        </xsl:attribute>
        <xsl:attribute name = "alt">
         <xsl:value-of select = "title" />          
        </xsl:attribute>
       </extref>
       <xsl:copy-of select = "caption" />
      </image>    
     </xsl:template>

<!-- ====================================================================== 

     ing
     ====================================================================== -->

   <xsl:template match = "ing">
   <ing>
    <amount>
     <xsl:apply-templates select = "amount" />
     <xsl:copy-of select = "measure" />
    </amount>
    <xsl:copy-of select = "item" />
    <xsl:copy-of select = "detail" />
    <xsl:apply-templates select = "image" />
   </ing>
  </xsl:template>

<!-- ====================================================================== 

     menu
     ====================================================================== -->

  <xsl:template match = "menu">
   <menu>
    <xsl:copy-of select = "name" />
    <xsl:copy-of select = "abstract" />
    <xsl:apply-templates select = "course" />       
   </menu>    
  </xsl:template>

<!-- ====================================================================== 

     notes
     ====================================================================== -->

  <xsl:template match = "note">
    <note>
     <xsl:apply-templates select = "para" />
     <xsl:apply-templates select = "author" />
     <xsl:apply-templates select = "date" />
    </note>
  </xsl:template>

<!-- ====================================================================== 

     notes
     ====================================================================== -->

  <xsl:template match = "notes">
   <notes>

     <xsl:if test = "/eatdrinkfeelgood/recipe/custom">
     <note>
       <xsl:for-each select = "/eatdrinkfeelgood/recipe/custom">
      <para><xsl:value-of select = "@name" />:<xsl:value-of select = "@content" /></para> 
     </xsl:for-each>
     <xsl:call-template name = "updated" />
     </note>

    </xsl:if>

    <xsl:apply-templates select = "note" />
    <xsl:apply-templates select = "image" />

   </notes>          
  </xsl:template>

<!-- ====================================================================== 

     para
     ====================================================================== -->

  <xsl:template match = "para">
   <xsl:copy-of select = "." />
  </xsl:template>

<!-- ====================================================================== 

     recipe
     ====================================================================== -->

  <xsl:template match = "recipe">
    <recipe>
      <xsl:copy-of select = "name" />

      <source>
       <xsl:if test = "source/@content != ''">
        <publication>
          <name>
           <common>
            <xsl:value-of select = "source/@content" />
            </common>
          </name>
        </publication>
       </xsl:if>
      </source>

      <xsl:if test = "yield">
       <yield>
        <amount>
         <xsl:apply-templates select = "amount" />
         <xsl:copy-of select = "measure" />
         <xsl:copy-of select = "detail" />
        </amount>
       </yield>
      </xsl:if>

      <xsl:for-each select = "category">
       <category>
        <xsl:attribute name = "type">name</xsl:attribute>
        <xsl:value-of select = "@content" />
       </category>
      </xsl:for-each>

      <requirements>
       <ingredients>
        <xsl:apply-templates select = "ingredients/ing" />
       </ingredients>
      </requirements>

      <xsl:copy-of select = "directions" />

      <xsl:apply-templates select = "notes" />
      <xsl:apply-templates select = "history" />

    </recipe>
  </xsl:template>

<!-- ====================================================================== 

     rev
     ====================================================================== -->

  <xsl:template match = "rev">
   <rev>
    <xsl:copy-of select = "version" />
    <xsl:apply-templates select = "author" />
    <xsl:apply-templates select = "date" />
    <xsl:copy-of select = "changes" />
   </rev>    
  </xsl:template>

<!-- ====================================================================== 

     revhistory
     ====================================================================== -->

  <xsl:template match = "revhistory">
    <revhistory>
     <rev>
      <version><xsl:value-of select = "rev/version" />.1</version>
      <xsl:call-template name = "updated" />
      <changes>
	<para>Updated to version 1.1 of the DTD</para>
      </changes>
     </rev>
     <xsl:apply-templates select = "rev" />
    </revhistory>
  </xsl:template>

<!-- ====================================================================== 

     step
     ====================================================================== -->

  <xsl:template match = "step">
   <step>
    <xsl:apply-templates select = "para" />
    <xsl:apply-templates select = "image" />
   </step>
  </xsl:template>

<!-- ====================================================================== 
     Named templates

     updated
     ====================================================================== -->

  <xsl:template name = "updated">
   <xsl:variable name = "type">
    <xsl:value-of select = "substring-before($name,' ')" />      
   </xsl:variable>

   <xsl:variable name = "author">
    <xsl:value-of select = "substring-after($name,' ')" />      
   </xsl:variable>

   <author>
    <xsl:attribute name = "content-type">
      <xsl:value-of select = "$type" />
    </xsl:attribute>

    <extref>
     <xsl:attribute name = "xlink:href">
      <xsl:value-of select = "substring-before($author,' ')" />
     </xsl:attribute>
     <xsl:attribute name = "xlink:title">
      <xsl:value-of select = "substring-after($author,' ')" />
     </xsl:attribute>
    </extref>
   </author>    
   <dc:date>
    <xsl:value-of select = "$date" />
   </dc:date>    
  </xsl:template>

<!-- ====================================================================== 
     FIN
     ====================================================================== -->

</xsl:stylesheet>

