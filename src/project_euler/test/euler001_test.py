''' Project Euler Problem 1
REF:  http://projecteuler.net/index.php?section=problems&id=1
Created:  05-Oct-2001
Started:  07-Jun-2011
Solved:   08-Jun-2011

If we list all the natural numbers below 10 that are multiples of 3 or 5,
we get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.
'''

import nose.tools

# Support the solution

def is_multiple_of(small, natural):
    '''Is "natural" number a multiple of "small"?'''
    return True if 0 == natural else 0 == natural % small

# Form the solution

def is_desired_multiple(natural):
    '''Is "natural" number a desired multiple (of 3 or 5)?'''
    if 0 == natural:
        return False
    else:
        return is_multiple_of(3, natural) or is_multiple_of(5, natural)

def desired_multiples_below(natural):
    '''Return the desired multiples below the "natural" number.'''
    return [n for n in xrange(natural) if is_desired_multiple(n)]

# Test the solution elements

def test_is_multiple_of_three():
    '''Test given definition of multiples of three.'''
    nose.tools.ok_(    is_multiple_of(3, 0))
    nose.tools.ok_(not is_multiple_of(3, 1))
    nose.tools.ok_(not is_multiple_of(3, 2))
    nose.tools.ok_(    is_multiple_of(3, 3))
    nose.tools.ok_(not is_multiple_of(3, 4))
    nose.tools.ok_(not is_multiple_of(3, 5))
    nose.tools.ok_(    is_multiple_of(3, 6))
    nose.tools.ok_(not is_multiple_of(3, 7))
    nose.tools.ok_(not is_multiple_of(3, 8))
    nose.tools.ok_(    is_multiple_of(3, 9))

def test_is_multiple_of_five():
    '''Test given definition of multiples of five.'''
    nose.tools.ok_(    is_multiple_of(5, 0))
    nose.tools.ok_(not is_multiple_of(5, 1))
    nose.tools.ok_(not is_multiple_of(5, 2))
    nose.tools.ok_(not is_multiple_of(5, 3))
    nose.tools.ok_(not is_multiple_of(5, 4))
    nose.tools.ok_(    is_multiple_of(5, 5))
    nose.tools.ok_(not is_multiple_of(5, 6))
    nose.tools.ok_(not is_multiple_of(5, 7))
    nose.tools.ok_(not is_multiple_of(5, 8))
    nose.tools.ok_(not is_multiple_of(5, 9))
    
def test_given_multiples():
    '''Test given definition of desired multiples.'''
    nose.tools.ok_(not is_desired_multiple(0))
    nose.tools.ok_(not is_desired_multiple(1))
    nose.tools.ok_(not is_desired_multiple(2))
    nose.tools.ok_(    is_desired_multiple(3))
    nose.tools.ok_(not is_desired_multiple(4))
    nose.tools.ok_(    is_desired_multiple(5))
    nose.tools.ok_(    is_desired_multiple(6))
    nose.tools.ok_(not is_desired_multiple(7))
    nose.tools.ok_(not is_desired_multiple(8))
    nose.tools.ok_(    is_desired_multiple(9))

def test_given_sum():
    '''Test given of 23 == sum(desired_multiples_below(10)).'''
    nose.tools.eq_(23, sum(desired_multiples_below(10)))

# Test the solution

def test_solution():
    '''Test sum(desired_multiples_below(1000)).'''
    solution = sum(desired_multiples_below(1000))
    print "\nDesired solution is calculated to be '{0}'.".format(solution)
    nose.tools.eq_(233168, solution)