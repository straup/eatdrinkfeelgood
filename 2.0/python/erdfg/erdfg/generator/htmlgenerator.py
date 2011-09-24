# -*-python-*-
# $Id: htmlgenerator.py,v 1.1 2007/09/17 01:32:45 asc Exp $

__package__    = "erdfg"
__version__    = "0.6"
__author__     = "Aaron Straup Cope"
__url__        = "http://www.aaronland.info/python/erdfg/"
__cvsversion__ = "$Revision: 1.1 $"
__date__       = "$Date: 2007/09/17 01:32:45 $"
__copyright__  = "Copyright (c) 2006 Aaron Straup Cope. Perl Artistic License."

from erdfg.generator.base import base
from erdfg.constants.measurements import *
from erdfg.constants.xmlns import *

from sys import stdout

import re
import codecs
import urlparse
import textwrap

from xml.sax.saxutils import XMLGenerator, quoteattr
from xml.sax.xmlreader import AttributesNSImpl

class prettyprinter(XMLGenerator):

    def __init__ (self, fh=stdout, indent=4) :
        XMLGenerator.__init__(self, out=fh, encoding="utf8")

        self.__level  = 0
        self.__indent = indent
        self.__last   = None

    #
    #
    #
    
    def startElementNS(self, ns, el, attrs) :

        if not self.__level == 0 :
            self.ignorableWhitespace("\n")
            
        self.ignorableWhitespace(" " * (self.__level * self.__indent))
        # xml.sax.saxutils.XMLGenerator.startElementNS(self, ns, el, attrs)
        self._startElementNS(ns, el, attrs)        

        self.__level = self.__level + 1
        self.__last = "start"

    #
    # Copied straight out of saxutils.py and
    # modified not to prefix edfg attributes
    #
    
    def _startElementNS(self, name, qname, attrs):
        if name[0] is None:
            # if the name was not namespace-scoped, use the unqualified part
            name = name[1]
        else:
            # else try to restore the original prefix from the namespace
            name = self._current_context[name[0]] + ":" + name[1]
        self._write('<' + name)

        for pair in self._undeclared_ns_maps:
            self._write(' xmlns:%s="%s"' % pair)
        self._undeclared_ns_maps = []
            
        for (name, value) in attrs.items():
            if name[0] == NS_MAP['e'] :
                name = name[1]
            else :
                name = self._current_context[name[0]] + ":" + name[1]
            self._write(' %s=%s' % (name, quoteattr(value)))
        self._write('>')
        
    #
    #
    #
    
    def endElementNS(self, ns, el) :

        self.__level = self.__level - 1
        
        if self.__last == "end" :
            self.ignorableWhitespace("\n")

        if self.__last == 'end' :
            self.ignorableWhitespace(" " * (self.__level * self.__indent))
            
        XMLGenerator.endElementNS(self, ns, el)
        self.__last  = 'end'

    #
    #
    #
    
    def characters (self, chardata) :
        XMLGenerator.characters(self, chardata)
        self.__last = 'cdata'
        
#
#
#

