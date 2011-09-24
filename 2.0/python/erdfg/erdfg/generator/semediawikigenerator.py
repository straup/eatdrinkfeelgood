# -*-python-*-
# $Id: semediawikigenerator.py,v 1.4 2006/09/30 20:16:30 asc Exp $

__package__    = "erdfg"
__version__    = "0.5"
__author__     = "Aaron Straup Cope"
__url__        = "http://www.aaronland.info/python/erdfg/"
__cvsversion__ = "$Revision: 1.4 $"
__date__       = "$Date: 2006/09/30 20:16:30 $"
__copyright__  = "Copyright (c) 2006 Aaron Straup Cope. Perl Artistic License."

from erdfg.generator.base import base
import textwrap
import codecs

class semediawikigenerator (base) :

    #
    #
    #

    def write_footer (self, fh) :
        fh.write("{{recipe|lang=%s}}\n\n" % self.data['language'])

    #
    #
    #
              
    def write_titles(self, titles, fh) :

        for t in titles :
            if t.has_key('title') :
                self.write_smw_header("Name", fh)
                fh.write("%s\n\n" % self.template_title(t))
            elif t.has_key('alternative') :
                fh.write("%s\n\n" % self.template_alttitle())
        
    #
    #
    #
    
    def write_subjects (self, subjects, fh) :
        self.write_smw_header("Tags", fh)
        fh.write("%s\n\n" % self.template_tags(subjects))

    #
    #
    #
    
    def write_stage (self, stage, fh) :
        self.write_smw_header(stage['title'], fh)

        self.write_ingredients(stage['ingredients'], fh)
        self.write_directions(stage['directions'], fh)        
    
    #
    #
    #
    
    def write_ingredients (self, list, fh) :
        self.write_smw_header("Ingredients", fh)        

        for ing in list :
            if ing.has_key('fallback') :
                # fix me
                pass
            else :            
                self.write_ingredient(ing, fh)

        fh.write("\n")

    #
    #
    #

    def write_ingredient (self, ing, fh) :
        fmt = u"%s "
        str = ""

        for label in ('amount', 'measure', 'foodstuff', 'detail') :
            if ing.has_key(label) and ing[label] != 'None' :

                # fix me : custom measures
                
                if label=='measure' :
                    fmt = u"{{%s}} "
                elif label=='foodstuff' :
                    fmt = u"{{ing|%s}} "
                else :
                    fmt = u"%s "                    

                part  = fmt % ing[label]
                str  += part

        self.write_bullet(str, fh)

    #
    #
    #

    def write_directions (self, list, fh) :
        self.write_smw_header("Directions", fh)

        for entry in list :
            if entry.has_key('fallback') :
                # fix me
                pass
            else :
                self.write_content(entry, True, fh)

    #
    #
    #

    def write_notes (self, list, fh) :
        fh.write_smw_header("Notes", fh)
        
        for entry in list :
            self.write_content(entry, False, fh)
    
    #
    #
    #

    def write_history (self, list, fh) :
        self.write_smw_header("History", fh)

        for entry in list :
            self.write_content(entry, False, fh)

    #
    #
    #

    def write_yield (self, list, fh) :
        self.write_label("Yield", fh)        
        self.write_kv_pairs(list, fh)
        
    #
    #
    #
    
    def write_kv_pairs (self, dict, fh) :
        for k, v in dict.items() :
            fh.write("{{%s|%s}}\n\n" % (k, v))
            
    #
    #
    #

    def write_time (self, times, fh) :
        self.write_smw_header("Time", fh)        
        self.write_kv_pairs(times, fh)

    #
    #
    #

    def write_source (self, source, fh) :
        self.write_smw_header("Source", fh)
        
        self.write_kv_pairs(source, fh)
        
    #
    #
    #
    
    def write_xinclude (self, xinclude, fh) :
        # fix me
        pass
        
    #
    #
    #
 
    def write_content (self, entry, bullets, fh) :

        head = ""

        if entry.has_key('title') and not entry['title'] == 'None' :
            head = entry['title']

        if entry.has_key('author') and not entry['author'] == 'None' :
            head = "%s (%s)" % (head, self.template_author(entry['author']))

        if head != "" :
            self.write_smw_subheader(head, fh)
            
        # fix me : date

        for p in entry['content'].split("\n\n") :
            if bullets :
                self.write_bullet(p, fh)
                fh.write("\n")
            else :
                self.write_para(p, fh)

    #
    #
    #
    
    def write_smw_header (self, header, fh) :
        fh.write("= %s =\n\n" % header)

    #
    #
    #
    
    def write_smw_subheader (self, header, fh) :
        # fh.write("== %s ==\n\n" % header)
        pass
    
    #
    #
    #
    
    def write_bullet (self, ln, fh) :
        fh.write("* %s\n" % ln)

    #
    #
    #
    
    def write_para (self, txt, fh) :
        fh.write("%s\n\n" % txt)
        
    #
    #
    #

    def template_author (self, author) :
        return "{{author|%s}}" % author

    #
    #
    #
    
    def template_title (self, t) :
        txt = t['title']

        if t.has_key('alternative') :
            txt = "%s|%s" % (txt, t['alternative'])
            
        return "{{title|%s}}" % txt

    #
    #
    #
    
    def template_alttitle (self, title) :
        return "{{alttitle|%s}}" % title

    #
    #
    #
    
    def template_tags (self, tags) :
        return "{{tags|%s}}" % "; ".join(tags)
