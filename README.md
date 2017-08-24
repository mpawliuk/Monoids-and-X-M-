# Monoids and X(M)

This is code for computing latex X(M) from a monoid M. We look at two specific classes of monoids:

1. 0-Hecke monoids which come from Coxeter groups.
2. Hyperplane face monoids.

It was used in the research paper "Almost R-trivial monoids" by Ivan Khatchatourian and Micheal Pawliuk. [I will insert a link when it is on Arxiv.]

The code is written in Sage, and can be compiled online, at for example:

    https://cocalc.com/

# 0-Hecke

There isn't too much to explain that isn't in the paper. Sage handles the Coxeter groups and 0-Hecke monoids well. Here are some resources about how they are used in Sage.

This is the most useful table of what Cartan types are allowed:

     https://en.wikipedia.org/wiki/Coxeter_groupProperties

This Wikipedia article for Dynkin Diagrams has a useful table:

    https://en.wikipedia.org/wiki/Dynkin_diagramFinite_Dynkin_diagrams

Sage documentation for Cartan Types is here:

     http://doc.sagemath.org/html/en/reference/combinat/sage/combinat/root_system/cartan_type.htmlsage.combinat.root_system.cartan_type.CartanType

The implementation specifies how sage stores them as groups. Options are:

    'permutation' - as a permutation representation
    'matrix' - as a Weyl group (as a matrix group acting on the root space); if this is not implemented, this uses the “reflection” implementation
     'coxeter3' - using the coxeter3 package
     'reflection' - as elements in the reflection representation;

Documentation for Coxeter groups:

     http://doc.sagemath.org/html/en/reference/combinat/sage/combinat/root_system/coxeter_group.html

The section about Y_2(M) is not used for this paper. It is used in the paper "Monoid actions and ultrafilter methods in Ramsey theory" by Solecki that inspired this one. See for example these notes:

    https://boolesrings.org/mpawliuk/2016/10/20/ramsey-and-ultrafilter-1-ramsey-doccourse-prague-2016/
    https://boolesrings.org/mpawliuk/2016/10/23/ramsey-and-ultrafilters-2-ramsey-doccourse-prague-2016/

# Hyperplane Face Monoids

This code is a little more subtle because Sage doesn't natively handle this class of monoids. So we've built in how to generate the underlying set, and how to handle multiplication.

Elements of the monoid are stored as lists of 0s,1s and 2s, where the length of the list indicates the number of hyperplanes, and 0 means you have the hyperplane itslef, 1 is above and 2 is below. (We use 2 instead of -1 for simplicity in the code.)

[Explain what's going on.]
