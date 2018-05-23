S := NumericalSemigroup(4,6,9);

# Draw the tree of gluins of S
DotSplash(DotTreeOfGluingsOfNumericalSemigroup(S, 4));

# Draw the hasse diagram of the Betti elements of S
betti := HasseDiagramOfBettiElementsOfNumericalSemigroup(S);
DotSplash(BinaryRelationToDot(betti));

# Draw the hasse diagram of an Apery set of S
apery := HasseDiagramOfAperyListOfNumericalSemigroup(S, 20);
DotSplash(BinaryRelationToDot(apery));

