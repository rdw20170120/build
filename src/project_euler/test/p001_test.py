'''
Project Euler Problem 1

see doc/ProjectEuler-001.txt for details
'''

import nose.tools

from project_euler.solution.p001 import desired_multiples_below
from project_euler.solution.p001 import is_desired_multiple

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

@nose.tools.timed(60)
def test_solution():
    '''Test sum(desired_multiples_below(1000)).'''
    total = sum(desired_multiples_below(1000))
    print "\nDesired solution is calculated to be '{0}'.".format(total)
    nose.tools.eq_(233168, total)