class htmlgenerator (base) :

    def write (self, fh=stdout, format="html") :
        self.xml = prettyprinter(fh)        
        self.write_html()

    #
    #
    #
    
    def write_html (self) :

        for prefix, uri in NS_MAP.items() :
            self.xml.startPrefixMapping(prefix, uri)
        
        self.xml.startDocument()

        lang = {}
        
        if self.isset_notempty(self.data, 'language') :
            lang = AttributesNSImpl({(NS_MAP['x'], 'lang'):self.data['language']},
                                                       {});

        self.xml.startElementNS((NS_MAP['h'], 'html'), None, lang)

        self.write_head()
        self.write_body()
        
        self.xml.endElementNS((NS_MAP['h'], 'html'), None)        
        self.xml.endDocument()        

    #
    #
    #

    def write_head (self) :

        self.xml.startElementNS((NS_MAP['h'], 'head'), None, {})

        self.xml.startElementNS((NS_MAP['h'], 'title'), None, {})
        self.xmlcharacters("test")
        self.xml.endElementNS((NS_MAP['e'], 'title'), None)

        self.write_meta('viewport', 'width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;')
        self.write_style('iui/iui.css');
        self.write_script('iui/iui.js');        

        self.write_style('recipe.css');
        self.write_script('recipe.js');        
        self.write_script('measures.js');
        
        self.xml.endElementNS((NS_MAP['e'], 'head'), None)

    #
    #
    #

    def write_meta (self, name, content) :

        attrs = AttributesNSImpl({(NS_MAP['h'], 'name'):name,
                                  (NS_MAP['h'], 'content'):content},
                                  {});
        
        self.xml.startElementNS((NS_MAP['h'], 'meta'), None, attrs)
        self.xml.endElementNS((NS_MAP['e'], 'meta'), None)

    #
    #
    #

    def write_script (self, src) :

        attrs = AttributesNSImpl({(NS_MAP['h'], 'type'):'application/x-javascript',
                                  (NS_MAP['h'], 'src'):src},
                                  {});
        
        self.xml.startElementNS((NS_MAP['h'], 'script'), None, attrs)
        self.xml.characters(" ")
        self.xml.endElementNS((NS_MAP['e'], 'script'), None)

    #
    #
    #

    def write_style (self, src) :

        attrs = AttributesNSImpl({(NS_MAP['h'], 'type'):'text/css',
                                  (NS_MAP['h'], 'media'):'screen'},
                                  {});
        
        self.xml.startElementNS((NS_MAP['h'], 'style'), None, attrs)
        self.xml.characters("@import \"%s\";" % src)
        self.xml.endElementNS((NS_MAP['e'], 'style'), None)

    #
    #
    #
        
    def write_body (self) :

        self.xml.startElementNS((NS_MAP['h'], 'body'), None, {})

        self.write_toolbar()
        self.write_home()        
                    
        self.write_ingredients()
        self.write_directions()        

        if self.isset_notempty(self.data, 'notes') :
            self.write_notes(self.data['notes'])

        if self.isset_notempty(self.data, 'history') :
            self.write_histories(self.data['history'])

        self.xml.endElementNS((NS_MAP['h'], 'body'), None)

    #
    #
    #
    
    def write_toolbar (self) :

        tb_attrs = AttributesNSImpl({(NS_MAP['h'], 'class'):'toolbar'},
                                  {});

        title_attrs = AttributesNSImpl({(NS_MAP['h'], 'id'):'pageTitle'},
                                       {});
        
        back_attrs = AttributesNSImpl({(NS_MAP['h'], 'id'):'backButton',
                                       (NS_MAP['h'], 'class'):'button',
                                       (NS_MAP['h'], 'href'):'#'},
                                      {});
                                      
        self.xml.startElementNS((NS_MAP['h'], 'div'), None, tb_attrs)
        self.xml.startElementNS((NS_MAP['h'], 'h1'), None, title_attrs)
        self.xml.endElementNS((NS_MAP['h'], 'h1'), None)        
        self.xml.startElementNS((NS_MAP['h'], 'a'), None, back_attrs)        
        self.xml.endElementNS((NS_MAP['h'], 'a'), None)
        self.xml.endElementNS((NS_MAP['h'], 'div'), None)        

    #
    #
    #

    def write_home (self) :

        sects = {'ingredients' : 'Ingredients',
                 'directions' : 'Directions',
                 'stories' : 'Stories'}

        home_attrs = AttributesNSImpl({(NS_MAP['h'], 'id'):'home',
                                       (NS_MAP['h'], 'selected'):'true',
                                       (NS_MAP['h'], 'title'):'FIX ME'},
                                      {});

        self.xml.startElementNS((NS_MAP['h'], 'ul'), None, list_attrs)

        for id in sects :

            href = "#%s" % id
            
            home_attrs = AttributesNSImpl({(NS_MAP['h'], 'href'):href},
                                          {});

            self.xml.startElementNS((NS_MAP['h'], 'li'), None, {})
            self.xml.startElementNS((NS_MAP['h'], 'a'), None, link_attrs)            
            self.xml.characters(sects[id]);
            self.xml.endElementNS((NS_MAP['h'], 'a'), None)            
            self.xml.endElementNS((NS_MAP['h'], 'li'), None)
        
        self.xml.endElementNS((NS_MAP['h'], 'ul'), None)        

    #
    #
    #

    def write_titles (self, titles) :
        self.xml.startElementNS((NS_MAP['e'], 'name'), None, {})

        for t in titles :
            
            if t.has_key('title') :
                self.xml.startElementNS((NS_MAP['e'], 'common'), None, {})        
                self.xml.characters(t['title'])
                self.xml.endElementNS((NS_MAP['e'], 'common'), None)

            elif t.has_key('alternative') :
                attrs = {}

                if t.has_key('language') :
                    attrs = AttributesNSImpl({(NS_MAP['x'], 'lang'):t['language']},
                                                               {});
                    
                self.xml.startElementNS((NS_MAP['e'], 'other'), None, attrs)        
                self.xml.characters(t['alternative'])
                self.xml.endElementNS((NS_MAP['e'], 'other'), None)

        self.xml.endElementNS((NS_MAP['e'], 'name'), None)

    #
    #
    #
    
    def write_name (self, name, other=[]) :
        self.xml.startElementNS((NS_MAP['e'], 'name'), None, {})
        self.xml.startElementNS((NS_MAP['e'], 'common'), None, {})        
        self.xml.characters(name)
        self.xml.endElementNS((NS_MAP['e'], 'common'), None)

        for next in other :
            self.xml.startElementNS((NS_MAP['e'], 'other'), None, {})        
            self.xml.characters(next)
            self.xml.endElementNS((NS_MAP['e'], 'other'), None)

        self.xml.endElementNS((NS_MAP['e'], 'name'), None)

    #
    #
    #

    def write_yield (self, yields) :

        self.xml.startElementNS((NS_MAP['e'], 'yield'), None, {})
            
        for k, v in yields.items() :

            self.xml.startElementNS((NS_MAP['e'], 'amount'), None, {})

            self.xml.startElementNS((NS_MAP['e'], 'measure'), None, {})
            self.xml.startElementNS((NS_MAP['e'], 'customunit'), None, {})
            self.xml.characters(v)

            self.xml.endElementNS((NS_MAP['e'], 'customunit'), None)
            self.xml.endElementNS((NS_MAP['e'], 'measure'), None)
            self.xml.endElementNS((NS_MAP['e'], 'amount'), None)

        self.xml.endElementNS((NS_MAP['e'], 'yield'), None)

    #
    #
    #
    
    def write_source (self, source) :
        self.xml.startElementNS((NS_MAP['e'], 'source'), None, {})

        if self.isset_notempty(source, 'publication') :

            xlink = {}

            if self.isset_notempty(source, 'identifier') :
                scheme, netloc, path, params, query, fragment = urlparse.urlparse(source['identifier'])
                    
                if not scheme == '' :
                    xlink = AttributesNSImpl({(NS_MAP['xlink'], 'href'):source['identifier']}, {});

            self.xml.startElementNS((NS_MAP['e'], 'publication'), None, xlink)
            self.write_name(source['publication'])
            self.xml.endElementNS((NS_MAP['e'], 'publication'), None)
                    
        if self.isset_notempty(source, 'author') :
            self.write_author(source['author'])

        if self.isset_notempty(source, 'date') :
            self.write_author(source['date'])

        self.xml.endElementNS((NS_MAP['e'], 'source'), None)
        
    #
    #
    #
    
    def write_core (self) :

        if self.isset_notempty(self.data, 'stages') :
            self.xml.startElementNS((NS_MAP['e'], 'requirements'), None, {})

            if self.isset_notempty(self.data, 'time') :
                self.write_times(self.data['time'])

            if self.isset_notempty(self.data, 'equipment') :
                self.write_equipment(self.data['equipment'])
            
            self.xml.startElementNS((NS_MAP['e'], 'ingredients'), None, {})
            
            for s in self.data['stages'] :
                self.xml.startElementNS((NS_MAP['e'], 'set'), None, {})
                self.write_name(s['title'])

                for ing in s['ingredients'] :
                    self.write_ingredient(ing)
                    
                self.xml.endElementNS((NS_MAP['e'], 'set'), None)
                
            self.xml.endElementNS((NS_MAP['e'], 'ingredients'), None)
            self.xml.endElementNS((NS_MAP['e'], 'requirements'), None)
            
            self.xml.startElementNS((NS_MAP['e'], 'directions'), None, {})
            
            for s in self.data['stages'] :
                self.xml.startElementNS((NS_MAP['e'], 'stage'), None, {})
                self.write_name(s['title'])

                for d in s['directions'] :
                    self.write_direction(d)
                    
                self.xml.endElementNS((NS_MAP['e'], 'stage'), None)
                
            self.xml.endElementNS((NS_MAP['e'], 'directions'), None)
            
        else :
            self.xml.startElementNS((NS_MAP['e'], 'requirements'), None, {})

            if self.isset_notempty(self.data, 'time') :
                self.write_times(self.data['time'])

            if self.isset_notempty(self.data, 'equipment') :
                self.write_equipment(self.data['equipment'])

            self.write_ingredients(self.data['ingredients'])
            self.xml.endElementNS((NS_MAP['e'], 'requirements'), None)
        
            self.write_directions(self.data['directions'])

    #
    #
    #

    def write_equipment (self, list) :
        self.xml.startElementNS((NS_MAP['e'], 'equipment'), None, {})
        for d in list['devices'] :
            self.write_device(d)
        self.xml.endElementNS((NS_MAP['e'], 'equipment'), None)      

    #
    #
    #

    def write_item (self, item) :
        self.xml.startElementNS((NS_MAP['e'], 'item'), None, {})
        self.xml.characters(item)
        self.xml.endElementNS((NS_MAP['e'], 'item'), None)        

    #
    #
    #
    
    def write_detail (self, detail) :
        self.xml.startElementNS((NS_MAP['e'], 'detail'), None, {})
        self.xml.characters(detail)
        self.xml.endElementNS((NS_MAP['e'], 'detail'), None)        
        
    #
    #
    #
    
    def write_device (self, device) :

        if self.isset_notempty(device, 'quantity') :
            self.write_quantity(device['quantity'])

        self.write_item(device['item'])

        if self.isset_notempty(device, 'detail') :
            self.write_detail(device['detail'])

        # image
        
    #
    #
    #

    def write_times(self, times) :

        test = ('prep', 'preparation', 'cooking')
        ok   = 0
        
        for key in test :
            if self.isset_notempty(times, key) :
                ok = 1
                break

        if not ok :
            return
        
        self.xml.startElementNS((NS_MAP['e'], 'time'), None, {})

        if self.isset_notempty(times, 'prep') :
                self.write_time('preparation', times['prep'])

        elif self.isset_notempty(times, 'preparation') :
                self.write_time('preparation', times['preparation'])

        if self.isset_notempty(times, 'cooking') :
                self.write_time('cooking', times['cooking'])
            
        self.xml.endElementNS((NS_MAP['e'], 'time'), None)

    #
    #
    #
    
    def write_time(self, label, duration) :
            
        parts = self.parse_duration(duration)
        
        self.xml.startElementNS((NS_MAP['e'], label), None, {})

        for k, v in parts.items() :
            self.xml.startElementNS((NS_MAP['e'], k), None, {})
            self.write_n(v)
            self.xml.endElementNS((NS_MAP['e'], k), None)
            
        self.xml.endElementNS((NS_MAP['e'], label), None)
        
    #
    #
    #
    
    def write_ingredients (self, list) :

        self.xml.startElementNS((NS_MAP['e'], 'ingredients'), None, {})

        for ing in list :
            self.write_ingredient(ing)
            
        self.xml.endElementNS((NS_MAP['e'], 'ingredients'), None)

    #
    #
    #
    
    def write_ingredient (self, ing) :

        if self.isset_notempty(ing, 'fallback') :
            self.write_xinclude(ing)
            return

        #
        #
        #
        
        self.xml.startElementNS((NS_MAP['e'], 'ing'), None, {})

        if self.isset_notempty(ing, 'amount') :

            self.xml.startElementNS((NS_MAP['e'], 'amount'), None, {})
            self.write_quantity(ing['amount'])
        
            if self.isset_notempty(ing, 'measure') :
                self.xml.startElementNS((NS_MAP['e'], 'measure'), None, {})

                if self.is_custom_unit(ing['measure']) :
                    self.xml.startElementNS((NS_MAP['e'], 'customunit'), None, {})
                    self.xml.characters(ing['measure'])
                    self.xml.endElementNS((NS_MAP['e'], 'customunit'), None)
                else :
                    unit = self.expand_unit(ing['measure'])
                    self.xml.startElementNS((NS_MAP['e'], 'unit'), None, self.edfg_attrs({'content':unit}))
                    self.xml.endElementNS((NS_MAP['e'], 'unit'), None)
                    
                self.xml.endElementNS((NS_MAP['e'], 'measure'), None)

            self.xml.endElementNS((NS_MAP['e'], 'amount'), None)

        self.write_item(ing['foodstuff'])
        
        if self.isset_notempty(ing, 'detail') :
            self.write_detail(ing['detail'])

        self.xml.endElementNS((NS_MAP['e'], 'ing'), None)

    #
    #
    #

    def write_quantity (self, q) :
        self.xml.startElementNS((NS_MAP['e'], 'quantity'), None, {})
        self.write_n(q)
        self.xml.endElementNS((NS_MAP['e'], 'quantity'), None)

    #
    #
    #
    
    def write_n (self, n) :
        self.xml.startElementNS((NS_MAP['e'], 'n'), None, self.edfg_attrs({'value':n}))
        self.xml.endElementNS((NS_MAP['e'], 'n'), None)
        
    #
    #
    #
    
    def write_directions (self, list) :

        self.xml.startElementNS((NS_MAP['e'], 'directions'), None, {})

        for step in list :
            self.write_direction(step)
            
        self.xml.endElementNS((NS_MAP['e'], 'directions'), None)        

    #
    #
    #

    def write_direction (self, step) :

        if self.isset_notempty(step, 'fallback') :
            self.write_xinclude(step)
            return
        
        self.xml.startElementNS((NS_MAP['e'], 'step'), None, {})
        self.write_paras(step['content'])        
        self.xml.endElementNS((NS_MAP['e'], 'step'), None)        

    #
    #
    #

    def write_notes (self, list) :

        self.xml.startElementNS((NS_MAP['e'], 'notes'), None, {})

        for step in list :
            self.write_note(step)
            
        self.xml.endElementNS((NS_MAP['e'], 'notes'), None)        

    #
    #
    #
    
    def write_note (self, note) :
        self.xml.startElementNS((NS_MAP['e'], 'note'), None, {})
        self.write_paras(note['content'])

        if self.isset_notempty(note, 'author') :
            self.write_author(note['author'])

        if self.isset_notempty(note, 'date') :
            self.write_date(note['date'])

        self.xml.endElementNS((NS_MAP['e'], 'note'), None)        

    #
    #
    #

    def write_histories (self, list) :
        for hist in list :
            self.write_history(hist)

    #
    #
    #
    
    def write_history (self, history) :
        self.xml.startElementNS((NS_MAP['e'], 'history'), None, {})

        #
        
        if self.is_image(history) :
            self.write_image(history)
        else :

            if self.isset_notempty(history, 'title') :
                self.write_paras(history['title'])

            if self.isset_notempty(history, 'link') :
                self.write_paras(history['link'])

            if self.isset_notempty(history, 'content') :                
                self.write_paras(history['content'])

        #
        
        if self.isset_notempty(history, 'author') :
            self.write_author(history['author'])

        if self.isset_notempty(history, 'date') :
            self.write_date(history['date'])
            
        self.xml.endElementNS((NS_MAP['e'], 'history'), None)
        
    #
    #
    #

    def write_author (self, author) :
        self.xml.startElementNS((NS_MAP['e'], 'author'), None, self.edfg_attrs({'content-type':'text'}))
        self.write_extref('#', author)
        self.xml.endElementNS((NS_MAP['e'], 'author'), None)

    #
    #
    #
    
    def write_extref (self, link, title) :

        pattern = re.compile("\[\[(.*)\]\[(.*)\]\]")
        matches = pattern.findall(title)

        if len(matches) :
            link  = matches[0][0]
            title = matches[0][1]            
            
        attrs = AttributesNSImpl({(NS_MAP['xlink'], 'href'):link,
                                  (NS_MAP['xlink'], 'title'):title},
                                 {});
        
        self.xml.startElementNS((NS_MAP['e'], 'extref'), None, attrs)
        self.xml.endElementNS((NS_MAP['e'], 'extref'), None)
        
    #
    #
    #

    def write_date(self, date) :
        self.xml.startElementNS((NS_MAP['dc'], 'date'), None, {})
        self.xml.characters(date.strip())
        self.xml.endElementNS((NS_MAP['dc'], 'date'), None)
        
    #
    #
    #

    def write_xinclude (self, xinclude) :

        href = "%s#%s" % (xinclude['href'], xinclude['xpointer'])

        attrs = AttributesNSImpl({(NS_MAP['xi'], 'href'):href}, {});
        
        self.xml.startElementNS((NS_MAP['xi'], 'include'), None, attrs)
        self.xml.startElementNS((NS_MAP['xi'], 'fallback'), None, {})

        pattern = re.compile("\[\[(.*)\]\[(.*)\]\]")
        matches = pattern.findall(xinclude['fallback'])
        
        if len(matches) :
            link  = matches[0][0]
            title = matches[0][1]
            self.write_extref(link, title)
        else :
            self.xml.characters(xinclude['fallback'])

        self.xml.endElementNS((NS_MAP['xi'], 'fallback'), None)        
        self.xml.endElementNS((NS_MAP['xi'], 'include'), None)

    #
    #
    #

    def write_wtf (self, wtf) :

        self.xml.startElementNS((NS_MAP['e'], 'wtf'), None, {})
        self.xml.characters(wtf)
        self.xml.endElementNS((NS_MAP['e'], 'wtf'), None)

    def write_paras (self, text) :
        for para in text.split("\n\n") :
            para = para.strip()

            if not para == '' :
                self.xml.startElementNS((NS_MAP['e'], 'para'), None, {})
                self.xml.characters(para)
                self.xml.endElementNS((NS_MAP['e'], 'para'), None)
        
    #
    #
    #

    def is_image (self, node) :

        if not self.isset_notempty(node, 'type') :
            return False

        pattern = re.compile("image\/")

        if not pattern.match(node['type']) :
            return False

        return True

    #
    #
    #

    def write_image (self, image) :
        
        attrs = AttributesNSImpl({(NS_MAP['e'], 'rel'):'photo',
                                  (NS_MAP['e'], 'content-type'):image['type']},
                                 {});

        self.xml.startElementNS((NS_MAP['e'], 'image'), None, attrs)

        pattern = re.compile("data:image/(?:gif|jpg|png);base64,(.*)")
        match   = pattern.match(image['content'])
        
        if not match == 'None' :
            parts = pattern.findall(image['content'])
            
            self.xml.startElementNS((NS_MAP['e'], 'bin64b'), None, {})
            self.xml.characters(parts[0])
            self.xml.endElementNS((NS_MAP['e'], 'bin64b'), None)
        else :
            # contentor something else?
            self.write_extref(image['content'], '')
        
        self.xml.endElementNS((NS_MAP['e'], 'image'), None)
        
    #
    #
    #
    
    def edfg_attrs (self, attrs) :
        ns_attrs = {}
        qnames = {}
        
        for k, v in attrs.items() :
            ns_attrs[(NS_MAP['e'], k)] = v

        return AttributesNSImpl(ns_attrs, qnames);

    #
    #
    #
    
    def is_custom_unit (self, unit) :

        if unit in USIMP_UNITS :
            return False

        if unit in USIMP_ABBREV.keys() :
            return False

        if unit in METRIC_UNITS :
            return False

        if unit in METRIC_ABBREV.keys() :
            return False

        return True

    #
    #
    #

    def expand_unit (self, unit) :

        if METRIC_ABBREV.has_key(unit) :
            return METRIC_ABBREV[unit]

        if USIMP_ABBREV.has_key(unit) :
            return USIMP_ABBREV[unit]
        
        return unit

