# RAF MDP third attempt - Can't be that simple or it's trivial

# States: eat, success, fail, estop, end
# Actions: stay, quit

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
        if state == 'eat' or state == 'success' or state == 'fail':
            result.append('stay')
            result.append('quit')
        elif state == 'estop':
            result.append('quit')
        return result

    def succProbReward(self, state, action):
        # Returns a list of (newState, prob, reward)
        # state = s, action = a, newState = s'
        # prob = T(s, a, s')
        # reward = Reward(s, a, s')
        result = []
        if state == 'eat' and action == 'stay':
            result.append(('estop', .1, -10))
            result.append(('fail', .1, -5))
            result.append(('success', .8, 5))
        elif state == 'eat' and action == 'quit':
            result.append(('end', 1, 2))
        elif state == 'success' and action == 'stay':
            result.append(('eat', 1, 2))
        elif state == 'success' and action == 'quit':
            result.append(('end', 1, 2))
        elif state == 'fail' and action == 'stay':
            result.append(('eat', 1, 2))
        elif state == 'fail' and action == 'quit':
            result.append(('end', 1, 2))
        elif state == 'end' and action == 'quit':
            result.append(('end', 1, 2))
        return result

    def discount(self):
        return 0.5

    def states(self):
        return ['eat', 'success', 'fail', 'estop', 'end']

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