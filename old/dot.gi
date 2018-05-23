#############################################################################
##
#W  dot.gi                  Manuel Delgado <mdelgado@fc.up.pt>
#W                          Pedro A. Garcia-Sanchez <pedro@ugr.es>
##
##
#H  @(#)$Id: dot.gi $
##
#Y  Copyright 2017 by Manuel Delgado and Pedro Garcia-Sanchez
#Y  We adopt the copyright regulations of GAP as detailed in the
#Y  copyright notice in the GAP manual.
##
#############################################################################

############################################################################
##
#F RelToDotNS(uni, rel, labels)
##  rel is a list of lists with two elements representing
##  a binary relation on the set uni. labels are the labels of the nodes
##  Displays a (di)graph in dot whose vertices are uni
##  and edges these relations.
##
############################################################################
InstallGlobalFunction(RelToDotNS,function(uni, rel,labels)

  local r, output, out, i, str;

  str:=function(s)
    return Concatenation("\"",String(s),"\"");
  end;


  if not IsList(uni) then
    Error("The first argument must be a list");
  fi;
  if rel<>[] and not (IsRectangularTable(rel) and ForAll(rel, p->Length(p)=2)) then
    Error("The second argument must be a list of pairs (lists with two elements)");
  fi;
  if not IsSubset(uni,Union(rel)) then
    Error("The relations must be relaions on the elmenents in the first argument");
  fi;
  if not IsList(labels) then
    Error("The third argument must be a list");
  fi;
  if Length(uni)<>Length(labels) then
    Error("The first and third arguments must have the same length");
  fi;


  out:="";
  output:=OutputTextString(out,true);
  AppendTo(output,"digraph  NSGraph{");
  for i in [1..Length(uni)] do
    AppendTo(output,i," [label=",str(labels[i]),"];");
  od;
  for r in rel do
      AppendTo(output,Position(uni,r[1])," -> ",Position(uni,r[2]),";");
  od;
  AppendTo(output,"}");
  CloseStream(output);
  return out;
end);

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
InstallGlobalFunction(AperyListInDot,function(arg)
  local ap,c,hasse, s, n, r, output, out;
  # rel is a list of lists with two elements representin a binary relation
  # hasse(rel) removes from rel the pairs [x,y] such that there exists
  # z with [x,z],[z,y] in rel
  hasse:=function(rel)
      local dom, out;
      dom:=Flat(rel);

      out:=Filtered(rel, p-> ForAny(dom, x->([p[1],x] in rel) and ([x,p[2]] in rel)));
      return Difference(rel,out);

  end;


  if Length(arg)=1 then
    s:=arg[1];
    n:=MultiplicityOfNumericalSemigroup(s);
  fi;
  if Length(arg)=2 then
    s:=arg[1];
    n:=arg[2];
  fi;
  if Length(arg)>2 then
    Error("The number of arguments must be one or two");
  fi;
  ap:=AperyList(s,n);
  c:=Cartesian(ap,ap);
  c:=Filtered(c, p-> p[2]<>p[1]);
  c:=Filtered(c, p-> p[1]-p[2] in s);
	c:=hasse(c);
  out:="";
  output:=OutputTextString(out,true);

  AppendTo(output,"graph  AperyHasse{");

  for r in c do
      AppendTo(output,r[1]," -- ",r[2],";");
  od;

  AppendTo(output,"}");

  CloseStream(output);
  return out;

end);

##########################################################
#
# Launches browser and visualizes dots contained in the list ts
#
##########################################################

InstallGlobalFunction(HtmlDotSplashNS,
function(ts)
  local digraph, n, e, str, name, html, t,i, line;

  str:=function(s)
    return Concatenation("\"",String(s),"\"");
  end;

  name := Filename(DirectoryTemporary(), "graph-test.html");

  html:="<!DOCTYPE html>\n<html>\n<head>\n<meta charset=\"utf-8\">\n <title>Apéry NS</title>\n";
  html:=Concatenation(html, "<style>\n .content {\n display: inline-block;\n text-align: center;\n vertical-align: top;\n}\n</style></head>\n<body>\n<script  src=\"http://mdaines.github.io/viz.js/bower_components/viz.js/viz.js\">\n</script>\n");
  #html:=Concatenation(html, "<style>\n .content {\n display: inline-block;\n text-align: center;\n vertical-align: top;\n}\n</style></head>\n<body>\n<script  src=\"viz.js\">\n</script>\n");

  AppendTo(name,html);

  for i in [1..Length(ts)] do
    line:=Concatenation("<span id=", str(i)," class='content'>Graph to be displayed here (internet connection required) </span>\n");
    AppendTo(name,line);
    html:=Concatenation(html,line);
  od;
  line:="<script>\n";
  AppendTo(name,line);
  html:=Concatenation(html,line);
  i:=1;
  for t in ts do
    digraph:=t;
    line:=Concatenation(" document.getElementById(",str(i),").innerHTML =Viz('",digraph,"');\n");
    AppendTo(name,line);
    html:=Concatenation(html,line);
    i:=i+1;
  od;

  line:="</script>\n</body>\n</html>";
  AppendTo(name,line);
  html:=Concatenation(html, line);

  #name := Filename(DirectoryTemporary(), "graph-test.html");
  Print("Saved to ",name,"\n");
  if ARCH_IS_MAC_OS_X() then
    Exec("open ",name);
  fi;
  if ARCH_IS_WINDOWS() then
    Exec("start firefox ",name);
  fi;
  if ARCH_IS_UNIX() then
    Exec("xdg-open ",name);
  fi;

  return html;

end);
