# RAF MDP fourth attempt - Include asking for user input as an action

# States: eat, anomaly, success, fail, estop, food, nofood, end
# Actions: stay, quit, input

import sys, os
sys.setrecursionlimit(10000)

### MDP Model ###

class RafMDP():
    def __init__(self):
        # N = number of blocks
        pass

    def startState(self):
        return 'eat'

    def isEnd(self, state):
        if state == 'end':
            return True

    def actions(self, state):
        # Returns a list of actions at a given state
        result = []
        if state == 'estop':
            result.append('quit')
        else:
            result.append('stay')
            result.append('quit')
            # result.append('input')
        return result

    def succProbReward(self, state, action):
        # Returns a list of (newState, prob, reward)
        # state = s, action = a, newState = s'
        # prob = T(s, a, s')
        # reward = Reward(s, a, s')

        # transition_table = {'eat':      {'stay':    [['anomaly', .05,  -5],
        #                                              ['success', 0.8,  10],
        #                                              ['fail',    0.1,  -5],
        #                                              ['estop',   .05, -50]],
        #                                  'quit':    [['end',     1.0,   0]]},
        #                     'anomaly':  {'stay':    [['food',    0.8,   0],
        #                                              ['nofood',  0.2,   0]],
        #                                  'quit':    [['end',     1.0,  -5]]},
        #                     'success':  {'stay':    [['food',    0.8,   0],
        #                                              ['nofood',  0.2,   0]],
        #                                  'quit':    [['end',     1.0,   0]]},
        #                     'fail':     {'stay':    [['food',    0.8,   0],
        #                                              ['nofood',  0.2,   0]],
        #                                  'quit':    [['end',     1.0,   0]]},
        #                     'estop':    {'stay':    [],
        #                                  'quit':    [['end',     1.0,   0]]},
        #                     'food':     {'stay':    [['eat',     1.0,   2]],
        #                                  'quit':    [['end',     1.0,   0]]},
        #                     'nofood':   {'stay':    [['eat',     1.0,   0]],
        #                                  'quit':    [['end',     1.0,   5]]},
        # }

        # transition_table = {'eat':      {'stay':    [['anomaly', .05,  -5],
        #                                              ['success', .84, 10],
        #                                              ['fail',    .05, -10],
        #                                              ['estop',   .01, -50]],
        #                                  'quit':    [['end',     1.0,  -1]]},
        #                     'anomaly':  {'stay':    [['food',    0.8,   5],
        #                                              ['nofood',  0.2,   2]],
        #                                  'quit':    [['end',     1.0,  -5]]},
        #                     'success':  {'stay':    [['food',    0.8,  10],
        #                                              ['nofood',  0.2,   2]],
        #                                  'quit':    [['end',     1.0,  -1]]},
        #                     'fail':     {'stay':    [['food',    0.8,   2],
        #                                              ['nofood',  0.2,  -5]],
        #                                  'quit':    [['end',     1.0,  -1]]},
        #                     'estop':    {'stay':    [],
        #                                  'quit':    [['end',     1.0,  -1]]},
        #                     'food':     {'stay':    [['eat',     1.0,  10]],
        #                                  'quit':    [['end',     1.0,  -1]]},
        #                     'nofood':   {'stay':    [['eat',     1.0,  -1]],
        #                                  'quit':    [['end',     1.0,  5]]},
        # }

        transition_table = {'eat':      {'stay':    [['anomaly', .05,  -1],
                                                     ['success', .84,   1],
                                                     ['fail',    .01,  -1],
                                                     ['estop',   .05,  -1]],
                                         'quit':    [['end',     1.0,   1]]},
                            'anomaly':  {'stay':    [['food',    0.8,  -1],
                                                     ['nofood',  0.2,  -1]],
                                         'quit':    [['end',     1.0,   1]]},
                            'success':  {'stay':    [['food',    0.8,   1],
                                                     ['nofood',  0.2,  -1]],
                                         'quit':    [['end',     1.0,   1]]},
                            'fail':     {'stay':    [['food',    0.8,   1],
                                                     ['nofood',  0.2,  -1]],
                                         'quit':    [['end',     1.0,   1]]},
                            'estop':    {'stay':    [],
                                         'quit':    [['end',     1.0,   1]]},
                            'food':     {'stay':    [['eat',     1.0,   1]],
                                         'quit':    [['end',     1.0,   1]]},
                            'nofood':   {'stay':    [['eat',     1.0,  -1]],
                                         'quit':    [['end',     1.0,   1]]},
        }

        result = transition_table[state][action]
        return result

    def discount(self):
        return 0.5

    def states(self):
        return ['eat', 'anomaly', 'success', 'fail', 'estop', 'food', 'nofood', 'end']

### MDP Inference (Algorithms) ###

def valueIteration(mdp):
    # Initialize
    V = {}  # state -> Vopt[state]
    for state in mdp.states():
        V[state] = 0

    def Q(state, action):
        return sum(prob * (reward + mdp.discount() * V[newState]) \
            for newState, prob, reward in mdp.succProbReward(state, action))

    while True:
        # Compute new values (newV) given the old values (V)
        newV = {}
        for state in mdp.states():
            if mdp.isEnd(state):
                newV[state] = 0
            else:
                newV[state] = max(Q(state, action) for action in mdp.actions(state))
        # Check for convergence
        if max(abs(V[state] - newV[state]) for state in mdp.states()) < 1e-10:
            break
        V = newV

        # Return the policy
        pi = {}
        for state in mdp.states():
            if mdp.isEnd(state):
                pi[state] = 'none'
            else:
                pi[state] = max((Q(state, action), action) for action in mdp.actions(state))[1]

        # Print stuff
        os.system('clear')
        print('{:>8} {:>20} {:>15}'.format('s', 'V(s)', 'pi(s)'))
        print('--------------------------------------------------')
        for state in mdp.states():
            print('{:>8} {:>20} {:>15}'.format(state, V[state], pi[state]))
        input()

mdp = RafMDP()

valueIteration(mdp)