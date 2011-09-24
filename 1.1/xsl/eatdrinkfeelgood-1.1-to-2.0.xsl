<!-- ====================================================================== 
     eatdrinkfeelgood-1.1-to-eatdrinkfeelgood-2.0a.xsl

     This stylesheet converts a document conforming to the eatdrinkfeelgood
     1.1 DTD into a document conforming to the experimental eatdrinkfeelgood
     2.0a format.

     Version : 0.1
     Date    : $Date: 2006/03/23 16:49:18 $

     Copyright (c) 2006 Aaron Straup Cope
     http://www.eatdrinkfeelgood.org

     Documentation: http://www.eatdrinkfeelgood.org/tools/xsl/eatdrinkfeelgood-1.1-to-2.0

     Permission to use, copy, modify and distribute this stylesheet and its 
     accompanying documentation for any purpose and without fee is hereby 
     granted in perpetuity, provided that the above copyright notice and 
     this paragraph appear in all copies.  The copyright holders make no 
     representation about the suitability of the stylesheet for any purpose.

     It is provided "as is" without expressed or implied warranty.

     ====================================================================== -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:e="http://www.eatdrinkfeelgood.org/1.1/ns"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:x="http://www.w3.org/XML/1998/namespace"
                exclude-result-prefixes="xml e dc xlink xi"
                version="1.0">
    
    <xsl:output method = "text" />
    <xsl:output encoding = "UTF-8" />
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="para"/>

    <xsl:param name="rdfabout" select="'#'" />

<!-- ======================================================================
     Match templates

     /
     ====================================================================== -->

     <xsl:template match="/">
         <xsl:text disable-output-escaping="yes"># -*-n3-*-

@prefix e:       &lt;http://eatdrinkfeelgood.org/2.0#&gt; .
@prefix I:       &lt;http://eatdrinkfeelgood.org/2.0/us-imperial#&gt; .
@prefix M:       &lt;http://eatdrinkfeelgood.org/2.0/metric#&gt; .
@prefix dc:      &lt;http://purl.org/dc/elements/1.1/&gt; .
@prefix a:       &lt;http://purl.org/atom/1.0/&gt; .</xsl:text>

         <xsl:if test="count(*//xi:include)>0">
             <xsl:text disable-output-escaping="yes">
@prefix xi:      &lt;http://www.w3.org/2001/XInclude&gt; .</xsl:text>
         </xsl:if>

         <xsl:text>

&lt;</xsl:text><xsl:value-of select="$rdfabout" /><xsl:text>&gt;
         </xsl:text>
         <xsl:apply-templates select = "/e:eatdrinkfeelgood/e:recipe" />
         <xsl:text>

  a e:recipe ;
  dc:language "" ;
  dc:identifier "$</xsl:text><xsl:text>Id$" ;
  .
         </xsl:text>
     </xsl:template>

<!-- ======================================================================

     abstract
     ====================================================================== -->

     <xsl:template match = "e:abstract">
        <xsl:text>
            dc:description """</xsl:text>
        <xsl:apply-templates select = "e:para" />
        <xsl:text>""";</xsl:text>
     </xsl:template>

