''' Project Euler Problem 2
REF:  http://projecteuler.net/index.php?section=problems&id=2
Created:  19-Oct-2001
Solved:

Each new term in the Fibonacci sequence is generated by adding the previous two
terms. By starting with 1 and 2, the first 10 terms will be:
1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...

By considering the terms in the Fibonacci sequence whose values do not exceed
four million, find the sum of the even-valued terms.
'''

import nose.tools

# Form the solution

def fibonacci_term(index):
    '''Return "index"th term of the Fibonacci sequence.
    
       By definition, fibonacci_term(1) == 1 and fibonacci_term(2) = 2,
       so extend to fibonacci_term(0) == 1 for completeness.
    '''
    if 0 == index:
        return 1
    elif 1 == index:
        return 1
    elif 0 > index:
        raise IndexError(
            "Index '{0}' is below zero and therefore invalid!".format(index)
        )
    else:
        return fibonacci_term(index - 1) + fibonacci_term(index - 2)

def fibonacci(count):
    '''Return the first "count" terms of the Fibonacci sequence.
    '''
    return [fibonacci_term(i) for i in range(1, count + 1)]

# Test the solution elements

def test_given_terms():
    '''Test given terms of Fibonacci sequence.'''
    nose.tools.eq_( 1, fibonacci_term( 1))
    nose.tools.eq_( 2, fibonacci_term( 2))
    nose.tools.eq_( 3, fibonacci_term( 3))
    nose.tools.eq_( 5, fibonacci_term( 4))
    nose.tools.eq_( 8, fibonacci_term( 5))
    nose.tools.eq_(13, fibonacci_term( 6))
    nose.tools.eq_(21, fibonacci_term( 7))
    nose.tools.eq_(34, fibonacci_term( 8))
    nose.tools.eq_(55, fibonacci_term( 9))
    nose.tools.eq_(89, fibonacci_term(10))

@nose.tools.raises(IndexError)
def test_invalid_index_is_rejected():
    '''Test that an invalid index is rejected.'''
    fibonacci_term(-1)

def test_zeroth_term():
    '''Test the zeroth term of the Fibonacci sequence.'''
    nose.tools.eq_(1, fibonacci_term(0))

def test_sum_of_given_terms():
    '''Test sum of given first ten terms.'''
    total  = fibonacci_term( 1)
    total += fibonacci_term( 2)
    total += fibonacci_term( 3)
    total += fibonacci_term( 4)
    total += fibonacci_term( 5)
    total += fibonacci_term( 6)
    total += fibonacci_term( 7)
    total += fibonacci_term( 8)
    total += fibonacci_term( 9)
    total += fibonacci_term(10)
    nose.tools.eq_(total, sum(fibonacci(10)))

# Test the solution

