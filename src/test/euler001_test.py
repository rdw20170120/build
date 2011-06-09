''' Project Euler Problem 1
REF:  http://projecteuler.net/index.php?section=problems&id=1
Created:  05-Oct-2001
Solved:   08-Jun-2011

If we list all the natural numbers below 10 that are multiples of 3 or 5,
we get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.
'''

# Form the solution

def is_multiple_of(small, natural):
    '''Is "natural" number a multiple of "small"?'''
    return False if 0 == natural else 0 == natural % small

def is_desired_multiple(natural):
    '''Is "natural" number a desired multiple (of 3 or 5)?'''
    return is_multiple_of(3, natural) or is_multiple_of(5, natural)

def sum_of_desired_multiples_below(natural):
    '''Return the sum of the desired multiples below the "natural" number.'''
    return sum(n for n in range(natural) if is_desired_multiple(n))

# Test the solution

def test_is_multiple_of_three():
    '''Test given definition of multiples of three.'''
    assert not is_multiple_of(3, 0)
    assert not is_multiple_of(3, 1)
    assert not is_multiple_of(3, 2)
    assert     is_multiple_of(3, 3)
    assert not is_multiple_of(3, 4)
    assert not is_multiple_of(3, 5)
    assert     is_multiple_of(3, 6)
    assert not is_multiple_of(3, 7)
    assert not is_multiple_of(3, 8)
    assert     is_multiple_of(3, 9)

def test_is_multiple_of_five():
    '''Test given definition of multiples of five.'''
    assert not is_multiple_of(5, 0)
    assert not is_multiple_of(5, 1)
    assert not is_multiple_of(5, 2)
    assert not is_multiple_of(5, 3)
    assert not is_multiple_of(5, 4)
    assert     is_multiple_of(5, 5)
    assert not is_multiple_of(5, 6)
    assert not is_multiple_of(5, 7)
    assert not is_multiple_of(5, 8)
    assert not is_multiple_of(5, 9)
    
def test_given_multiples():
    '''Test given definition of desired multiples.'''
    assert not is_desired_multiple(0)
    assert not is_desired_multiple(1)
    assert not is_desired_multiple(2)
    assert     is_desired_multiple(3)
    assert not is_desired_multiple(4)
    assert     is_desired_multiple(5)
    assert     is_desired_multiple(6)
    assert not is_desired_multiple(7)
    assert not is_desired_multiple(8)
    assert     is_desired_multiple(9)

def test_given_sum():
    '''Test given of 23 == sum_of_desired_multiples_below(10).'''
    assert 23 == sum_of_desired_multiples_below(10)

# Report the solution

def test_desired_solution():
    '''Test sum_of_desired_multiples_below(1000).'''
    solution = sum_of_desired_multiples_below(1000)
    print "Desired solution is calculated to be {0}".format(solution)
    assert 233168 == solution
