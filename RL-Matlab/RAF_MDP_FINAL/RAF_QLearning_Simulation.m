%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAF_QLearning_Simulation.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This code simulates a feeding scenario defined by a Markov 
% Decision Process. We use a modified Q-Learning appoach where there exists
% a shared human-robot decision making framework in the form of an "input"
% action. Q-values are updated simultaneously for the "input" state-action
% pairs.
% ---------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 4/9/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housekeeping
clear; 
clc; 
close all

%% Initialize
% Setup diary file
setup_diary('RAF_Simple.txt')

% Define States and Actions
states = ["eat", "anomaly", "success", "fail", "food", "nofood", "end"];
actions = ["input", "stay", "quit"];

% Initialize Q-Values
qValue = zeros(length(states), length(actions));

% Define Parameters
% Epsilon-Greedy parameter: Closer to 1 means more exploration
epsilon = 0.05;

% Define Learning Rate: Closer to 1 means faster learning
% Note: Good starting point is 1/sqrt(# of updates to (s,a))
alpha = 0.02;

% Define Discount Factor: Closer to 1 means future rewards are more important
% Note: must be less than 1 for cyclic MDPs
gamma = 0.95;

% Define Initial State
state = "eat";

% Initialize Metrics
% Total number of successfully eaten food items
total_successes = 0;
% Total number of failed food items
total_failures = 0;
% Total number of anomalies
total_anomalies = 0;
% Total number of e-stops
total_estops = 0;
% Total number of iterations
sumIterations = 0;
% Highest iteration reached
highestIteration = 0;
% Inputs per state
inCount_state = zeros(1,length(states));

% Define number of food items per plate
food_per_plate = 6; 

% Define max steps to take per episode
maxIterations = 100; 

% Define number of episodes (plates)
numEpisodes = 100;

% Enable (1) or disable (0) simulating user input
simulate = 1;

% if simulation is enabled, define the character type
% Options: "hungry", "full", "indecisive"
character = "hungry";

%% Epsilon-Greedy Q-Learning
inCount_array = zeros(numEpisodes,1);
qValue_array = zeros(length(states), length(actions), numEpisodes);
for episode = 1:1:numEpisodes
    fprintf('\n----- Plate %i -----\n', episode)
    inCount = 0;                        % Number of inputs required per plate
    food_num = food_per_plate;          % Food items per plate
    successes = 0;                      % Successes per plate
    failures = 0;                       % Failures per plate
    anomalies = 0;                      % Anomalies per plate

    for iteration = 1:1:maxIterations
        initialState = state;
        state_idx = find(strcmp(states, initialState));
        input_idx = find(strcmp(actions, "input"));
        input_reward = 0;
        
        if initialState == "end"
            % Print metrics and quit episode
            print_metrics(total_successes, total_failures, total_anomalies, state, iteration, successes, failures, anomalies, food_num, episode, inCount)
            break
        end
        
        % 1) Pick an action
        % Choose random action with probability epsilon
        e = rand(1);
        if e <= epsilon
            idx = randperm(length(actions),2);
            action_arr = actions(idx);
        else
            % Follow the optimal policy with probability (1-epsilon)
            if length(unique(qValue(state_idx,:))) == 1
                % All Q-values are equal, pick random 2
                idx = randperm(length(actions),2);
                action_arr = actions(idx);
            else
                % Choose highest 2 Q-values
                max_arr = maxk(qValue(state_idx,:),2);
                max_arr = sort(max_arr, 'descend');
                idx_1 = find(qValue(state_idx,:)==max_arr(1));
                if length(idx_1) > 1
                    pos = randi(length(idx_1));
                    idx_1 = idx_1(pos);
                end
                idx_2 = find(qValue(state_idx,:)==max_arr(2));
                if length(idx_2) > 1
                    pos = randi(length(idx_2));
                    idx_2 = idx_2(pos);
                end
                action_arr = actions([idx_1,idx_2]);
            end
        end
        
        % 2) Determine Next State
        if action_arr(1) == "input"
            isInput = true;
            pred_action = action_arr(2);
            inCount = inCount + 1;
            if simulate == 1
                user_action = simQuery(initialState, character);
            else
                user_action = query(initialState, actions);
            end
            
            % 2.5) Recieve input reward.
            % Note: If the predicted action is the same as the user's desire,
            % reduce the input reward. This is counter-intuitive. If the
            % user and system continue to agree, we want to ask for input
            % less frequently.
            if user_action == pred_action
                input_reward = -1;
            else
                input_reward = 1;
            end
            action = user_action;
            inCount_state(state_idx) = inCount_state(state_idx) + 1;
        else
            isInput = false;
            action = action_arr(1);
        end
        
        finalState = transition(initialState, action, food_num);
        
        % Housekeeping
        switch finalState
            case "success"
                food_num = food_num - 1;
                successes = successes + 1;
                total_successes = total_successes + 1;
            case "fail"
                failures = failures + 1;
                total_failures = total_failures + 1;
            case "anomaly"
                anomalies = anomalies + 1;
                total_anomalies = total_anomalies + 1;
        end

        % 3) Receive Reward
        r = reward(finalState);
        
        % 4) Update Q-Values
        finalState_idx = find(strcmp(states, finalState));
        action_idx = find(strcmp(actions, action));
        % Separate input update step
        if isInput
            % NOTE: This sample target is NOT the optimal value.
            % We are mixing on-policy and off-policy Q-leanrning here.
            sample = input_reward + gamma*qValue(finalState_idx, input_idx);
            qValue(state_idx, input_idx) = (1-alpha)*qValue(state_idx, input_idx) + alpha*sample;
        end
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
total = total_successes + total_failures + total_anomalies;
fprintf('\n---------------- Summary ----------------\n')
fprintf('Epsilon: %2.2f\n', epsilon)
fprintf('Learning Rate: %2.2f\n', alpha)
fprintf('Discount Factor: %2.2f\n', gamma)
fprintf('Character: %s\n', character)
fprintf('Max Iterations: %2.2f\n', maxIterations)
fprintf('Number of Plates: %2.2f\n', numEpisodes)
fprintf('---\n')
fprintf('Average iterations per episode: %2.2f\n', avgIterations)
fprintf('Highest number of iterations reached: %i\n', highestIteration)
fprintf('Total Successes: %i (%2.1f%%)\n', total_successes, (total_successes/total)*100)
fprintf('Total Failures: %i (%2.1f%%)\n', total_failures, (total_failures/total)*100)
fprintf('Total Anomalies: %i (%2.1f%%)\n', total_anomalies, (total_anomalies/total)*100)
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
    opt_action = actions(find(squeeze(qValue(st,:)) == max(squeeze(qValue(st,:)))));
    if length(opt_action) > 1
        opt_action = "none";
    end
    fprintf('%10s --> %10s\n', states(st), opt_action)
