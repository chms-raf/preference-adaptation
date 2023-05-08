# This is an example of a Markov Decision Process
# The example is from Stanford CS221: AI (Autumn 2019)

# You have the option of walking or taking the tram
# Walking gives you a 100% chance of getting to state+1 with -1 reward
# Taking the tram gives you a 50% chance of getting to state*2 with -2 reward
# and a 50% chance of failing and staying in the current state with -2 reward

import sys, os
sys.setrecursionlimit(10000)

### MDP Model ###

class TransportationMDP():
    def __init__(self, N):
        # N = number of blocks
        self.N = N

    def startState(self):
        return 1

    def isEnd(self, state):
        return state == self.N

    def actions(self, state):
        # Returns a list of actions at a given state
        result = []
        if state + 1 <= self.N:
            result.append('walk')
        if state * 2 <= self.N:
            result.append('tram')
        return result

    def succProbReward(self, state, action):
        # Returns a list of (newState, prob, reward)
        # state = s, action = a, newState = s'
        # prob = T(s, a, s')
        # reward = Reward(s, a, s')
        result = []
        if action == 'walk':
            result.append((state + 1, 1, -1))
        elif action == 'tram':
            failProb = 0.5
            result.append((state * 2, 1-failProb, -2))   # Tram did not fail
            result.append((state, failProb, -2))       # Tram failed
        return result

    def discount(self):
        return 1

    def states(self):
        return range(1, self.N + 1)

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
        print('{:>2} {:>20} {:>15}'.format('s', 'V(s)', 'pi(s)'))
        print('----------------------------------------')
        for state in mdp.states():
            print('{:>2} {:>20} {:>15}'.format(state, V[state], pi[state]))
        input()

mdp = TransportationMDP(N=10)

valueIteration(mdp)