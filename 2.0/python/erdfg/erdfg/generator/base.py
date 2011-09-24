# -*-python-*-
# $Id: base.py,v 1.15 2007/12/26 01:52:44 asc Exp $

__package__    = "erdfg"
__version__    = "0.6"
__author__     = "Aaron Straup Cope"
__url__        = "http://www.aaronland.info/python/erdfg/"
__cvsversion__ = "$Revision: 1.15 $"
__date__       = "$Date: 2007/12/26 01:52:44 $"
__copyright__  = "Copyright (c) 2006 Aaron Straup Cope. Perl Artistic License."

import types
import re

class base :

    def __init__ (self, data) :
        self.data = data                

    #
    #
    #

    def write (self, fh) :

        self.write_header(fh)

        # fh.write("%s" % self.data)
        
        if self.has_property('title') :
            self.write_titles(self.data['title'], fh)
            
        if self.has_property('stages') :
            for stage in self.data['stages'] :
                self.write_stage(stage, fh)
        else :
            self.write_ingredients(self.data['ingredients'], fh)
            self.write_directions(self.data['directions'], fh)

        if self.has_property('notes') :
            self.write_notes(self.data['notes'], fh)        

        if self.has_property('time') :
            self.write_time(self.data['time'], fh)        

        if self.has_property('yield') :
            self.write_yield(self.data['yield'], fh)        

        if self.has_property('history') :
            self.write_history(self.data['history'], fh)        

        if self.has_property('source') :
            self.write_source(self.data['source'], fh)        

        if self.has_property('subject') :
            self.write_subjects(self.data['subject'], fh)

        self.write_footer(fh)
        
    #
    #
    #

    def write_header (*args) :
        pass

    def write_footer (*args) :
        pass

    def write_title (*args) :
        pass

    def write_subjects (*args) :
        pass
    
    #
    #
    #

    def has_property (self, label) :
        
        if not self.data.has_key(label) :
            return False

        if self.data[label]==None :
            return False
        
        if not len(self.data[label]) :
            return False
            
        return True    

    #
    #
    #
    
    def isset_notempty (self, dict, key) :

        if not dict.has_key(key) :
            return False

        if dict[key] == None :
            return False

        if len(dict.keys()) == 0 :
            return False
        
        if type(dict[key]) == types.ListType :
            if len(dict[key]) == 0 :
                return False

        if type(dict[key]) == types.DictType :
            if len(dict[key].keys()) == 0 :
                return False
        
        return True

    #
    #
    #
    
    def parse_duration (self, duration) :

        pattern = re.compile("((\d+)(H|M|S))")
        parts   = {}

        for res in pattern.findall(duration) :                
            if res[2] == 'H' and not parts.has_key('hours') :
                parts['hours'] = res[1]
            elif res[2] == 'M' and not parts.has_key('minutes') :
                parts['minutes'] = res[1]
            elif res[2] == 'S' and not parts.has_key('seconds') :
                parts['seconds'] = res[1]

        return parts
