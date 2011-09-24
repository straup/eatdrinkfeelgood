eatdrinkfeelgood-1.1-to-indexcard-fo
--

NOTES

- This stylesheet is designed for recipes only. 'Menus' and 'courses'
  are not supported.

- image/bin64 elements are not supported.

TO DO

- Code to loop over the xlink:href value of an extref element should be
  added to try and do the right thing about splitting long uris across 
  mulitple lines.

- Figure out why the 'baseline-shift' property in the Footnote-Marker
  template isn't working properly.

GOTCHAS

- The resultant XSL-FO document has only been tested with Fop [1]
  Comments and bug reports on how it works with other processors
  would be much appreciated.

- If your 'history' element is very long, it may result in pushing the
  ingredients list on to the second page. 

  I will try to address this with judicious use of the 'float'
  property although it is not currently supported in Fop (0.20.4)

  Ultimately, the ingredients list should always begin on the right 
  hand side of the first page and any extra history content should 
  flow on to the second.

- Proper footnote formatting in Fop is often sketchy so they aren't used
  at all. 

  Instead there is an ugly 'external references' hack used for listing 
  extref elements at the end of the document.

  Additionally the only way to automagically number footnote thingies is 
  to do a count() or position() on some flavour of XPath query. Since this 
  stylesheet renders items with a diffferent ordering than they are listed 
  in the recipe document itself, the ordering of 'footnotes' is not 
  necessary ordered. 

  I'm not sure what to do about this, short of rendering the formatting objects
  document once and then processing it in order to add footnotes, since it seems 
  to be a limitation in XSL itself (XSL doesn't support global variables that 
  can be modified during the course of a transformation.)

- Fop does not support the 'reference-orientation' attribute but the goal
  is to render cards such that even-numbered pages are printed 'upside-down'.

  This is so that you can just flip them over instead of turning them
  around when you're in the kitchen cooking.

- Image handling is pretty basic without support for the 'float'
  property in FO processors.

  [1] http://xml.apache.org/fop/ 

