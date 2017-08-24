︠import itertools

def remove_duplicates(original_list):
    """Take a list and removes all of its duplicate entries."""
    unique_list = []
    [unique_list.append(obj) for obj in original_list if obj not in unique_list]
    return unique_list

def elements_of_hyperplane_monoid(n, only_generators=False, include_identity=True):
    """Generate the potential elements as strings of 0,1,2.
    Hyperplane monoid with in dimension d=2 with n=3 hyperplanes.
    
    2 is used as a -1, to avoid using the symbol '-'. (We're working mod 3, essentially.)
    For example:
    000
    e11
    2e1
    22e
    """

    pot_elems = []
    # Start by adding the identity.
    # The identity is a generator, so it should be added.
    if include_identity or only_generators:
        pot_elems = [''.join(str(0) for i in range(0,n))]
    for e_index in range(0,n):
        potential_e = [0]
        if not only_generators:
            potential_e.append(1)
            potential_e.append(2)
        for e in potential_e:
            temp_elem = ''.join(str(2) for i in range(0,e_index)) + str(e) + ''.join(str(1) for j in range(e_index+1,n))
            pot_elems.append(temp_elem)
            pot_elems.append(temp_elem[::-1]) #This adds the reversed list, to save time
    return remove_duplicates(pot_elems)

def m(A,B):
    """Compute the product of two faces in the monoid.
    A,B should both be strings of the same length.
    """
    assert len(A) == len(B)
    AB = ''
    for i in range(len(A)):
        if A[i] == str(0):
            AB += B[i]
        else:
            AB += A[i]
    return AB

##########################################
### Here's the actual monoid machinery ###
##########################################

def left_coset(y,M):
    """Output the coset mM, as a frozenset.
    Inputs are a monoid M and element m in M.
    """
    return frozenset(m(y,x) for x in M)

def sse(a,b):
    """Return True if a is a (non-strict) subset of b, and False otherwise.
    Inputs are two iterables.
    """
    for x in a:
        if x not in b:
            return False
    return True

def name(y):
    """Turn a list like [1, 2, 3] into a string like '123',
    and turns the empty list into 'id'.
    """
    working_name = ''.join(str(char) for char in y)
    if not working_name:
        working_name += 'id'
    return working_name

def X(M):
    """Given a monoid M, return the poset of cosets of M,
    with each coset mM labeled with name(m).
    """
    elems = set()
    labels = {}
    for y in M:
        coset_of_y = frozenset(left_coset(y,M))
        elems.add(coset_of_y)
        labels[coset_of_y] = name(y)
    return Poset((elems,sse), labels)

#########################################
### Adventures in the third dimension ###
#########################################

# First we'll do the arrangement consisting of the three coordinate planes.
# Positive and negative sides of the planes are defined in the natural way.
# Planes are ordered: yz, xz, xy (in x, y, z order via their normal vectors).
# In this case it's clear that any string of 0s, 1s, and 2s is admissable.

# This is a list of all three-character strings of 0s, 1s, and 2s.
coord_planes = ["".join(a) for a in itertools.product('012', repeat=3)]

# Now we add one more plane, whose positive normal vector is (1,1,1).
# It will be represented by the fourth character in each string.

# This is a list of all four-character strings of 0s, 1s, and 2s.
potentials = ["".join(a) for a in itertools.product('012', repeat=4)]

# This dictionary translates back to positives and negatives.
code = {'1':1, '0':0, '2':-1}

# A string in the list potentials defines a set of equalitions/inequalities.
# For example, the string '1201' corresponds to the following:
#
# x > 0
# y < 0
# z = 0
# x + y + z > 
#
# Key: '1' means >, '2' means <, '0' means =.

def nonempty(x):
    """Determine if the sign sequence corresponding to the string x defines a nonempty intersection.
    It does this by checking if the collection of equations/inequalities corresponding to x has a solution.
    """
    if ('1' in x[:-1]) and ('2' in x[:-1]):
        # As long as I can have one of x, y, z positive and another negative,
        # I can make x+y+z any sign I like (including 0).
        return True
    elif x[:-1] == '000':
        # If x=y=z=0, then x+y+z must also equal 0.
        return x[3] == '0'
    else:
        # The only remaining possibility is that x, y, z are all either the same sign or 0 (and at least one must be nonzero).
        # In this case, x+y+z must be the same sign.
        sign_of_first_three = 0
        for i in x[:-1]:
            sign_of_first_three += code[i]
        sign_of_last_one = code[x[3]]
        return sign_of_first_three*sign_of_last_one > 0

# This is a list of sign sequences corresponding to nonempty intersections.
four_planes = [x for x in potentials if nonempty(x)]

#####################
### Graph methods ###
#####################

def out_degree(x,P):
    """Return the (out)-degree of x in P, i.e. the number of elements above it
    P is a poset
    x is an element of P
    """
    return len(P.upper_covers(x))

def in_degree(x,P):
    """Return the (in)-degree of x in P, i.e. the number of elements below it
    P is a poset
    x is an element of P
    """
    return len(P.lower_covers(x))

def out_degree_seq(P, level=0):
    """Provide the outdegrees at every level
    P is a poset from a hyperplane
    level is in the poset sense, starts from the bottom.
    """
    number_of_zeros = level
    seq = {}
    for x in P:
        if x.count('0') == number_of_zeros: # Checks that you're on the right level
            if out_degree(x,P) in seq:
                seq[out_degree(x,P)] += 1
            else:
                seq[out_degree(x,P)] = 1
    return seq

def in_degree_seq(P, level=1):
    """Provide the outdegrees at every level
    P is a poset from a hyperplane
    level is in the poset sense, starts from the bottom.
    Level 1 is the default because the bottom level has no in degree
    """
    number_of_zeros = level
    seq = {}
    for x in P:
        if x.count('0') == number_of_zeros:
            if in_degree(x,P) in seq:
                seq[in_degree(x,P)] += 1
            else:
                seq[in_degree(x,P)] = 1
    return seq

#######################
### Pretty Pictures ###
#######################

# figsize changes the size of show. Only the first value matters
#C.show(figsize=[4,4]) # Default
#C.show(figsize=[2,4]) # Smaller
#C.show(figsize=[10,4]) # Bigger

C = X(coord_planes)

print out_degree_seq(C) # all 8 of the bottom nodes each have 3 elements above it
print in_degree_seq(C) # all 12 elements on the next-to-bottom level have 2 elements below them
C.show(figsize=[10,4], vertex_shape='s', vertex_size=400) # s stands for square

D = X(four_planes)

print out_degree_seq(D) # 8 elements on the bottom level have 3 things above them, 6 have 4 elements above them
print in_degree_seq(D) # all 24 elements on the next-to-bottom level have 2 elements below them
D.show(figsize=[20,7], vertex_shape='s', vertex_size=600) # s stands for square
