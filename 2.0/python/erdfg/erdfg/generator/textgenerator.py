# -*-python-*-
# $Id: textgenerator.py,v 1.10 2007/12/26 01:52:44 asc Exp $

__package__    = "erdfg"
__version__    = "0.6"
__author__     = "Aaron Straup Cope"
__url__        = "http://www.aaronland.info/python/erdfg/"
__cvsversion__ = "$Revision: 1.10 $"
__date__       = "$Date: 2007/12/26 01:52:44 $"
__copyright__  = "Copyright (c) 2006 Aaron Straup Cope. Perl Artistic License."

from erdfg.generator.base import base
import textwrap
import codecs

class textgenerator (base) :

    def write_titles(self, titles, fh) :

        for t in titles :
            if t.has_key('title') :
                self.writeln_align_right(t['title'], fh)
                self.writeln_border(fh)

            elif t.has_key('alternative') :
                self.writeln_align_right(t['alternative'], fh)                

        fh.write("\n")
        
    #
    #
    #
    
    def write_subjects (self, subjects, fh) :
        self.writeln_border(fh)
        self.writeln_align_right(self.prepare("; ".join(subjects)), fh)

    #
    #
    #
    
    def write_stage (self, stage, fh) :
        self.writeln_border(fh)
        self.writeln_align_right(stage['title'], fh)
        self.writeln_border(fh)        

        self.write_ingredients(stage['ingredients'], fh)
        self.write_directions(stage['directions'], fh)        

    #
    #
    #
    
    def write_ingredients (self, list, fh) :
        self.write_label("ingredients", fh)

        for ing in list :

            if ing.has_key('content') :
                self.write_content(ing, fh)                
            elif ing.has_key('fallback') :
                self.write_xinclude(ing, fh)
            else :
                self.write(ing)
                self.write_ingredient(ing, fh)

        fh.write("\n")

    #
    #
    #

    def write_directions (self, list, fh) :
        self.write_label("directions", fh)

        for entry in list :
            if entry.has_key('fallback') :
                self.write_xinclude(entry, fh)
            else :
                self.write_content(entry, fh)

        fh.write("\n\n")

    #
    #
    #

    def write_notes (self, list, fh) :
        self.write_label("notes", fh)
        
        for entry in list :
            self.write_content(entry, fh)

        fh.write("\n\n")
    
    #
    #
    #

    def write_history (self, list, fh) :
        self.write_label("history", fh)

        for entry in list :
            self.write_content(entry, fh)

        fh.write("\n\n")

    #
    #
    #

    def write_yield (self, list, fh) :
        self.write_label("yield", fh)

        self.write_kv_pairs(list, fh)

        fh.write("\n")
        
    #
    #
    #
    
    def write_kv_pairs (self, dict, fh) :
        for k, v in dict.items() :
            fh.write(self.prepare("%s : %s" % (k.capitalize(), v)))
            fh.write("\n")
            
    #
    #
    #

    def write_time (self, times, fh) :
        self.write_label("time", fh)
        self.write_kv_pairs(times, fh)
        fh.write("\n")

    #
    #
    #

    def write_source (self, source, fh) :
        self.write_label("source", fh)
        self.write_kv_pairs(source, fh)
        fh.write("\n")
        
    #
    #
    #
    
    def write_ingredient (self, ing, fh) :
        fmt = "%s "
        str = ""

        for label in ('amount', 'measure', 'foodstuff', 'detail') :
            if ing.has_key(label) and not ing[label]==None :
                
                if label=='detail' :
                    fmt = u"(%s)"
                    
                str = str + fmt % ing[label]

        fh.write(self.prepare(str, u"* "))
        fh.write("\n")

    #
    #
    #

    def write_xinclude (self, xinclude, fh) :
        fh.write(self.prepare("Refer to : %s" % xinclude['fallback']))
        fh.write("\n")
        
    #
    #
    #
 
    def write_content (self, entry, fh) :

        for label in ('title', 'link', 'content', 'author', 'date') :
            if entry.has_key(label) and entry[label] != 'None' :

                if label == 'author' or label == 'date' :
                    fh.write("%s : " % label)
                             
                fh.write(self.prepare(entry[label]))
                fh.write("\n")
                
    #
    #
    #
    
    def write_label (self, label, fh) :
        fh.write(label.upper())
        fh.write(u"\n\n")

    #
    #
    #
    
    def prepare (self, txt, prefix="") :

        t = textwrap.TextWrapper()
        t.width = 72
        t.initial_indent = prefix

        newlines = "\n\n"
        parts    = []
                
        for p in txt.split(newlines) :
            parts.append(t.fill(p.strip()))

        return newlines.join(parts).encode("utf8")

    def writeln_border (self, fh) :
        fh.write("-" * 72 + "\n")
        
    def writeln_align_right (self, txt, fh) :
        fh.write((" " * (71 - len(txt.encode("utf8", "replace")))) + " " + txt.encode("utf8", "replace") + "\n")
