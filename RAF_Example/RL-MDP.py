# Simulating Reinforcement Learning using RAF MDP Attempt #4

# States: eat, anomaly, success, fail, estop, food, nofood, end
# Actions: stay, quit, input

import sys, os, random
sys.setrecursionlimit(10000)

### MDP Model ###

class RafMDP():
    def __init__(self, discount=0.5):
        # N = number of blocks
        self.discount = discount
        self.transition = self.initTransition()

    def startState(self):
        return 'eat'

    def isEnd(self, state):
        if state == 'end':
            return True

    def initTransition(self):
        # TODO: Should I initialize with zeros or random rewards?
        transition_table = {'eat':      {'stay':    [['anomaly', 0.25,  0],
                                                     ['success', 0.25,  0],
                                                     ['fail',    0.25,  0],
                                                     ['estop',   0.25,  0]],
                                         'quit':    [['end',     1.0,   0]]},
                            'anomaly':  {'stay':    [['food',    0.5,   0],
                                                     ['nofood',  0.5,   0]],
                                         'quit':    [['end',     1.0,   0]]},
                            'success':  {'stay':    [['food',    0.5,   0],
                                                     ['nofood',  0.5,   0]],
                                         'quit':    [['end',     1.0,   0]]},
                            'fail':     {'stay':    [['food',    0.5,   0],
                                                     ['nofood',  0.5,   0]],
                                         'quit':    [['end',     1.0,   0]]},
                            'estop':    {'stay':    [],
                                         'quit':    [['end',     1.0,   0]]},
                            'food':     {'stay':    [['eat',     1.0,   0]],
                                         'quit':    [['end',     1.0,   0]]},
                            'nofood':   {'stay':    [['eat',     1.0,   0]],
                                         'quit':    [['end',     1.0,   0]]},
        }
        return transition_table

    def updateTransition(self, state, action, reward):
        self.transition[state][action]

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

        result = self.transition_table[state][action]
        return result

    def discount(self):
        return self.discount

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

def reinforcementLearning(mdp, iter):
    state = mdp.startState()
    count = 0
    while True:
        if count >= iter:
            break

        print('Current State: ', state)
        # 1) MDP decide random action based on state
        action = random.choice(list(mdp.transition[state].keys()))

        # 2) Ask user what action we should take
        user_action = input('What action should I take?\n')

        # 3) Update rewards: +1 for right, -1 for wrong
        if action == user_action:
            mdp.updateTransition(state, action, reward)
            
        else:
            pass
        # 4) Ask user what the next state is
        # 5) Keep track of new state based on previous action
        # 6) Repeat

        if mdp.isEnd(state):
            count += 1




def main():
    # Initialize the MDP
    discount = 0.5
    mdp = RafMDP(discount)

    # Start RL simulation
    # MDP transition table will be updated based on user input
    iterations = 1
    reinforcementLearning(mdp, iterations)

    # valueIteration(mdp)

if __name__ == '__main__':
    sys.exit(main())