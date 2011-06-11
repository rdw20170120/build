''' generation tests
'''

from project_euler.solution.generation import infinite
from project_euler.solution.generation import pseudo_infinite_range_limit

def test_pseudo_infinite_sum():
    '''Test sum of a pseudo-infinite sequence (avoid RAM abuse).
    
       NOTE:  This does NOT use up RAM, so it is possible to avoid that usage.
    '''
    terms = pseudo_infinite_range_limit
    total = sum(value for value in infinite())
    message = "\nSum of infinite() of about '{0}' terms is '{1}'."
    print message.format(terms, total)