end

%% Summary
figure
% f = fit([1:length(inCount_array)]', inCount_array, 'power1');
% h = plot(f,[1:length(inCount_array)]', inCount_array, 'o-');
h = plot([1:length(inCount_array)]', inCount_array, 'o-');
set(h,'LineWidth', 2)
set(gca,'FontSize',20)
xlabel('Plate Number')
ylabel('Number of Inputs')

savefig('RAF_RL_Inputs')
saveas(gcf, 'RAF_RL_Inputs.png')

fh = figure();
fh.WindowState = 'maximized';
subplot(6,3,1)
plot(squeeze(qValue_array(1,1,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Eat/Input')
ylabel('Q-Value')

subplot(6,3,2)
plot(squeeze(qValue_array(1,2,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Eat/Stay')

subplot(6,3,3)
plot(squeeze(qValue_array(1,3,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Eat/Quit')

subplot(6,3,4)
plot(squeeze(qValue_array(2,1,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Anomaly/Input')
ylabel('Q-Value')

subplot(6,3,5)
plot(squeeze(qValue_array(2,2,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Anomaly/Stay')

subplot(6,3,6)
plot(squeeze(qValue_array(2,3,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Anomaly/Quit')

subplot(6,3,7)
plot(squeeze(qValue_array(3,1,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Success/Input')
ylabel('Q-Value')

subplot(6,3,8)
plot(squeeze(qValue_array(3,2,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Success/Stay')

subplot(6,3,9)
plot(squeeze(qValue_array(3,3,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Success/Quit')

subplot(6,3,10)
plot(squeeze(qValue_array(4,1,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Fail/Input')
ylabel('Q-Value')

subplot(6,3,11)
plot(squeeze(qValue_array(4,2,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Fail/Stay')

subplot(6,3,12)
plot(squeeze(qValue_array(4,3,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Fail/Quit')

subplot(6,3,13)
plot(squeeze(qValue_array(5,1,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Food/Input')
ylabel('Q-Value')

subplot(6,3,14)
plot(squeeze(qValue_array(5,2,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Food/Stay')


subplot(6,3,15)
plot(squeeze(qValue_array(5,3,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('Food/Quit')

subplot(6,3,16)
plot(squeeze(qValue_array(6,1,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('No Food/Input')
ylabel('Q-Value')

subplot(6,3,17)
plot(squeeze(qValue_array(6,2,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('No Food/Stay')

subplot(6,3,18)
plot(squeeze(qValue_array(6,3,:)), 'LineWidth', 2)
set(gca,'FontSize',16)
title('No Food/Quit')

savefig('RAF_RL_QValues')
saveas(gcf, 'RAF_RL_Q-Values.png')

figure
bar(inCount_state)
set(gca,'xticklabel',cellstr(states))
xlabel('State')
ylabel('Number of Inputs')

savefig('Inputs Per State')

figure
plot(squeeze(qValue_array(3,2,:)), 'LineWidth', 2)
set(gca,'FontSize',20)
title('Success/Stay')
ylabel('Q-Value')
xlabel('Episode (Plate)')

savefig('Succes-Stay Q-Value')
saveas(gcf,'Succes-Stay Q-Value.png')

diary off

%% Functions

function setup_diary(dfile)
    if exist(dfile, 'file') ; delete(dfile); end
    diary(dfile)
    diary on
end

function print_metrics(total_successes, total_failures, total_anomalies, state, iteration, successes, failures, anomalies, food_num, episode, inCount)
    fprintf('Episode Done. Final State: %s, Iterations: %i\n', state, iteration)
    fprintf('Successes: %i\n', successes)
    fprintf('Failures: %i\n', failures)
    fprintf('Anomalies: %i\n', anomalies)
    fprintf('Remaining food items: %i\n', food_num)
    fprintf('\nPlate %i finished. Number of required inputs: %i \n', episode, inCount);
    fprintf('--------\n')
    fprintf('Successes so far: %i\n', total_successes)
    fprintf('Failures so far: %i\n', total_failures)
    fprintf('Anomalies so far: %i\n', total_anomalies)
end