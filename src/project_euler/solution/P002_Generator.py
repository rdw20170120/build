'''
Project Euler Problem 2

see doc/ProjectEuler-002.txt for details
'''

from project_euler.solution.generation import pseudo_infinite

class P002_Generator(object):
    '''TODO:  describe.'''
    def cache_size(self):
        '''Return the size of the cache.
        
           Since a cache is not used in this class, always return zero.
        '''
        return 0

    def fibonacci_term(self, index):
        '''Return "index"th term of the Fibonacci sequence.

           By definition, fibonacci_term(1) == 1 and fibonacci_term(2) = 2,
           so extend to fibonacci_term(0) == 1 for completeness.

           Recursive implementation is simple and effective, but not efficient.

           Cacheing makes recursion more feasible.
        '''
        if 0 > index:
            raise IndexError(
                "Index '{0}' is below zero, therefore invalid!".format(index)
            )
        if not index in self._cache:
            self._cache[index] = (
                self.fibonacci_term(index - 1) + self.fibonacci_term(index - 2)
            )
        return self._cache[index]

    def fibonacci(self):
        '''Return the terms of the Fibonacci sequence.'''
        prv, nxt = 1, 1
        while 1:
            yield prv
            prv, nxt = nxt, prv + nxt

    def fibonacci_below(self, limit):
        '''Return the first terms of the Fibonacci sequence below "limit".
        
           Use the non-generator algorithm.
        '''
        return (value for value in self.fibonacci() if value < limit)

    def __init__(self):
        pass
