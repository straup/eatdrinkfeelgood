# -*-python-*-
# $Id: parser.py,v 1.22 2007/12/26 01:52:44 asc Exp $

__package__    = "erdfg"
__version__    = "0.6"
__author__     = "Aaron Straup Cope"
__url__        = "http://www.aaronland.info/python/erdfg/"
__cvsversion__ = "$Revision: 1.22 $"
__date__       = "$Date: 2007/12/26 01:52:44 $"
__copyright__  = "Copyright (c) 2006 Aaron Straup Cope. Perl Artistic License."

from erdfg.constants.xmlns import *

from rdflib import Graph
from rdflib import Namespace
from rdflib import RDF
from rdflib.sparql import sparqlGraph
from rdflib.compat import rsplit
    
import tempfile
import codecs
import os
import urllib2
import types
from urlparse import urlparse, urljoin
     
RDF      = Namespace(NS_MAP['rdf'])
ERDFG    = Namespace(NS_MAP['er'])
ATOM     = Namespace(NS_MAP['a'])
DC       = Namespace(NS_MAP['dc'])
XINCLUDE = Namespace(NS_MAP['xi'])

#
#
#

class parser :

     def __init__ (self, recipe=None, **kwargs) :

          self.__graph       = None
          
          self.__ingredients = []
          self.__directions  = []
          self.__notes       = []
          self.__stages      = []
          
          if not recipe and kwargs['model'] :
               self.__load_model(kwargs['model'])
               return
          
          gr = self.__parse(recipe, **kwargs)
          self.__graph = gr

     #
     #
     #
     
     def __load_model (self, model) :

          self.__ingredients = model['ingredients']
          self.__directions  = model['directions']
          self.__notes       = model['notes']
          self.__stages      = model['stages']
          
     #
     # Grrrrr - fix me
     #
     
     def __parse(self, recipe, **kwargs) :
          gr = Graph()
          gr.load(recipe, format="n3");

          self.__graph = gr
          
          if kwargs.has_key('xinclude') and kwargs['xinclude'] == 1:
               self.merge_xinclude()

          return gr
                    
     #
     #
     #

     def merge_xinclude (self) :

          xi = self.__graph.subjects(RDF["type"], XINCLUDE["include"])

          for o in xi :
               src      = self.__graph.objects(o, XINCLUDE["href"]).next()
               fallback = self.__graph.objects(o, XINCLUDE["fallback"]).next()
               sparql   = ""
               
               try :
                    sparql = self.__graph.objects(o, XINCLUDE["sparql"]).next()
               except :
                    pass
               
               res = self.fetch_xinclude(src)

               if res and self.parse_xinclude(res, sparql) :

                    for s, p in self.__graph.predicate_objects(o) :
                         self.__graph.remove((o, s, p))
          
     #
     #
     #
     
     def fetch_xinclude (self, url) :
     
          req = urllib2.Request(url)

          try :
               res = urllib2.urlopen(req)
          except urllib2.HTTPError, e:
               code = e.code
               msg  = e.msg
               return
          except urllib2.URLError, e:
               code = 999
               msg  = e.reason
               return

          return res
     
     #
     #
     #

     def parse_xinclude (self, http_res, sparql="") :

          (fd,fname) = tempfile.mkstemp()
          fh = codecs.open(fname, "w", "utf-8")
          fh.write(http_res.read())
          fh.close()

          if not sparql :

               try :
                    self.__graph.load(fname, format="n3")
                    os.unlink(fname)
                    return 1
               except :
                    os.unlink(fname)
                    return
               
          #

          try :
               new_graph = Graph()
               new_graph.load(fname, format="n3")
               os.unlink(fname)
          except :
               os.unlink(fname)
               return

          sparql_graph = sparqlGraph.SPARQLGraph(graph=new_graph)

          # re to parse 'sparql'

          select  = ()
          pattern = []
          
          try :
               where  = GraphPattern(pattern)
               result = sparql_graph.query(select, where)
          except :
               return
          
          for spo in result :
               self.__graph.add(spo)

          return 1
     
     #
     #
     #

     def stagified (self) :

          if not self.__graph :
               return False
          
          if list(self.__graph.objects(None, ERDFG["stage"])) :
               return True

          return False

     #
     #
     #

     def dump_subjects (self) :
          subjects = []
          
          for obj in self.__graph.objects(None, DC["subject"]) :               
               if obj.__class__.__name__ == "Literal" :
                    subjects = obj.split(" ")
                    break
               else :
                    self.process_subject_objects(obj, subjects)

                    return subjects
          
     #
     #
     #
     
     def process_subject_objects (self, obj, results=[]) :

          if obj == RDF["nil"] :
               return
          
          for p, o in self.__graph.predicate_objects(obj) :
               if p == RDF["first"] : 
                    self.process_subject_node(o, results)
               elif p == RDF["rest"] :
                    self.process_subject_objects(o, results)
               else :
                    pass

     #
     #
     #
     
     def process_subject_node (self, node, results) :
          if self.namespace_for_uri(node) == NS_MAP['del'] :
               results.append(self.localname_for_uri(node))
          else :
               results.append(node)
          
     #
     #
     #
     
     def dump_language (self) :
          ctx = self.context()

          lang = list(self.__graph.objects(ctx, DC["language"]))
          
          if len(lang) :
               return unicode(lang[0])
          else :
               return None
          
     #
     #
     #
     
     def dump_titles (self) :
          titles = []

          if not self.__graph :
               return titles
          
          ctx   = self.context()
          title = list(self.__graph.objects(ctx, DC["title"]))

          if len(title) :
               titles.append({'title':unicode(title[0]), 'language':self.dump_language()})

          #
          
          for sub in self.__graph.objects(None, DC["alternative"]) :
               data = {}

               if sub.__class__.__name__ == "Literal" :
                    data['alternative'] = unicode(sub)
                    
               else :

                    for p, o in self.__graph.predicate_objects(sub) :
                         label = self.localname(p)

                         if label == 'value' :
                              label = 'alternative';

                         data[label] = unicode(o)

               titles.append(data)

          return titles
          
     #
     #
     #
     
     def dump_stages (self) :
          stages = []

          for s in self.__graph.objects(None, ERDFG["stage"]) :
               stages.append(self.process_stage_node(s))

          return stages

     #
     #
     #

     def process_stage_node (self, obj) :

          data = {'title'       : u'',
                  'ingredients' : u'',
                  'directions'  : u'',
                  'equipment'   : u''}
          
          data['title'] = unicode(self.__graph.objects(obj, DC["title"]).next())

          data['ingredients'] = self.dump_ingredients(obj)               
          data['directions']  = self.dump_directions(obj)
     
          return data
          
     #
     #
     #

     def dump_time (self) :
          results = {}

          # fix me
          
          if self.__graph :
               
               for obj in self.__graph.objects(None, ERDFG['time']) :
                    self.process_kv_objects(obj, results)

          return results

     #
     #
     #
     
     def dump_yield (self) :
          results = {}

          if self.__graph :
               for obj in self.__graph.objects(None, ERDFG['yield']) :
                    self.process_kv_objects(obj, results)

          return results

     #
     #
     #

     def dump_source (self) :
          results = {}

          if self.__graph :
               for obj in self.__graph.objects(None, DC['source']) :
                    self.process_kv_objects(obj, results)
                    
          return results
     
     #
     #
     #

     def process_kv_objects (self, obj, results) :

          for p, o in self.__graph.predicate_objects(obj) :
               label = self.localname(p)

               if type(results) == types.DictionaryType :
                    results[label] = unicode(o)
               else :
                    results.append({label:unicode(o)})

     #
     #
     #
     
     def localname (self, str) :
          ima   = str.__class__.__name__
          
          if ima == "URIRef" :
               return self.localname_for_uri(str)

          return unicode(str.strip())

     #
     #
     #

     def namespace_for_uri (self, uri) :

          if "#" not in uri:
               scheme, netloc, path, params, query, fragment = urlparse(uri)
               if path:
                    return (rsplit(uri, "/", 1))[0] + "/"
               else :
                    return uri

          return uri.rsplit("#")[0].strip() + "#"

     #
     #
     #
     
     def localname_for_uri (self, uri) :

          if "#" not in uri:
               scheme, netloc, path, params, query, fragment = urlparse(uri)
               if path:
                    return (rsplit(uri, "/", 1))[1]
               else :
                    return uri

          return uri.rsplit("#")[1].strip()
     
     #
     #
     #
     
     def dump_equipment (self, ctx=None) :
          pass
     
     #
     #
     #
          
     def dump_ingredients (self, ctx=None) :

          # fix me
          
          if not self.__graph :
               return []

          #
          
          results = []

          for obj in self.__graph.objects(ctx, ERDFG['ingredients']) :        
               self.process_ing_objects(obj, results)

          return results

     #
     #
     #
     
     def process_ing_objects (self, obj, results=[]) :

          if obj == RDF["nil"] :
               return
          
          if len(list(self.__graph.objects(obj, ATOM["content"]))) :
               results.append(self.process_content_node(obj))

          if len(list(self.__graph.objects(obj, ERDFG["foodstuff"]))) :
               results.append(self.process_ing_node(obj))

          if len(list(self.__graph.predicates(obj, XINCLUDE["include"]))) :
               results.append(self.process_xinclude_node(obj))
          
          for p, o in self.__graph.predicate_objects(obj) :
               if p == RDF["first"] : 
                    self.process_ing_objects(o, results)
               elif p == RDF["rest"] :
                    self.process_ing_objects(o, results)
               else :
                    pass
          
     #
     #
     #
     
     def process_ing_node (self, node) :

          properties = ("amount", "measure", "foodstuff", "detail")
          data = {}
     
          for label in properties :
               value = None

               try :
                    value = self.__graph.objects(node, ERDFG[label]).next()
                    value = self.localname(value)
               except :
                    pass
               
               data[label] = unicode(value)

          return data
          
     #
     #
     #

     def dump_directions (self, ctx=None) :
          return self.dump_guideline('directions', ctx, 'allow_xinclude')

     #
     #
     #
     
     def dump_notes (self, ctx=None) :
          return self.dump_guideline('notes', ctx)

     #
     #
     #
     
     def dump_guideline (self, label, ctx=None, allow_xinclude=0) :
          results = []
               
          if self.__graph :
               for obj in self.__graph.objects(ctx, ERDFG[label]) :
                    res = self.process_guideline_objects(obj, results, allow_xinclude)

          return results

     #
     #
     #
     
     def dump_guidelines (self, ctx=None) :
          return {'directions' : self.dump_directions(ctx),
                  'notes'      : self.dump_notes(ctx)}
                    
     #
     #
     #
     
     def process_guideline_objects (self, obj, results=[], allow_xinclude=0) :
          return self.process_content_objects(obj, results, allow_xinclude)

     #
     #
     #

     def dump_history (self) :
          results = []

          if self.__graph :
               for obj in self.__graph.objects(None, ERDFG['history']) :
                    res = self.process_content_objects(obj, results)

          return results

     #
     #
     #
     
     def process_history_objects (self, node, results=[]) :
          return self.process_content_objects(obj, results)

     #
     #
     #

     def process_content_objects (self, obj, results=[], allow_xinclude=0) :

          if obj == RDF["nil"] :
               return

          if len(list(self.__graph.objects(obj, ATOM["content"]))) :
               results.append(self.process_content_node(obj))

          elif len(list(self.__graph.objects(obj, ATOM["link"]))) :
               results.append(self.process_content_node(obj))
                              
          if allow_xinclude :
               if len(list(self.__graph.predicates(obj, XINCLUDE["include"]))) :
                    results.append(self.process_xinclude_node(obj))
          
          for p, o in self.__graph.predicate_objects(obj) :

               if p == RDF["first"] : 
                    self.process_content_objects(o, results, allow_xinclude)
               elif p == RDF["rest"] :
                    self.process_content_objects(o, results, allow_xinclude)
               else :
                    pass

     #
     #
     #
     
     def process_content_node (self, node) :

          properties = ("content", "author", "date", "link", "title")
          data = {}
     
          for label in properties :
               value = None
               
               try :
                    value = self.__graph.objects(node, ATOM[label]).next()
               except :
                    pass

               data[label] = unicode(value)

          return data

     #
     #
     #

     def process_xinclude_node(self, node) :

          properties = ("href", "parse", "fallback", "xpointer")
          data = {}
          
          for label in properties :
               value = None

               try :
                    value = self.__graph.objects(node, XINCLUDE[label]).next()
               except :
                    pass

               data[label] = unicode(value)

          return data
          
     #
     #
     #

     def dump_core (self) :

          data = {}
          
          if self.stagified() :
               data['stages'] = self.dump_stages()
               data['notes']  = self.dump_notes()
          else :
               data['ingredients'] = self.dump_ingredients()
               data['directions']  = self.dump_directions()
               data['notes']       = self.dump_notes()

          return data
     
     #
     #
     #

     def dump_requirements (self) :

          data = {}

          if self.stagified() :
               data['stages'] = self.dump_stages()
          else :
               data['ingredients'] = self.dump_ingredients()
               data['equipment']   = self.dump_equipment()

          data['time'] = self.dump_time()

          return data

     #
     #
     #
     
     def dump (self) :

          data = {}
          
          if self.stagified() :
               data['stages'] = self.dump_stages()
          else :
               data = self.dump_requirements()
               data['directions'] = self.dump_directions()               

          data['notes']   = self.dump_notes()
          data['time']    = self.dump_time()               
          data['history'] = self.dump_history()
          data['yield']   = self.dump_yield()
          data['source']  = self.dump_source()          

          data['title']    = self.dump_titles()
          data['language'] = self.dump_language()
          data['subject']  = self.dump_subjects()

          return data
     
     #
     #
     #
     
     def dump_raw (self) :
          for (s, p, o) in self.__graph :
               print "%s %s %s" % (s, p, 0)

     def context (self) :

          if not self.__graph :
               return unicode("#")
          
          ctx = list(self.__graph.contexts())[0]
          ctx = ctx.split("#")[0] + "#"
          return unicode(ctx)
     
     #
     #
     #
     
if __name__ == "__main__" :

     from sys import argv
     
     e = parser(argv[1], xinclude=1)
     print e.dump()
