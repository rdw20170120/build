''' generator support functionality
'''

import sys

from project_euler.solution.math import is_even

pseudo_infinite_range_limit = sys.maxsize

# TODO:  FIX:  Despite use of generators, it seems that I am instantiating the
# full pseudo-infinite sequence in some cases.  This consumes massive RAM, and
# could easily crash the host.  A lesser limit of about 300,000 items seems to
# consume about half of my physical RAM (1/2 of 8 GB = 4 GB).  That is enough
# to notice, but not enough to actually impair my machine.
pseudo_infinite_range_limit = 300000

def even(items):
    '''Return the "items" that have even values (a multiple of 2).'''
    return (i for i in items if is_even(i))

def infinite(start=0, step=1):
    '''Return an infinite sequence, subject to Python limits.
    '''
    return xrange(start, pseudo_infinite_range_limit, step)
