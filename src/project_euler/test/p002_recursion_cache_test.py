'''
Project Euler Problem 2

see doc/ProjectEuler-002.txt for details
'''

import nose.tools

from project_euler.solution.generation import even

from project_euler.solution.P002_Recursion_Cache import P002_Recursion_Cache

def new_instance():
    return P002_Recursion_Cache()

def report_cache(problem_instance):
    print "\nCache size is now '{0}'.".format(problem_instance.cache_size())

@nose.tools.raises(IndexError)
def test_invalid_index_is_rejected():
    '''Test that an invalid index is rejected.'''
    p = new_instance()
    p.fibonacci_term(-1)
    report_cache(p)

def test_zeroth_term():
    '''Test the zeroth term of the Fibonacci sequence.'''
    p = new_instance()
    nose.tools.eq_(1, p.fibonacci_term(0))
    report_cache(p)

def test_sum_of_given_even_terms():
    '''Test sum of given even-valued terms.'''
    p = new_instance()
    total  = p.fibonacci_term(2)
    total += p.fibonacci_term(5)
    total += p.fibonacci_term(8)
    nose.tools.eq_(total, sum(even(p.fibonacci(10))))
    report_cache(p)

def test_given_terms():
    '''Test given terms of Fibonacci sequence.'''
    p = new_instance()
    nose.tools.eq_( 1, p.fibonacci_term( 1))
    nose.tools.eq_( 2, p.fibonacci_term( 2))
    nose.tools.eq_( 3, p.fibonacci_term( 3))
    nose.tools.eq_( 5, p.fibonacci_term( 4))
    nose.tools.eq_( 8, p.fibonacci_term( 5))
    nose.tools.eq_(13, p.fibonacci_term( 6))
    nose.tools.eq_(21, p.fibonacci_term( 7))
    nose.tools.eq_(34, p.fibonacci_term( 8))
    nose.tools.eq_(55, p.fibonacci_term( 9))
    nose.tools.eq_(89, p.fibonacci_term(10))
    report_cache(p)

def test_sum_of_given_terms():
    '''Test sum of given first ten terms.'''
    p = new_instance()
    total  = p.fibonacci_term( 1)
    total += p.fibonacci_term( 2)
    total += p.fibonacci_term( 3)
    total += p.fibonacci_term( 4)
    total += p.fibonacci_term( 5)
    total += p.fibonacci_term( 6)
    total += p.fibonacci_term( 7)
    total += p.fibonacci_term( 8)
    total += p.fibonacci_term( 9)
    total += p.fibonacci_term(10)
    nose.tools.eq_(total, sum(p.fibonacci(10)))
    report_cache(p)

@nose.tools.timed(60)
def test_solution():
    '''Test sum(even(fibonacci_below(4000000))).'''
    p = new_instance()
    total = sum(even(p.fibonacci_below(4000000)))
    print "\nDesired solution is calculated to be '{0}'.".format(total)
    nose.tools.eq_(4613732, total)
    report_cache(p)

@nose.tools.timed(60)
def test_fibonacci_below():
    '''Test fibonacci_below().'''
    p = new_instance()
    total  = p.fibonacci_term( 1)
    total += p.fibonacci_term( 2)
    total += p.fibonacci_term( 3)
    total += p.fibonacci_term( 4)
    total += p.fibonacci_term( 5)
    total += p.fibonacci_term( 6)
    total += p.fibonacci_term( 7)
    total += p.fibonacci_term( 8)
    total += p.fibonacci_term( 9)
    total += p.fibonacci_term(10)
    nose.tools.eq_(total, sum(p.fibonacci_below(100)))
    report_cache(p)

@nose.tools.raises(RuntimeError)
@nose.tools.timed(60)
def test_big_fibonacci():
    '''Test big Fibonacci term (throws upon maximum recursion depth).'''
    p = new_instance()
    index = 100000
    term = p.fibonacci_term(index)
    length = len(str(term))
    print "\nFibonacci term '{0}' has '{1}' digits.".format(index, length)
    report_cache(p)
