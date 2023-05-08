%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAF_RL.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This script runs a simulated version of an MDP for robot-
% assisted feeding. The idea is to ask the user for inputs until their 
% responses become consistent, then taper off the need for input. In this
% way, the system "learns" the user's preferences and reduces the 
% cognitive burden on the user over time.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 3/20/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Epsilon Greedy Q-Learning

clear; clc; close all

states = ["eat", "anomaly", "success", "fail", "estop", "food", "nofood", "end"];
actions = ["input", "stay", "quit"];

qValue = -1*ones(length(states), length(actions));
% qValue = randn(length(states), length(actions));

% 5 episodes of gamma=0.75, alpha=1, alpha_i=0.75
% qValue = [-0.6250    3.8170         0;...
%                 0         0         0;...
%           -0.9048    7.6621         0;...
%                 0         0         0;...
%            0.9023   -9.5430         0;...
%           -0.6177    3.7747         0;...
%           -0.7500    1.0000         0;...
%                 0         0   -1.0000];

% Values that have worked in the past:
% gamma = .75;     
% alpha = 1;       
% alpha_i = .9;      
% input_threshold = 0;
% epsilon = 0.2;
% decay = 0.05

gamma = .75;            % (0 - 1): Discount factor
alpha = .9;             % (0 - 1): If alpha is 1, we only care about immediate reward
alpha_i = .9;           % (0 - 1): If alpha_i is 1, we only care about immediate input reward
input_threshold = 0;    % (): 
decay = 0.05;           % (0 - 1): Higher decay means Q-value decays over time faster 

state = "eat";
food_count = 0;

sumIterations = 0;
highestIteration = 0;

epsilon = 0.5;     % If epsilon is 1, we only explore, if epsilon is 0, we only exploit
simulate = 1;

maxIterations = 200;        % Max steps to take per episode
numEpisodes = 200;
for episode = 1:1:numEpisodes
    fprintf('\n----- Plate %i -----\n', episode)
    inCount = 0;
    for iteration = 1:1:maxIterations
        initialState = state;
        state_idx = find(strcmp(states, initialState));
        
        if initialState == "end"
            fprintf('Episode Done. Final State: %s, Iterations: %i\n', state, iteration)
            fprintf('Food items eaten: %i\n', food_count)
            fprintf('\nPlate %i finished. Number of required inputs: %i \n', episode, inCount);
            break
        end
        
        % TEST: approx small values as zero
        if abs(qValue(state_idx, 1)) < 1e-6
            qValue(state_idx, 1) = 0;
        end
        
        if qValue(state_idx, 1) <= input_threshold
            % Ask for input
        
            % First decide on action
            e = rand(1);
            if e <= epsilon
                % Do random action
                pred_a = round((length(actions)-1)*rand(1,1) + 1.5);    % 2 or 3
                pred_action = actions(pred_a);
            else
                % Follow optimal policy
                pred_a = find(squeeze(qValue(state_idx,:)) == max(squeeze(qValue(state_idx,:))));
                if length(pred_a) > 1
                    pos = randi(length(pred_a));
                    pred_a = pred_a(pos);
                end
                pred_action = actions(pred_a);
            end

            % Ask for user input
            inCount = inCount + 1;
            if simulate == 1
                action = simQuery(initialState, actions);
            else
                action = query(initialState, actions);
            end

            % If actions match, give reward
            if strcmp(pred_action, action)
                r_input = 1;
            else
                r_input = -1;
            end
            
            % Update Input Q-value
            qValue(state_idx, 1) = (1-alpha_i)*qValue(state_idx, 1) + alpha_i*r_input;
        else
            % Drop the input Q-value slightly as time goes on
            qValue(state_idx,1) = (1 - decay)*qValue(state_idx,1);
            % Follow the optimal policy
            a = find(squeeze(qValue(state_idx,:)) == max(squeeze(qValue(state_idx,:))));
            if length(a) > 1
                pos = randi(length(a));
                a = a(pos);
            end
            action = actions(a);
            if (action == "input" && simulate == 1)
                action = simQuery(initialState, actions);
            elseif (action == "input" && simulate ~= 1)
                action = query(initialState, actions);
            end
        end
        
        % Carry out action and compute next state
        finalState = transition(initialState, action, actions);
        if finalState == "success"
            food_count = food_count + 1;
        end
        
        % Compute Reward
        r = reward(finalState);
        
        % Update state/action Q-value
        finalState_idx = find(strcmp(states, finalState));
        action_idx = find(strcmp(actions, action));
        sample = r + gamma*max(qValue(finalState_idx, :));
        qValue(finalState_idx, action_idx) = (1-alpha)*qValue(finalState_idx, action_idx) + alpha*sample;
        state = finalState;
        fprintf('%10s %10s %10s %10s\n', '', 'Input', 'Stay', 'Quit')
        for st = 1:1:length(states)
            fprintf('%10s %10f %10f %10f\n', states(st), qValue(st, 1), qValue(st, 2), qValue(st, 3))
        end
        fprintf('\n')
    end
    
    if iteration == maxIterations
        warning('Max Iterations Reached on episode %i\n', episode)
    end

    sumIterations = sumIterations + iteration;
    if iteration > highestIteration
        highestIteration = iteration;
    end
    
    state = 'eat';
    inCount_array(episode) = inCount;
    qValue_array(:,:,episode) = qValue;
