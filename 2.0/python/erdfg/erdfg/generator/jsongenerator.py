# -*-python-*-
# $Id: jsongenerator.py,v 1.1 2006/06/23 15:18:10 asc Exp $

__package__    = "erdfg"
__version__    = "0.6"
__author__     = "Aaron Straup Cope"
__url__        = "http://www.aaronland.info/python/erdfg/"
__cvsversion__ = "$Revision: 1.1 $"
__date__       = "$Date: 2006/06/23 15:18:10 $"
__copyright__  = "Copyright (c) 2006 Aaron Straup Cope. Perl Artistic License."

from erdfg.generator.base import base
import json
import codecs

class jsongenerator (base) :

    def write (self, fh) :
        
        str_json = json.write(self.data)

        if fh.encoding == 'US-ASCII' :
            str_json = str_json.encode('ascii', 'replace')
            
        fh.write(str_json)