<!-- ======================================================================

     amount
     ====================================================================== -->

     <xsl:template match = "e:amount">
         <xsl:apply-templates select = "e:quantity" />

         <xsl:choose>
             <xsl:when test="e:measure/e:unit">
                 <xsl:text>e:measure </xsl:text>

                 <xsl:choose>
                     <xsl:when test="e:measure/e:unit/@content='cup'">
                         <xsl:text>I:cup; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='gallon'">
                         <xsl:text>I:gallon; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='gram'">
                         <xsl:text>M:g; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='kilogram'">
                         <xsl:text>M:kg; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='litre'">
                         <xsl:text>M:l; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='milligram'">
                         <xsl:text>M:mg; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='millilitre'">
                         <xsl:text>M:ml; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='ounce'">
                         <xsl:text>I:oz; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='pint'">
                         <xsl:text>I:pint; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='pound'">
                         <xsl:text>I:pound; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='quart'">
                         <xsl:text>I:qt; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='tablespoon'">
                         <xsl:text>I:Tbsp; </xsl:text>
                     </xsl:when>
                     <xsl:when test="e:measure/e:unit/@content='teaspoon'">
                         <xsl:text>I:tsp; </xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                         <xsl:text>"</xsl:text>
                         <xsl:value-of select = "e:measure/e:unit/@content" />
                         <xsl:text>"; </xsl:text>
                     </xsl:otherwise>
                 </xsl:choose>

             </xsl:when>        
             <xsl:when test="e:measure/e:customunit">
                 <xsl:text>e:measure </xsl:text>
                 <xsl:text>"</xsl:text>
                 <xsl:value-of select = "e:measure/e:customunit" />
                 <xsl:text>"; </xsl:text>
             </xsl:when>
             <xsl:otherwise />
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
         <xsl:text>
    e:cooking "</xsl:text>
         <xsl:apply-templates />
         <xsl:text>"; </xsl:text>
     </xsl:template>

<!-- ======================================================================

     course
     ====================================================================== -->

     <xsl:template match = "e:course">
         <xsl:message>courses are not really supported</xsl:message>
         <xsl:apply-templates select="e:recipe" />
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
         <xsl:value-of select = "e:n/@value" />
         <xsl:text>D</xsl:text>
     </xsl:template>

<!-- ======================================================================

     detail
     ====================================================================== -->

     <xsl:template match = "e:detail">
         <xsl:text>e:detail "</xsl:text>
         <xsl:value-of select = "." />
         <xsl:text>";</xsl:text>
     </xsl:template>

<!-- ======================================================================

     directions
     ====================================================================== -->

     <xsl:template match = "e:directions">
         <xsl:if test="count(e:stage)=0">
             <xsl:text>

  e:directions (</xsl:text>
                 <xsl:call-template name = "Steps" />
         <xsl:text>
  ); </xsl:text>
         </xsl:if>
     </xsl:template>

<!-- ======================================================================

     equipment
     ====================================================================== -->

     <xsl:template match = "e:equipment">
         <xsl:if test="count(e:device)>0">

             <xsl:text>

  e:equipment [
    e:device (</xsl:text>
                 <xsl:for-each select = "e:device">
                     <xsl:apply-templates />
                 </xsl:for-each>
                 <xsl:text>
    )
  ];</xsl:text>
         </xsl:if>
     </xsl:template>

<!-- ======================================================================

     extref
     ====================================================================== -->

     <xsl:template match = "e:extref">
         <xsl:text>[[</xsl:text>
         <xsl:value-of select = "@xlink:href" />
         <xsl:text>][</xsl:text>
         <xsl:value-of select = "@xlink:title" />
         <xsl:text>]]</xsl:text>
     </xsl:template>

<!-- ======================================================================

     history
     ====================================================================== -->

     <xsl:template match = "e:history">
         <xsl:text>

  e:history (
    [a:content """</xsl:text>
         <xsl:apply-templates select = "e:para" />
         <xsl:text>"""; </xsl:text>
         <xsl:call-template name = "Authored" />
         <xsl:text>]
  );</xsl:text>
     </xsl:template>

<!-- ======================================================================

     hours
     ====================================================================== -->

     <xsl:template match = "e:hours">
         <xsl:value-of select = "e:n/@value" />
         <xsl:text>H</xsl:text>
     </xsl:template>

