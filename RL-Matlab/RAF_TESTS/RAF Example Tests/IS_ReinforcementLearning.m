% Robot-Assisted Feeding Reinforcement Learning
% Created by Jack Schultz
% Feb 14, 2023

%% Program Episodes

clear; clc; close all

states = ["eat", "anomaly", "success", "fail", "estop", "food", "nofood", "end"];
actions = ["input", "stay", "quit"];

qValue = zeros(length(states), length(actions));
state = "eat";
gamma = .75;
alpha = 1;
food_count = 0;
saturate = 2;
outIter = 5;

inCount_array = zeros(length(outIter));
for j = 1:1:outIter
    fprintf('\n----- Plate %i -----\n', j)
    inCount = 0;
    maxIterations = 100;        % Max steps to take per episode
    for iteration = 1:1:maxIterations
        initialState = state;
        state_idx = find(strcmp(states, initialState));
        switch state
            case "eat"
                if abs(qValue(state_idx, 1)) <= saturate
                    action = actions(1);
                    a = 1;
                else
                    % Stay
                    action = actions(2);
                    a = 2;
                end
            case "anomaly"
                if abs(qValue(state_idx, 1)) <= saturate
                    action = actions(1);
                    a = 1;
                else
                    % Input
                    action = actions(2);
                    a = 2;
                end
            case "success"
                if abs(qValue(state_idx, 1)) <= saturate
                    action = actions(1);
                    a = 1;
                else
                    % Stay
                    action = actions(2);
                    a = 2;
                end
            case "fail"
                if abs(qValue(state_idx, 1)) <= saturate
                    action = actions(1);
                    a = 1;
                else
                    % Stay
                    action = actions(2);
                    a = 2;
                end
            case "estop"
                fprintf('E-STOP PRESSED!\n')
                % Quit
                action = actions(3);
                a = 3;
            case "food"
                if abs(qValue(state_idx, 1)) <= saturate
                    action = actions(1);
                    a = 1;
                else
                    % Stay
                    action = actions(2);
                    a = 2;
                end
            case "nofood"
                if abs(qValue(state_idx, 1)) <= saturate
                    action = actions(1);
                    a = 1;
                else
                    % Quit
                    action = actions(3);
                    a = 3;
                end
            case "end"
                fprintf('Episode Done. Final State: %s, Iterations: %i\n', state, iteration)
                fprintf('Food items eaten: %i\n', food_count)
                fprintf('\nPlate %i finished. Number of required inputs: %i \n', j, inCount);
                break
        end
        if action == "input"
            inCount = inCount + 1;
        end
        finalState = transition(initialState, action, actions);
        if finalState == "success"
            food_count = food_count + 1;
        end
        r = reward(finalState);
        finalState_idx = find(strcmp(states,finalState));
        sample = r + gamma*max(qValue(finalState_idx, :));
        qValue(finalState_idx,a) = (1-alpha)*qValue(finalState_idx,a) + alpha*sample;
        state = finalState;
        disp(qValue)
    end

    if iteration == maxIterations
        warning('Max Iterations Reached')
    end
    
    state = 'eat';
    inCount_array(j) = inCount;
end

figure
plot(inCount_array)
xlabel('Plate Number')
ylabel('Number of Inputs')

%%
disp('Hit Enter to continue to part b')
pause

%% Value Iteration

clear; clc; close all

states = ["eat", "anomaly", "success", "fail", "estop", "food", "nofood", "end"];
actions = ["input", "stay", "quit"];

qValue = zeros(length(states), length(actions));

gamma = .5;
alpha = 1;

state = "eat";
food_count = 0;

sumIterations = 0;
highestIteration = 0;

maxIterations = 200;        % Max steps to take per episode
numEpisodes = 5;
for episode = 1:1:numEpisodes
    fprintf('\n----- Plate %i -----\n', episode)
    inCount = 0;
    for iteration = 1:1:maxIterations
        initialState = state;
        state_idx = find(strcmp(states, initialState));
        switch state
            case "eat"
                a = round(length(actions)*rand(1,1) + .5);
                action = actions(a);
            case "anomaly"
                a = round(length(actions)*rand(1,1) + .5);
                action = actions(a);
            case "success"
                a = round(length(actions)*rand(1,1) + .5);
                action = actions(a);
            case "fail"
                a = round(length(actions)*rand(1,1) + .5);
                action = actions(a);
            case "estop"
                a = round(length(actions)*rand(1,1) + .5);
                action = actions(a);
            case "food"
                a = round(length(actions)*rand(1,1) + .5);
                action = actions(a);
            case "nofood"
                a = round(length(actions)*rand(1,1) + .5);
                action = actions(a);
            case "end"
                fprintf('Episode Done. Final State: %s, Iterations: %i\n', state, iteration)
                fprintf('Food items eaten: %i\n', food_count)
                fprintf('\nPlate %i finished. Number of required inputs: %i \n', episode, inCount);
                break
        end
        if action == "input"
            inCount = inCount + 1;
        end
        finalState = transition(initialState, action, actions);
        if finalState == "success"
            food_count = food_count + 1;
        end
        finalState = transition(initialState, action, actions);
        r = reward(finalState);
        finalState_idx = find(strcmp(states,finalState));
        sample = r + gamma*max(qValue(finalState_idx, :));
        qValue(finalState_idx,a) = (1-alpha)*qValue(finalState_idx,a) + alpha*sample;
        state = finalState;
        disp(qValue)
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
end

avgIterations = sumIterations/numEpisodes;
fprintf('Average iterations per episode: %2.2f\n', avgIterations)
fprintf('Highest number of iterations reached: %i\n', highestIteration)

%%
disp('Hit Enter to continue to part c')
pause

%% Epsilon Greedy Q-Learning

clear; clc; close all

states = ["eat", "anomaly", "success", "fail", "estop", "food", "nofood", "end"];
actions = ["input", "stay", "quit"];

% qValue = zeros(length(states), length(actions));
qValue = randn(length(states), length(actions));

% 5 episodes of gamma=0.75, alpha=1, alpha_i=0.75
% qValue = [-0.6250    3.8170         0;...
%                 0         0         0;...
%           -0.9048    7.6621         0;...
%                 0         0         0;...
%            0.9023   -9.5430         0;...
%           -0.6177    3.7747         0;...
%           -0.7500    1.0000         0;...
%                 0         0   -1.0000];

gamma = .75;        % Discount factor
alpha = 1;        % If alpha is 1, we only care about immediate reward
alpha_i = .9;      % If alpha is 1, we only care about immediate input reward
input_threshold = 0;

state = "eat";
food_count = 0;

sumIterations = 0;
highestIteration = 0;

epsilon = 0.01;
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
            qValue(state_idx,1) = .95*qValue(state_idx,1);
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
end

avgIterations = sumIterations/numEpisodes;
fprintf('---------------- Summary ----------------\n')
fprintf('Average iterations per episode: %2.2f\n', avgIterations)
fprintf('Highest number of iterations reached: %i\n', highestIteration)

figure
plot(inCount_array)
xlabel('Plate Number')
ylabel('Number of Inputs')
