#############################################################################
##
#W  dot.gd                  Manuel Delgado <mdelgado@fc.up.pt>
#W                          Pedro A. Garcia-Sanchez <pedro@ugr.es>
##
##
#H  @(#)$Id: dot.gd $
##
#Y  Copyright 2016 by Manuel Delgado and Pedro Garcia-Sanchez
#Y  We adopt the copyright regulations of GAP as detailed in the
#Y  copyright notice in the GAP manual.
##
#############################################################################

############################################################################
##
#F RelToDotNS(uni, rel)
##  rel is a list of lists with two elements representing
##  a binary relation on the set uni.
##  Displays a (di)graph in dot whose vertices are uni
##  and edges these relations.
##
############################################################################
DeclareGlobalFunction("RelToDotNS");

############################################################################
##
#F AperyListInDot(arg)
##  arg is either a semigroup S, or a semigroup S and an integer n.
##  If no second argument is given, then n is taken to be the
##  multiplicity of S.
##  Displays in dot the Hasse diagram of Ap(S,n) with respect to the
##  ordering a <= b if b-a in S
##
############################################################################
DeclareGlobalFunction("AperyListInDot");

##########################################################
#
# Launches browser and visualizes dots contained in the list ts
#
##########################################################

DeclareGlobalFunction("HtmlDotSplashNS");