<!-- ======================================================================

     image
     ====================================================================== -->

     <xsl:template match = "e:image">
         <xsl:choose>
             <xsl:when test = "e:extref">
                 <xsl:text>[[</xsl:text>
                 <xsl:value-of select = "e:extref/@xlink:href" />
                 <xsl:text>][</xsl:text>
                 <xsl:value-of select = "e:extref/@alt" />
                 <xsl:text>]]</xsl:text>
             </xsl:when>    
             <xsl:otherwise>
                 <xsl:text>[a:type="date:base64,"; a:title "</xsl:text>
                 <xsl:value-of select = "e:title" />
                 <xsl:text>"; a:content """</xsl:text>
                 <xsl:value-of select = "e:bin64b" />
                 <xsl:text>"""]</xsl:text>
             </xsl:otherwise>
         </xsl:choose>
     </xsl:template>

<!-- ======================================================================

     ing
     ====================================================================== -->

     <xsl:template match="e:ing">
         <xsl:text>
     [</xsl:text>
                 <xsl:apply-templates />
         <xsl:text>]</xsl:text>
     </xsl:template>

<!-- ======================================================================

     ingredients
     ====================================================================== -->

     <xsl:template match = "e:ingredients">
         <xsl:choose>
             <xsl:when test="count(e:set)>0">
                 <xsl:for-each select="e:set">
                     <xsl:variable name="set_name" select="e:name/e:common" />
                     <xsl:text>

  e:stage [
    dc:title "</xsl:text>
                     <xsl:value-of select="$set_name" />
                     <xsl:text>" ;
    e:ingredients (</xsl:text>
                     <xsl:apply-templates select="child::node()[name()!='name']" />
                     <xsl:text>
    );
</xsl:text>

                    <xsl:for-each select="../../../child::node()[name()='directions']/child::node()[e:name/e:common=$set_name]">
                        <xsl:text>
    e:directions (</xsl:text>
                       <xsl:call-template name="Steps" />
                       <xsl:text>
    );
</xsl:text>
                    </xsl:for-each>
                    <xsl:text>
  ];</xsl:text>
                 </xsl:for-each>
             </xsl:when>
             <xsl:otherwise>
         <xsl:text>

  e:ingredients (</xsl:text>
                     <xsl:apply-templates select="e:ing" />
         <xsl:text>
  );</xsl:text>
             </xsl:otherwise>
         </xsl:choose>
     </xsl:template>

<!-- ======================================================================

     item
     ====================================================================== -->

     <xsl:template match = "e:item">
         <xsl:text>e:foodstuff "</xsl:text>
         <xsl:value-of select = "." />
         <xsl:text>"; </xsl:text>
     </xsl:template>

<!-- ======================================================================

     menu
     ====================================================================== -->

     <xsl:template match = "e:menu">
         <xsl:message>menus are not currently supported.</xsl:message>
         <xsl:apply-templates select = "e:course" />
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
         <xsl:value-of select = "e:n/@value" /><xsl:text>M</xsl:text>
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
         <xsl:value-of select = "@value" />
     </xsl:template>

<!-- ======================================================================

     name
     ====================================================================== -->

     <xsl:template match = "e:name">
         <xsl:text>
  dc:title "</xsl:text>
         <xsl:value-of select = "e:common" />
         <xsl:text>"; </xsl:text>
         <xsl:if test="e:other">
             <xsl:text>
  dc:alternate "</xsl:text>
             <xsl:value-of select = "e:other" />
             <xsl:text>"; </xsl:text>
         </xsl:if>
     </xsl:template>

<!-- ======================================================================

     note
     ====================================================================== -->

     <xsl:template match = "e:note">
         <xsl:text>
    [a:content """</xsl:text>
         <xsl:apply-templates select = "e:para" />
         <xsl:text>"""; </xsl:text>
         <xsl:call-template name = "Authored" />
         <xsl:text>]</xsl:text>
         <!--<xsl:apply-templates select = "e:image" />-->
     </xsl:template>

<!-- ======================================================================

     notes
     ====================================================================== -->

     <xsl:template match = "e:notes">
         <xsl:if test="count(e:note)>0">
             <xsl:text>

  e:notes (</xsl:text>
  <xsl:apply-templates select = "e:note" />
  <xsl:text>
  );</xsl:text>
         </xsl:if>
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
         <!--<xsl:variable name="prev" select="count(parent::node()/previous-sibling)" />-->
         <xsl:variable name="next" select="count(parent::node()/following-sibling::*)" />

         <xsl:call-template name="wrap-string">
             <xsl:with-param name="str">
                 <xsl:value-of select = "normalize-space(.)" />
             </xsl:with-param>
             <xsl:with-param name="wrap-col" select="72" />
         </xsl:call-template>

         <xsl:if test="$next>0">
             <xsl:text>

</xsl:text>
         </xsl:if>

     </xsl:template>

<!-- ======================================================================

     publication
     ====================================================================== -->

     <xsl:template match = "e:publication">
       <xsl:text>
    dc:publication "</xsl:text>
       <xsl:value-of select = "e:name" />
       <xsl:text>"; </xsl:text>
       
        <xsl:if test="string(@xlink:href)">
            <xsl:text>
    dc:identifier "</xsl:text>
            <xsl:value-of select = "@xlink:href" />
            <xsl:text>"; </xsl:text>
        </xsl:if>           
     </xsl:template>

<!-- ======================================================================

     preparation
     ====================================================================== -->

     <xsl:template match = "e:preparation">
         <xsl:text>
    e:preparation "</xsl:text>
         <xsl:apply-templates />
         <xsl:text>"; </xsl:text>
     </xsl:template>

<!-- ======================================================================

     quantity
     ====================================================================== -->

     <xsl:template match = "e:quantity">

         <xsl:if test = "e:range/e:min or e:n/@value != ''">
             <xsl:text>e:amount "</xsl:text>
             <xsl:choose>
                 <xsl:when test="e:range">
                     <xsl:apply-templates select = "e:range" />
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:apply-templates select = "e:n" />
                 </xsl:otherwise>
             </xsl:choose>
             <xsl:text>"; </xsl:text>
         </xsl:if>
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
         <xsl:apply-templates select = "e:name" />
         <xsl:apply-templates select = "e:requirements" />
         <xsl:apply-templates select = "e:directions" />
         <xsl:apply-templates select = "e:yield" />
         <xsl:apply-templates select = "e:notes" />
         <xsl:apply-templates select = "e:history" />
         <xsl:apply-templates select = "e:source" />
     </xsl:template>

<!-- ====================================================================== 

     requirements
     ====================================================================== -->

     <xsl:template match = "e:requirements">
         <xsl:apply-templates select = "e:ingredients" />
         <xsl:apply-templates select = "e:equipment" />
         <xsl:apply-templates select = "e:time" />
     </xsl:template>

<!-- ====================================================================== 

     rev                                                     
     ====================================================================== -->

     <xsl:template match = "e:rev">
         <!--
         <h3><xsl:value-of select = "e:version" /></h3>
         <xsl:apply-templates select = "e:changes" />
         <xsl:call-template name = "Authored" />
         -->
     </xsl:template>

<!-- ====================================================================== 

     revhistory
     ====================================================================== -->

     <xsl:template match = "e:revhistory">
         <!--
         <div>
             <xsl:attribute name = "class">revhistory</xsl:attribute>
             <h2>Revision History</h2>
             <ul>
                 <xsl:for-each select = "e:rev">
                     <li><xsl:apply-templates select = "." /></li>
                 </xsl:for-each>
             </ul>
         </div>
         -->
     </xsl:template>

     <!-- ====================================================================== 

     source
     ====================================================================== -->

     <xsl:template match = "e:source">
         <xsl:text>

  dc:source [</xsl:text>
         <xsl:apply-templates select = "e:publication" />
         <xsl:apply-templates select = "e:author" />
         <xsl:text>
  ]; </xsl:text>
     </xsl:template>

<!-- ====================================================================== 

     stage
     ====================================================================== -->

     <xsl:template match = "e:stage">
         <xsl:choose>
             <xsl:when test = "xi:include">
                     <xsl:for-each select = "xi:include">
                         <xsl:comment>include...</xsl:comment>
                         <xsl:apply-templates select = "." />
                     </xsl:for-each>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:call-template name = "Steps" />
             </xsl:otherwise>
         </xsl:choose>
     </xsl:template>

<!-- ====================================================================== 

     time
     ====================================================================== -->

     <xsl:template match = "e:time">
         <xsl:text>

  e:time [</xsl:text>
        <xsl:apply-templates select = "e:preparation" />
        <xsl:apply-templates select = "e:cooking" />
        <xsl:text>
  ];</xsl:text>
     </xsl:template>

<!-- ====================================================================== 

     xi:fallback
     ====================================================================== -->

     <xsl:template match = "xi:fallback">
         <xsl:text>
      xi:fallback """</xsl:text>
         <xsl:apply-templates />
     <xsl:text>""";</xsl:text>
     </xsl:template>

<!-- ====================================================================== 

     xi:include
     ====================================================================== -->

     <xsl:template match = "xi:include">
         <xsl:variable name="doc" select="substring-before(@href, '#xmlns')" />
         <xsl:variable name="pointer" select="substring-after(@href, '#xmlns')" />

         <xsl:text>
     [xi:href "</xsl:text>
         <xsl:value-of select="$doc" />
         <xsl:text>";
      xi:xpointer "xmlns</xsl:text>
         <xsl:value-of select="$pointer" />
         <xsl:text>";</xsl:text>
         <xsl:apply-templates />
         <xsl:text>
      xi:parse "xml";
      a xi:include;]</xsl:text>
     </xsl:template>

<!-- ====================================================================== 

     yield
     ====================================================================== -->

     <xsl:template match = "e:yield">
         <xsl:text>

  e:yield [</xsl:text>

           <xsl:text>
    e:makes "</xsl:text>
           <xsl:apply-templates select="e:amount/e:quantity/child::node()" />
           <xsl:text> </xsl:text>
           <xsl:apply-templates select="e:amount/e:measure" />
           <xsl:text>"; </xsl:text>
       <xsl:text>
  ];</xsl:text>
     </xsl:template>

<!-- ====================================================================== 

     Authored
     ====================================================================== -->

     <xsl:template name = "Authored">
         <xsl:text>
    a:author "</xsl:text>
         <xsl:apply-templates select = "e:author" />
         <xsl:text>"; </xsl:text>
         <xsl:if test="dc:date">
             <xsl:text>
    dc:date "</xsl:text>             
             <xsl:apply-templates select = "dc:date" />
             <xsl:text>"; </xsl:text>
         </xsl:if>
     </xsl:template>
     
<!-- ====================================================================== 

     Steps
     ====================================================================== -->

     <xsl:template name = "Steps">
         <xsl:choose>
             <xsl:when test="count(xi:include)>0">
                 <xsl:apply-templates select = "." />
             </xsl:when>
             <xsl:otherwise>
                 <xsl:text>
    [a:content """</xsl:text>
         <xsl:for-each select = "e:step">
             <xsl:apply-templates select = "." />
       </xsl:for-each>
       <xsl:text>""";]</xsl:text>
             </xsl:otherwise>
         </xsl:choose>
     </xsl:template>

<!-- ======================================================================

     Adapted from : http://plasmasturm.org/log/204/
     ====================================================================== -->

<xsl:template name="wrap-string">
    <xsl:param name="str" />
    <xsl:param name="wrap-col" />
    <xsl:param name="pos" select="0" />
    <xsl:choose>
        <xsl:when test="contains( $str, ' ' )">
            <xsl:variable name="before" select="substring-before( $str, ' ' )" />
            <xsl:variable name="pos-now" select="$pos + string-length( $before )" />

            <xsl:choose>
                <xsl:when test="$pos = 0" />
                <xsl:when test="floor( $pos div $wrap-col ) != floor( $pos-now div $wrap-col )">
                    <xsl:text>
</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:value-of select="$before" />

            <xsl:call-template name="wrap-string">
                <xsl:with-param name="str" select="substring-after( $str, ' ' )" />
                <xsl:with-param name="wrap-col" select="$wrap-col" />
                <xsl:with-param name="pos" select="$pos-now" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if test="$pos > 0"><xsl:text> </xsl:text></xsl:if>
            <xsl:value-of select="$str" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ======================================================================
     FIN $Id: eatdrinkfeelgood-1.1-to-2.0a.xsl,v 1.4 2006/03/23 16:49:18 asc Exp $
     ====================================================================== -->

</xsl:stylesheet>
