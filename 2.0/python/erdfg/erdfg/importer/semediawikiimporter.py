# -*-python-*-
# $Id: semediawikiimporter.py,v 1.4 2006/10/01 01:27:40 asc Exp $

__package__    = "erdfg"
__version__    = "0.5"
__author__     = "Aaron Straup Cope"
__url__        = "http://www.aaronland.info/python/erdfg/"
__cvsversion__ = "$Revision: 1.4 $"
__date__       = "$Date: 2006/10/01 01:27:40 $"
__copyright__  = "Copyright (c) 2006 Aaron Straup Cope. Perl Artistic License."

from erdfg.constants.measurements import *
from erdfg.importer.base import base

import re

class semediawikiimporter (base) :

    #
    #
    #

    def parse (self) :

        try :
            fh = open(self.input)
        except Exception, e :
            return None
        
        for ln in fh.readlines() :
            self.parse_line(ln)

        return self.build_model()

    #
    #
    #

    def parse_line (self, ln) :
        ln = ln.strip()

        if ln == '' :
            return

        elif ln.startswith("=") :
            self.parse_context_indicator(ln)

        elif ln.startswith("{") :
            self.parse_template_indicator(ln)

        elif ln.startswith("*") :
            self.parse_bulletpoint(ln)
            
        else :
            self.parse_default(ln)
        
    #
    #
    #
    
    def parse_context_indicator (self, ln) :
        m = re.search("^(=+)\s*(.*)\s*=+$", ln)
        
        if not m :
            return False

        gr    = m.groups()
        level = len(gr[0])
        label = gr[1].lower()

        if level == 1 :
            self.context = label
            
        #
            
        if label.startswith('note') :

            self.data['notes'].append(self.stub_content_element())
            
            if level == 2 and self.note_idx > 0 :
                self.note_idx += 1
                    
        if label.startswith('history') :

            self.data['history'].append(self.stub_content_element())
            
            if level == 2 and self.history_idx > 0 :
                self.history_idx += 1

    #
    #
    #
    
    def stub_content_element (self) :
        return {'content':[], 'author':'', 'date':''}
    
    #
    #
    #

    def parse_template_indicator (self, ln) :

        m = re.search("^{{(.*)}}$", ln)

        if not m:
            return None

        gr    = m.groups()
        parts = gr[0].split("|")

        template = parts[0]
        args     = parts[1:]

        return self.render_template(template, args)

    #
    #
    #

    def parse_bulletpoint (self, ln) :

        if self.context.startswith('ingredient') :
            self.parse_ingredient(ln)

        elif self.context.startswith('direction') :
            self.parse_direction(ln)
        
        else :
            pass

    #
    #
    #
    
    def parse_default (self, ln) :

        if self.context.startswith('note') :
            self.parse_note(ln)
            
        elif self.context.startswith('history') :
            self.parse_history(ln)
            
        else :
            pass
        
    #
    #
    #

    def parse_ingredient (self, ln) :

        m = re.search("^\*\s+([^{]+)(?:{{([^}]+)}}\s+)?{{(ing\|[^}]+)}}(.*)", ln)
        
        if not m :
            return False

        parts = []
        
        for el in m.groups() :
            if el :
                parts.append(el.strip())

        parts.reverse()

        amount    = ''
        measure   = ''
        foodstuff = ''
        detail    = ''

        #
        
        if parts[0].startswith("ing|") :
            foodstuff = self.parse_ingredient_shortname(parts[0])
        else :
            foodstuff = self.parse_ingredient_shortname(parts[1])
            detail    = parts[0]
            
        #
        
        if len(parts) == 4 :
            measure = self.parse_measure_shortname(parts[2])
            amount  = parts[3]

        elif len(parts) == 3 :
            measure = self.parse_measure_shortname(parts[1])
            amount  = parts[2]            

        else :
            if parts[1].isdigit() :
                amount = parts[1]
                
            elif re.search("(?:[\d\/\.-]+)", parts[1]) :
                amount = parts[1]
                
            else :
                measure = self.parse_measure_shortname(parts[1])
                
        #

        self.data['ingredients'].append({'amount':amount, 'measure':measure,
                                         'foodstuff':foodstuff, 'detail':detail})

    #
    #
    #
    
    def parse_direction (self, ln) :
        self.data['directions'].append(ln)

    #
    #
    #
    
    def parse_history (self, ln) :
        self.data['history'][self.history_idx]['content'].append(ln)
        
    #
    #
    #

    def parse_note (self, ln) :
        self.data['notes'][self.note_idx]['content'].append(ln)
        
    #
    #
    #

    def parse_ingredient_shortname (self, ing) :
        return ing.split("|")[1]
        
    #
    #
    #
    
    def parse_measure_shortname (self, measure) :
        return measure
    
    #
    #
    #
    
    def render_template (self, template, args) :

        if template == 'title' :
            self.render_template_title(args)

        elif template == 'tags' :
            self.render_template_tags(args)            

        elif template == 'makes' :
            self.render_template_yields(template, args)

        elif template == 'serves' :
            self.render_template_yields(template, args)

        elif template == 'preptime' :
            self.render_template_times(template, args)

        elif template == 'cooktime' :
            self.render_template_times(template, args)

        elif template == 'author' :
            self.render_template_author(args)

        elif template == 'publication' :
            self.render_template_publication(args)

        elif template == 'recipe' :
            self.render_template_recipe(args)


        else :

            #
            # ingredient and measurement
            # templates are handled separately
            #
            
            pass

    #
    #
    #
    
    def render_template_title (self, args) :

        self.data['title'].append(args[0])

        if len(args) > 1 :
            self.data['alternative'] = args[1:]

    #
    #
    #
    
    def render_template_tags (self, args) :
        self.data['subject'] = args

    #
    #
    #

    def render_template_yields (self, property, args) :
        self.data['yield'][property] = args[0]

    #
    #
    #

    def render_template_times (self, property, args) :

        label = 'cooking'
        
        if property == 'preptime' :
            label = 'preparation'
        
        self.data['times'][label] = args[0]

    #
    #
    #
    
    def render_template_author (self, args) :
        cnt = len(args)

        author = ''
        
        if cnt == 1 :
            author = args[0]
            
        elif cnt == 2 :
            link  = "#%s" % args[0]
            label = args[1]

            author = "[[%s][%s]]" % (link, label)
            
        elif cnt == 3 :
            link  = args[1]
            label = args[2]

            author = "[[%s][%s]]" % (link, label)
            
        else :
            pass

        #
        
        if self.context.startswith('note') :
            self.data['notes'][self.note_idx]['author'] = author

        elif self.context.startswith('history') :
            self.data['history'][self.note_idx]['author'] = author
            
        #
        
        return author
    
    #
    #
    #

    def render_template_publication (self, args) :
        self.data['source']['publication'] = args[0]

    #
    #
    #

    def render_template_recipe (self, args) :
        # uh...        
        pass

#
#
#

if __name__ == "__main__" :

    import sys
    i = semediawikiimporter(sys.argv[1])
    d = i.parse()

    print d
    