end

avgIterations = sumIterations/numEpisodes;
fprintf('---------------- Summary ----------------\n')
fprintf('Average iterations per episode: %2.2f\n', avgIterations)
fprintf('Highest number of iterations reached: %i\n', highestIteration)

figure
plot(inCount_array, 'o-')
xlabel('Plate Number')
ylabel('Number of Inputs')

figure
subplot(8,3,1)
plot(squeeze(qValue_array(1,1,:)))
title('Eat/Input')
ylabel('Q-Value')

subplot(8,3,2)
plot(squeeze(qValue_array(1,2,:)))
title('Eat/Stay')

subplot(8,3,3)
plot(squeeze(qValue_array(1,3,:)))
title('Eat/Quit')

subplot(8,3,4)
plot(squeeze(qValue_array(2,1,:)))
title('Anomaly/Input')
ylabel('Q-Value')

subplot(8,3,5)
plot(squeeze(qValue_array(2,2,:)))
title('Anomaly/Stay')

subplot(8,3,6)
plot(squeeze(qValue_array(2,3,:)))
title('Anomaly/Quit')

subplot(8,3,7)
plot(squeeze(qValue_array(3,1,:)))
title('Success/Input')
ylabel('Q-Value')

subplot(8,3,8)
plot(squeeze(qValue_array(3,2,:)))
title('Success/Stay')

subplot(8,3,9)
plot(squeeze(qValue_array(3,3,:)))
title('Success/Quit')

subplot(8,3,10)
plot(squeeze(qValue_array(4,1,:)))
title('Fail/Input')
ylabel('Q-Value')

subplot(8,3,11)
plot(squeeze(qValue_array(4,2,:)))
title('Fail/Stay')

subplot(8,3,12)
plot(squeeze(qValue_array(4,3,:)))
title('Fail/Quit')

subplot(8,3,13)
plot(squeeze(qValue_array(5,1,:)))
title('E-Stop/Input')
ylabel('Q-Value')

subplot(8,3,14)
plot(squeeze(qValue_array(5,2,:)))
title('E-Stop/Stay')

subplot(8,3,15)
plot(squeeze(qValue_array(5,3,:)))
title('E-Stop/Quit')

subplot(8,3,16)
plot(squeeze(qValue_array(6,1,:)))
title('Food/Input')
ylabel('Q-Value')

subplot(8,3,17)
plot(squeeze(qValue_array(6,2,:)))
title('Food/Stay')


subplot(8,3,18)
plot(squeeze(qValue_array(6,3,:)))
title('Food/Quit')

subplot(8,3,19)
plot(squeeze(qValue_array(7,1,:)))
title('No Food/Input')
ylabel('Q-Value')

subplot(8,3,20)
plot(squeeze(qValue_array(7,2,:)))
title('No Food/Stay')

subplot(8,3,21)
plot(squeeze(qValue_array(7,3,:)))
title('No Food/Quit')

subplot(8,3,22)
plot(squeeze(qValue_array(8,1,:)))
title('End/Input')
ylabel('Q-Value')
xlabel('Plate Number')

subplot(8,3,23)
plot(squeeze(qValue_array(8,2,:)))
title('End/Stay')
xlabel('Plate Number')

subplot(8,3,24)
plot(squeeze(qValue_array(8,3,:)))
title('End/Quit')
xlabel('Plate Number')