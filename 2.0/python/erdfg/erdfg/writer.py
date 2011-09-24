# -*-python-*-
# $Id: writer.py,v 1.14 2006/09/26 18:21:55 asc Exp $

__package__    = "erdfg"
__version__    = "0.6"
__author__     = "Aaron Straup Cope"
__url__        = "http://www.aaronland.info/python/erdfg/"
__cvsversion__ = "$Revision: 1.14 $"
__date__       = "$Date: 2006/09/26 18:21:55 $"
__copyright__  = "Copyright (c) 2006 Aaron Straup Cope. Perl Artistic License."

from sys import stdout
from erdfg.parser import parser
import xml

class writer (parser) :

    def __init__ (self, recipe, **kwargs) :
        parser.__init__ (self, recipe, **kwargs)

    #
    #
    #
    
    def text (self, fh=stdout) :
        T = self.do_import('erdfg.generator.textgenerator')
        t = T.textgenerator(self.collect_data())
        t.write(fh)

    #
    #
    #
    
    def xml (self, fh=stdout, format="edfg11") :
        X = self.do_import('erdfg.generator.xmlgenerator')
        x = X.xmlgenerator(self.collect_data())
        x.write(fh)

    #
    #
    #

    def json (self, fh=stdout) :
        J = self.do_import('erdfg.generator.jsongenerator')
        j = J.jsongenerator(self.collect_data())
        j.write(fh)
    
    #
    #
    #

    def erdfg (self, fh=stdout) :
        E = self.do_import('erdfg.generator.erdfggenerator')
        e = E.erdfggenerator(self.collect_data())
        e.write(fh)
    
    #
    #
    #

    def semediawiki (self, fh=stdout) :
        S = self.do_import('erdfg.generator.semediawikigenerator')
        s = S.semediawikigenerator(self.collect_data())
        s.write(fh)
    
    #
    #
    #

    def collect_data(self, label=None) :
        return self.dump()
    
        if label==None :
            return self.dump()
        else :
            return self.dump_core()

    #
    #
    #
    
    def do_import (self, name):
        mod = __import__(name)
        components = name.split('.')
        for comp in components[1:]:
            mod = getattr(mod, comp)
        return mod

if __name__ == "__main__" :
    print "writer.py"
