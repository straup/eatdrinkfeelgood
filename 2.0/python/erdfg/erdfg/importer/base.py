# $Id: base.py,v 1.4 2007/04/04 15:48:18 asc Exp $

import rdflib
from erdfg.constants.xmlns import *

class base :
    
    def __init__ (self, path) :
        self.input   = path
        self.context = None

        self.note_idx    = 0
        self.history_idx = 0
        
        self.data  = {
            'title'       : [],
            'alternative' : [],
            'stages'      : [],
            'ingredients' : [],            
            'directions'  : [],
            'notes'       : [],
            'time'        : [],
            'history'     : [],
            'subject'     : [],
            'source'      : {},            
            'yield'       : {}
            }

    #
    #
    #

    def build_model (self) :

        atom  = rdflib.Namespace(NS_MAP['a'])
        dc    = rdflib.Namespace(NS_MAP['dc'])
        d     = rdflib.Namespace(NS_MAP['del'])        
        
        graph  = rdflib.Graph()
        recipe = rdflib.BNode()
        
        for t in self.data['title'] :
            graph.add((recipe, dc['title'], rdflib.Literal(t)))
 
        for t in self.data['alternative'] :
            graph.add((recipe, dc['alternative'], rdflib.Literal(t)))

        #
        # Ingredients
        #
        
        self.build_model_ingredients(graph, self.data['ingredients'])

        #
        # Directions
        #
        
        self.build_model_directions(graph, self.data['directions'])
        
        #
        # Happy Happy
        #

        return graph

    #
    #
    #
    
    def build_model_ingredients (self, graph, ingredients) :
        
        rdf   = rdflib.Namespace(NS_MAP['rdf'])
        erdfg = rdflib.Namespace(NS_MAP['er'])
        
        for i in ingredients :
            ing = rdflib.BNode()

            graph.add((ing, rdf['type'], erdfg['ingredient']))
            
            for k, v in i.items() :
                if not v :
                    continue

                if k == 'measure' :
                    # FIX ME !!! measure "map"
                    graph.add((ing, erdfg[k], erdfg[v]))                    
                elif k == 'foodstuff' :
                    graph.add((ing, erdfg[k], erdfg[v]))                    
                else :
                    graph.add((ing, erdfg[k], rdflib.Literal(v)))

        return True

    #
    #
    #

    def build_model_directions (self, graph, directions) :

        rdf   = rdflib.Namespace(NS_MAP['rdf'])
        erdfg = rdflib.Namespace(NS_MAP['er'])
        
        dir = rdflib.BNode()
        graph.add((dir, rdf['type'], erdfg['directions']))

        # FIX ME : author ?
        
        str_directions = "\n\n".join(directions)

        # FIX ME : so wrong
        self.build_model_list_content(graph, dir, [{'content':str_directions}])
        
    #
    #
    #

    def build_model_content (self, graph, data) :

        rdf = rdflib.Namespace(NS_MAP['rdf'])
        atom = rdflib.Namespace(NS_MAP['a'])

        ctx = rdflib.BNode()
        
        graph.add((ctx, atom['content'], rdflib.Literal(data['content'])))

        if data.has_key('author') :
            graph.add((ctx, atom['author'], rdflib.Literal(data['author'])))
            
        return ctx

    #
    #
    #

    def build_model_list_content (self, graph, ctx, data) :

        rdf = rdflib.Namespace(NS_MAP['rdf'])

        list  = rdflib.BNode()        
        first = data.pop(0)
        
        graph.add((list, rdf['first'], self.build_model_content(graph, first)))

        if len(data) :
            self.build_model_list_content(graph, list, data)
        else :
            rest = rdflib.BNode()
            graph.add((list, rdf['rest'], rdf['nil']))

        graph.add((ctx, rdf['List'], list))
