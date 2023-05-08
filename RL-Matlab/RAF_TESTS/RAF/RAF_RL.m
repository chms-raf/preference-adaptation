%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAF_RL.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This script runs a simulated version of an MDP for robot-
% assisted feeding. The idea is to ask the user for inputs until their 
% responses become consistent, then taper off the need for input. In this
% way, the system "learns" the user's preferences and reduces the 
% cognitive burden on the user over time.

% This version is a more realistic simulation. It has a fixed number of
% food items per plate and keeps track of when it is successful or not.

% This is the final version. Based on previous test versions.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 4/7/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ideas:
% 1) Don't compare user input to predicted action when we are exploring

clear; 
clc; 
close all

dfile ='RAF_RL.txt';
if exist(dfile, 'file') ; delete(dfile); end
diary(dfile)
diary on

states = ["eat", "anomaly", "success", "fail", "estop", "food", "nofood", "end"];
actions = ["input", "stay", "quit"];

qValue = -1*ones(length(states), length(actions));

simulate = 1;       % If simulate is 1, we simulate, else, we query the user

% Values that have worked in the past:
% gamma = .75;     
% alpha = 1;       
% alpha_i = .9;      
% input_threshold = 1e-9;
% epsilon = 0.2 or 0.5;
% decay = 0.05

gamma = .75;            % (0 - 1): Discount factor
alpha = .5;             % (0 - 1): If alpha is 1, we only care about immediate reward
alpha_i = .9;           % (0 - 1): If alpha_i is 1, we only care about immediate input reward
input_threshold = 1e-9; % ~0: The closer to zero, the less input required over time
epsilon = 0.5;     % If epsilon is 1, we only explore, if epsilon is 0, we only exploit
decay = 0.05;           % (0 - 1): Higher decay means Q-value decays over time faster 

state = "eat";                % Initial state
total_successes = 0;          % Total number of successfully eaten food items
total_failures = 0;           % Total number of failed food items
total_anomalies = 0;          % Total number of anomalies
total_estops = 0;             % Total number of e-stops

sumIterations = 0;
highestIteration = 0;

food_per_plate = 6;         % Number of food items per plate. 

maxIterations = 200;        % Max steps to take per episode
numEpisodes = 200;
for episode = 1:1:numEpisodes
    fprintf('\n----- Plate %i -----\n', episode)
    inCount = 0;                        % Number of inputs required per plate
    food_num = food_per_plate;          % Food items per plate
    successes = 0;                      % Successes per plate
    failures = 0;                       % Failures per plate
    anomalies = 0;                      % Anomalies per plate
    estops = 0;                         % E-stops per plate
    for iteration = 1:1:maxIterations
        initialState = state;
        state_idx = find(strcmp(states, initialState));
        
        if initialState == "end"
            % Print metrics and quit episode
            total = total_successes + total_failures + total_anomalies + total_estops;
            fprintf('Episode Done. Final State: %s, Iterations: %i\n', state, iteration)
            fprintf('Successes: %i\n', successes)
            fprintf('Failures: %i\n', failures)
            fprintf('Anomalies: %i\n', anomalies)
            fprintf('E-stops: %i\n', estops)
            fprintf('Remaining food items: %i\n', food_num)
            fprintf('\nPlate %i finished. Number of required inputs: %i \n', episode, inCount);
            fprintf('--------\n')
            fprintf('Successes so far: %i\n', total_successes)
            fprintf('Failures so far: %i\n', total_failures)
            fprintf('Anomalies so far: %i\n', total_anomalies)
            fprintf('E-stops so far: %i\n', total_estops)
            break
        end
        
        if qValue(state_idx, 1) <= input_threshold        
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
                if episode > 100
                    action = simQuery_adversary(initialState, food_num);
                else
                    action = simQuery(initialState);
                end
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
                if episode > 100
                    action = simQuery_adversary(initialState, food_num);
                else
                    action = simQuery(initialState);
                end
            elseif (action == "input" && simulate ~= 1)
                action = query(initialState);
            end
        end
        
        % Carry out action and compute next state
        finalState = transition_2(initialState, action, actions, food_num);
%         fprintf('%s --> %s --> %s\n\n', initialState, action, finalState);
        
        % Track metrics
        if finalState == "success"
            successes = successes + 1;
            total_successes = total_successes + 1;
            % Remove one food item from plate
            food_num = food_num - 1;
        elseif finalState == "fail"
            failures = failures + 1;
            total_failures = total_failures + 1;
            % Assume fail is acquisition failure so no food_num reduction
            % TODO: Add another state to handle type of total_failures?
        elseif finalState == "anomaly"
            anomalies = anomalies + 1;
            total_anomalies = total_anomalies + 1;
        elseif finalState == "estop"
            estops = estops + 1;
            total_estops = total_estops + 1;
        end
        
        % Compute Reward
        r = reward(finalState);
        
        % Update state/action Q-value
        finalState_idx = find(strcmp(states, finalState));
        action_idx = find(strcmp(actions, action));
        sample = r + gamma*max(qValue(finalState_idx, :));
        qValue(state_idx, action_idx) = (1-alpha)*qValue(state_idx, action_idx) + alpha*sample;
        state = finalState;
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
fprintf('\n---------------- Summary ----------------\n')
fprintf('Average iterations per episode: %2.2f\n', avgIterations)
fprintf('Highest number of iterations reached: %i\n', highestIteration)
fprintf('Total Successes: %i (%2.1f%%)\n', total_successes, (total_successes/total)*100)
fprintf('Total Failures: %i (%2.1f%%)\n', total_failures, (total_failures/total)*100)
fprintf('Total Anomalies: %i (%2.1f%%)\n', total_anomalies, (total_anomalies/total)*100)
fprintf('Total E-stops: %i (%2.1f%%)\n', total_estops, (total_estops/total)*100)
fprintf('Total Inputs Required: %i\n', sum(inCount_array))
fprintf('\n')

fprintf('Q-Values:\n')
fprintf('%10s %10s %10s %10s\n', '', 'Input', 'Stay', 'Quit')
for st = 1:1:length(states)
    fprintf('%10s %10f %10f %10f\n', states(st), qValue(st, 1), qValue(st, 2), qValue(st, 3))
end
fprintf('\n')

fprintf('Optimal Policy: \n')
fprintf('%10s %15s\n', 'State', 'Action')
fprintf('-------------------------------\n')
for st = 1:1:length(states)
    fprintf('%10s --> %10s\n', states(st), actions(find(squeeze(qValue(st,:)) == max(squeeze(qValue(st,:))))))
end

figure
plot(inCount_array, 'o-')
xlabel('Plate Number')
ylabel('Number of Inputs')

savefig('RAF_RL_Inputs')

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

savefig('RAF_RL_QValues')

diary off