# RAF MDP first attempt

import sys, os
sys.setrecursionlimit(10000)

### MDP Model ###

class RafMDP():
    def __init__(self):
        # N = number of blocks
        pass

    def startState(self):
        return 'food'

    def isEnd(self, state):
        if state == 'fail' or state == 'success':
            return True

    def actions(self, state):
        # Returns a list of actions at a given state
        result = []
        if state == 'food':
            result.append('grasp')
            result.append('skewer')
            result.append('scoop')
        return result

    def succProbReward(self, state, action):
        # Returns a list of (newState, prob, reward)
        # state = s, action = a, newState = s'
        # prob = T(s, a, s')
        # reward = Reward(s, a, s')
        result = []
        if action == 'grasp':
            result.append(('food', .1, -1))
            result.append(('fail', .1, -100))
            result.append(('success', .8, 50))
        elif action == 'skewer':
            result.append(('food', .3, -1))
            result.append(('fail', .3, -100))
            result.append(('success', .4, 50))
        elif action == 'scoop':
            result.append(('food', .05, -1))
            result.append(('fail', .35, -100))
            result.append(('success', .6, 50))
        return result

    def discount(self):
        return 1

    def states(self):
        return ['food', 'fail', 'success']

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