#############################################################################
##
#W  dot.gd                  Manuel Delgado <mdelgado@fc.up.pt>
#W                          Pedro A. Garcia-Sanchez <pedro@ugr.es>
##
## Andrés Herrera-Pollatos collaborated on the development of this file.
##
#H  @(#)$Id: dot.gd $
##
#Y  Copyright 2018 by Manuel Delgado and Pedro Garcia-Sanchez
#Y  We adopt the copyright regulations of GAP as detailed in the
#Y  copyright notice in the GAP manual.
##
#############################################################################

############################################################################
##
#F DotSplash(dots...)
##  Launches a browser and visualizes the dots diagrams 
##  provided as arguments.
##
############################################################################
DeclareGlobalFunction("DotSplash");

############################################################################
##
#F BinaryRelationToDot(br)
##  Returns a GraphViz dot which represents the binary relation br.
##  The set of vertices of the resulting graph is the source of br.
##  Edges join those elements which are related in br.
##
############################################################################
DeclareGlobalFunction("BinaryRelationToDot");

############################################################################
##
#F HasseDiagramOfNumericalSemigroup(s, A)
##  Returns a binary relation which is the Hasse diagram of A with 
##  respect to the ordering a <= b if b - a in S.
##
############################################################################
DeclareGlobalFunction("HasseDiagramOfNumericalSemigroup");

############################################################################
##
#F HasseDiagramOfBettiElementsOfNumericalSemigroup(s)
##  Returns a binary relation which is the Hasse diagram of the Betti
##  elements of s with respect to the ordering a <= b if b - a in S.
##
############################################################################
DeclareGlobalFunction("HasseDiagramOfBettiElementsOfNumericalSemigroup");

############################################################################
##
#F HasseDiagramOfAperyListOfNumericalSemigroup(s, n)
##  Returns a binary relation which is the Hasse diagram of the 
##  set Ap(s; n) with respect to the ordering a <= b if b - a in S.
##  The argument n is optional and its default value is the multiplicity 
##  of s.
##
############################################################################
DeclareGlobalFunction("HasseDiagramOfAperyListOfNumericalSemigroup");

############################################################################
##
#F DotTreeOfGluingsOfNumericalSemigroup(s, depth)
##  Returns a GraphViz dot which represents the tree of gluings of the
##  numerical semigroup s.
##  The tree is truncated at the given depth.
##
############################################################################
DeclareGlobalFunction("DotTreeOfGluingsOfNumericalSemigroup");
