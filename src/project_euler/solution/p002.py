''' Project Euler Problem 2 solution elements
'''

from project_euler.solution.generation import infinite

# Cache for Fibonacci sequence to make recursion feasible
cache = {0:1, 1:1}

def fibonacci_term(index):
    '''Return "index"th term of the Fibonacci sequence.
    
       By definition, fibonacci_term(1) == 1 and fibonacci_term(2) = 2,
       so extend to fibonacci_term(0) == 1 for completeness.
       
       Recursive implementation is simple and effective, but not efficient.
       
       Cacheing makes recursion feasible.
    '''
    if 0 > index:
        raise IndexError(
            "Index '{0}' is below zero and therefore invalid!".format(index)
        )
    if not index in cache:
        cache[index] = fibonacci_term(index - 1) + fibonacci_term(index - 2)
    return cache[index]

def fibonacci(count=None):
    '''Return the first "count" terms of the Fibonacci sequence.
    
       If count is None, return an "infinite" Fibonacci sequence.
    '''
    if count is None:
        return (fibonacci_term(i) for i in infinite(1))
    else:
        return (fibonacci_term(i) for i in xrange(1, count + 1))

def fibonacci_below(limit):
    '''Return the first terms of the Fibonacci sequence below "limit".
    
       Use the non-generator algorithm.
    '''
    return (value for value in fibonacci() if value < limit)

# def fibonacci_generator():
#     '''Return the terms of the Fibonacci sequence.
#     
#        Use a generator to produce the infinite sequence, without RAM usage.
#     '''
#     prv, nxt = 1, 1
#     while 1:
#         print "Yielding {0}...".format(prv)
#         yield prv
#         prv, nxt = nxt, prv + nxt

# def fibonacci_below_via_generator(limit):
#     '''Return the first terms of the Fibonacci sequence below "limit".
#     
#        Use the generator algorithm.
#     '''
#     return (value for value in fibonacci_generator() if value < limit)
