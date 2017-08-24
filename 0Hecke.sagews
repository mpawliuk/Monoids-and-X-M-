from sage.monoids.hecke_monoid import HeckeMonoid

##################################
### Some sample Coxeter groups ###
##################################

# The names come from the classification.

# A1xA1
m2_1 = [[1,2],[2,1]]
index1 = index_set=['a','b']

# A2
m2_2 = [[1,3],[3,1]]
index2 = index_set=['a','b']

# A3 Not actually A3!
m2_3 = [[1,6],[6,1]]
index3 = index_set=['a','b']

# A3
m3_1 = [[1,3,2],[3,1,3],[2,3,1]] # This is already pretty complicated!
index3 = ['a','b','c']

# B3
m3_2 = [[1,4,2],[4,1,3],[2,3,1]]

# Alternatively you can describe Coxeter groups using their "Cartan type", which is a letter A, B, ..., H and a positive integer.
W_A2 = CoxeterGroup(["A",2], implementation="matrix")
W_A3 = CoxeterGroup(["A",3], implementation="matrix")
W_H3 = CoxeterGroup(["H",3], implementation="matrix")
W_G2 = CoxeterGroup(["G",2], implementation="matrix")

# This is the most useful table of what Cartan types are allowed:
#     https://en.wikipedia.org/wiki/Coxeter_groupProperties

# This Wikipedia article for Dynkin Diagrams has a useful table:
#     https://en.wikipedia.org/wiki/Dynkin_diagramFinite_Dynkin_diagrams

# Sage documentation for Cartan Types is here:
#     http://doc.sagemath.org/html/en/reference/combinat/sage/combinat/root_system/cartan_type.htmlsage.combinat.root_system.cartan_type.CartanType

# The implementation specifies how sage stores them as groups. Options are:
#     'permutation' - as a permutation representation
#     'matrix' - as a Weyl group (as a matrix group acting on the root space); if this is not implemented, this uses the “reflection” implementation
#     'coxeter3' - using the coxeter3 package
#     'reflection' - as elements in the reflection representation;

# Documentation for Coxeter groups:
#     http://doc.sagemath.org/html/en/reference/combinat/sage/combinat/root_system/coxeter_group.html

########################
### BACK TO THE CODE ###
########################

def left_coset(m,M):
    """Output the coset mM, as a frozenset.
    Inputs are a monoid M and element m in M.
    """
    return frozenset(m*x for x in M)

def sse(a,b):
    """Return True if a is a (non-strict) subset of b, and False otherwise.
    Inputs are two iterables."""
    for x in a:
        if x not in b:
            return False
    return True

def name(m):
    """Turn a list like [1, 2, 3] into a string like '123',
    and turns the empty list into 'id'.
    """
    working_name = ''.join(str(char) for char in m.reduced_word())
    if not working_name:
        working_name += 'id'
    return working_name

def X(M):
    """Given a monoid M, return the poset of cosets of M, 
    with each coset mM labeled with name(m).
    """
    elems = set()
    labels = {}
    for m in M:
        coset_of_m = frozenset(left_coset(m,M))
        elems.add(coset_of_m)
        labels[coset_of_m] = name(m)
    return Poset((elems,sse), labels)

#################################
### Defining Y''(M) := Y_2(M) ###
#################################

# This just involves trimming off all but one of the top elements of Y_1(M).
# It's easier to just go through X(M) and a slight variation on initial_segments.

def chain_name(chain):
    """Return a string with the names of elements of a given chain.
    Expects a list like [123, 'abc', 789] and returns '(123,abc,789)'
    """
    return '(' + ''.join(str(char)+',' for char in chain[:-1]) + str(chain[-1]) + ')'

def initial_segments_2(poset):
    """ Output two things, as an ordered pair:
    1. A set X (not a frozenset) containing all initial segments of chains in P.
    2. A dictionary, in which each chain in X is labeled with its name, according to chain_name() above.
    Input is a poset P.
    """
    elms = set()
    labels = {}
    added_maximal_chain = False # Keep track of a one-time addition of a maximal chain.
    for chain in poset.maximal_chains(): # The maximal_chains() method returns all maximal chains, each of which we then truncate to get all chains.
        if not added_maximal_chain:
            elms.add(frozenset(chain)) # This adds the maximal chain itself.
            labels[frozenset(chain)] = chain_name(chain) # Adds the maximal chain and its name to the dictionary.
            added_maximal_chain = True # We've added a maximal chain, so don't add any other ones.
        for i in range(1,len(chain)):
            working_chain = chain[:-i] # This is the truncation of chain after removing the last i elements.
            elms.add(frozenset(working_chain)) # Add the truncated chain.
            labels[frozenset(working_chain)] = chain_name(working_chain) # Adds the truncated chain and its name to the dictionary.
    return elms, labels

def Y_2(M):
    """ Output the poset Y''(M) of initial segments of chains of X(M), ordered by subset/initial segment.
    Input is a monoid M.
    """
    data = initial_segments_2( X(M) )
    elems = data[0]
    labels = data[1]
    return Poset((elems,sse), labels)

#############################################
### Setting the monoid we're working with ###
#############################################

W = CoxeterGroup(["A",2], implementation="matrix")
H = HeckeMonoid(W)

show(X(H))
