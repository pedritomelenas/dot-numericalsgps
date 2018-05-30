#############################################################################
##
#W  dot.gi                  Manuel Delgado <mdelgado@fc.up.pt>
#W                          Pedro A. Garcia-Sanchez <pedro@ugr.es>
#W                          Andrés Herrera-Poyatos <andreshp9@gmail.com>
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
#F DotSplash(dots...)
##  Launches a browser and visualizes the dots diagrams 
##  provided as arguments.
##
############################################################################
InstallGlobalFunction(DotSplash, function(dots...)
  local str, temp_file, digraph, html, i, line, out;

  str:=function(s)
    return Concatenation("\"",String(s),"\"");
  end;
  
  # Open a temporal file
  temp_file := Filename(DirectoryTemporary(), "graph-viz.html");
  out := OutputTextFile(temp_file, false);
  SetPrintFormattingStatus(out, false);  
  
  # HTML header
  html := "<!DOCTYPE html>\n<html>\n<head>\n<meta charset=\"utf-8\">\n <title>Graph Viz</title>\n";
  html := Concatenation(html, "<style>\n .content {\n display: inline-block;\n text-align: center;\n vertical-align: top;\n}\n</style></head>\n<body>\n<script  src=\"http://mdaines.github.io/viz.js/bower_components/viz.js/viz.js\">\n</script>\n");
  #html:=Concatenation(html, "<style>\n .content {\n display: inline-block;\n text-align: center;\n vertical-align: top;\n}\n</style></head>\n<body>\n<script  src=\"viz.js\">\n</script>\n");
  
  # Assign an ID to each graph
  for i in [1..Length(dots)] do
    line := Concatenation("<span id=", str(i), " class='content'>Graph to be displayed here (internet connection required) </span>\n");
    html := Concatenation(html, line);
  od;
  
  # Draw each graph
  line := "<script>\n";
  html := Concatenation(html, line);
  i := 1;
  for digraph in dots do
    line := Concatenation(" document.getElementById(", str(i), ").innerHTML =Viz('", digraph, "');\n");
    html := Concatenation(html, line);
    i := i+1;
  od;
  
  # End the HTML code
  line := "</script>\n</body>\n</html>";
  html := Concatenation(html, line);
  
  # Draw the graph
  PrintTo(out, html);  
  CloseStream(out);
  Print("Saved to ", temp_file, "\n");
  if ARCH_IS_MAC_OS_X() then
    Exec("open ", temp_file);
  elif ARCH_IS_WINDOWS() then
    Exec("start firefox ", temp_file);
  elif ARCH_IS_UNIX() then
    Exec("xdg-open ", temp_file);
  fi;

  return html;
end);

############################################################################
##
#F  DotBinaryRelation(br)
##  Returns a GraphViz dot which represents the binary relation br.
##  The set of vertices of the resulting graph is the source of br.
##  Edges join those elements which are related in br.
##
############################################################################
InstallGlobalFunction(DotBinaryRelation, function(br)
  local pre, element, im, output, out, str;

  str := function(i)
    return Concatenation("\"",String(i),"\"");
  end;

  if not IsBinaryRelation(br) then
    Error("The argument must be a binary relation");
  fi;
  
  # Add the header of the GraphViz code
  out := "";
  output := OutputTextString(out, true);
  AppendTo(output,"digraph  NSGraph{rankdir = TB; edge[dir=back];");
  
  # Add the vertices
  pre := Source(br);
  for element in pre do
    AppendTo(output, element," [label=", str(element), "];");
  od;
  
  # Add the edges
  for element in pre do
    for im in Image(br, [element]) do
      AppendTo(output, im, " -> ", element, ";");
    od;
  od;
  
  AppendTo(output, "}");
  CloseStream(output);
  return out;
end);

############################################################################
##
#F HasseDiagramOfNumericalSemigroup(s, A)
##  Returns a binary relation which is the Hasse diagram of A with 
##  respect to the ordering a <= b if b - a in S.
##
############################################################################
InstallGlobalFunction(HasseDiagramOfNumericalSemigroup, function(s, A)
  local rel, p, D;
  
  if not IsNumericalSemigroup(s) then
    Error("The argument must be a numerical semigroup.\n");
  fi;
  
  # Build the binary relation and returns its Hasse diagram
  D := Domain(Set(A));
  rel := Tuples(D, 2);
  rel := Filtered(rel, p -> p[2] - p[1] in s);
  rel := List(rel, p -> Tuple([p[1], p[2]]));  
  rel := BinaryRelationByElements(D, rel);  
  return HasseDiagramBinaryRelation(rel);  
end);

############################################################################
##
#F HasseDiagramOfBettiElementsOfNumericalSemigroup(s)
##  Returns a binary relation which is the Hasse diagram of the Betti
##  elements of s with respect to the ordering a <= b if b - a in S.
##
############################################################################
InstallGlobalFunction(HasseDiagramOfBettiElementsOfNumericalSemigroup, function(s)
  if not IsNumericalSemigroup(s) then
    Error("The argument must be a numerical semigroup.\n");
  fi;
    
  return HasseDiagramOfNumericalSemigroup(s, BettiElementsOfNumericalSemigroup(s));    
end);

############################################################################
##
#F HasseDiagramOfAperyListOfNumericalSemigroup(s, n)
##
############################################################################
InstallGlobalFunction(HasseDiagramOfAperyListOfNumericalSemigroup, function(s, n...)
  local a;
    
  if not IsNumericalSemigroup(s) then
    Error("The argument must be a numerical semigroup.\n");
  fi;
  
  if Length(n) = 0 then
    a := MultiplicityOfNumericalSemigroup(s);
  elif Length(n) = 1 then
    a := n[1];
  else
    Error("The number of arguments must be one or two");
  fi;
    
  return HasseDiagramOfNumericalSemigroup(s, AperyListOfNumericalSemigroup(s, a));    
end);

############################################################################
##
#F DotTreeOfGluingsOfNumericalSemigroup(s, depth...)
##  Returns a GraphViz dot that represents the tree of gluings of the
##  numerical semigroup s.
##  The tree is truncated at the given depth. If the depth is not provided,
##  then the tree is fully built.
##
############################################################################
InstallGlobalFunction(DotTreeOfGluingsOfNumericalSemigroup, function(s, depth...)
  local SystemOfGeneratorsToString, rgluings, out, output, labels, edges, index, d;

  SystemOfGeneratorsToString := function(sg)
    return Concatenation("〈 ", JoinStringsWithSeparator(sg, ", "), " 〉");
  end;
    
  if not IsNumericalSemigroup(s) then
    Error("The argument must be a numerical semigroup.\n");
  fi;
  
  if Length(depth) = 0 then
    d := -1;
  else
    d:= depth[1];      
  fi;

  # Recursively plot the gluings tree 
  rgluings := function(s, level, parent)
    local lg, label, gen1, gen2, p, son1, son2;
      
    lg := AsGluingOfNumericalSemigroups(s);    
    
    labels := Concatenation(labels, String(parent), " [label=\"", SystemOfGeneratorsToString(MinimalGenerators(s)), "\", style=filled]; ");
    #labels := Concatenation(labels, String(parent), " [label=\"", SystemOfGeneratorsToString(MinimalGenerators(s)), "\"]; ");
        
    if level = 0 then
      return ;
    fi;
    
    # For each possible gluing plot the gluing and the numerical semigroups associated.
    for p in lg do
      # Add the gluing 
      label := Concatenation(SystemOfGeneratorsToString(p[1])," + ", SystemOfGeneratorsToString(p[2]));
      labels := Concatenation(labels, String(index), " [label=\"", label, "\" , shape=box]; ");
      edges := Concatenation(edges, String(parent), " -> ", String(index), "; ");
      
      # Add the two numerical semigroups involved
      son1 := index+1;
      son2 := index+2;
      
      gen1 := p[1] / Gcd(p[1]);
      gen2 := p[2] / Gcd(p[2]);      
      
      edges := Concatenation(edges, String(index), " -> ", String(son1), "; ");
      edges := Concatenation(edges, String(index), " -> ", String(son2), "; ");
      
      # Call the function recursively
      index := index + 3;      
      rgluings(NumericalSemigroup(gen1), level-1, son1);      
      rgluings(NumericalSemigroup(gen2), level-1, son2);      
    od;
    
    return ;
  end;
  
  # Create the root of the tree
  labels := "";
  edges := "";  
  index := 1;
  labels := Concatenation(labels, "0", " [label=\"", SystemOfGeneratorsToString(MinimalGenerators(s)), "\"]; ");  
  # Compute the tree
  rgluings(s, d, 0);
  
  # Prepare the output
  out := "";
  output := OutputTextString(out, true);
  SetPrintFormattingStatus(output, false);
  AppendTo(output,"digraph  NSGraph{rankdir = TB; ");
  AppendTo(output, labels);
  AppendTo(output, edges);
  AppendTo(output, "}");
  CloseStream(output);
  
  return out;
end);


############################################################################
##
#F DotOverSemigroupsNumericalSemigroup(s)
##  Returns a GraphViz dot that represents the Hasse diagram of 
##  oversemigroupstree of the numerical semigroup s.
##  Irreducible numerical semigroups are highlighted.
##
############################################################################
InstallGlobalFunction(DotOverSemigroupsNumericalSemigroup, function(s)
  local ov, c,i,r,n,hasse, str, output, out, SystemOfGeneratorsToString;
  
  hasse:=function(rel)
    local dom, out;
    dom:=Flat(rel);
    out:=Filtered(rel, p-> ForAny(dom, x->([p[1],x] in rel) and ([x,p[2]] in rel)));
    return Difference(rel,out);
  end;

  str := function(i)
    return Concatenation("\"",String(i),"\"");
  end;

  SystemOfGeneratorsToString := function(sg)
    return Concatenation("〈 ", JoinStringsWithSeparator(sg, ", "), " 〉");
  end;

  ov:=OverSemigroupsNumericalSemigroup(s);
  n:=Length(ov);

  # Add the header of the GraphViz code
  out := "";
  output := OutputTextString(out, true);
  SetPrintFormattingStatus(output, false);
  AppendTo(output,"digraph  NSGraph{rankdir = TB; edge[dir=back];");

  # Add vertices
  for i in [1..n] do
   if IsIrreducible(ov[i]) then 
    AppendTo(output,i," [label=\"",SystemOfGeneratorsToString(MinimalGenerators(ov[i])) ,"\", style=filled];");
   else 
    AppendTo(output,i," [label=\"",SystemOfGeneratorsToString(MinimalGenerators(ov[i])) ,"\"];");
   fi;
  od;

  # Add edges
  c:=Cartesian([1..n],[1..n]);
  c:=Filtered(c, p-> p[2]<>p[1]);
  c:=Filtered(c, p-> IsSubset(ov[p[1]],ov[p[2]]));
  c:=hasse(c);

  for r in c do
    AppendTo(output,r[1]," -> ",r[2],";");
  od;

  AppendTo(output, "}");
  CloseStream(output);
  return out;  
end);
