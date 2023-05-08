% MCE 793: Intelligent Controls
% Interactive Session: Reinforcement Learning
% Created by Jack Schultz
% April 28th, 2020

%% Part a) Program Episodes

clear; clc; close all

fprintf('----------- Part a) -----------\n')

qValue = zeros(4,3,4);
state = [1 1];
str1 = num2str(state(1));
str2 = num2str(state(2));
str = [str1 str2];
st = str2double(str);
gamma = 1;
alpha = 1;

maxIterations = 100;        % Max steps to take per episode
for iteration = 1:1:maxIterations
    figure(1)
    hold on
    gridworld(qValue, state)
    initialState = state;
    switch st
        case 11
            action = 'east';
            a = 2;
        case 21
            action = 'east';
            a = 2;
        case 31
            action = 'east';
            a = 2;
        case 41
            action = 'north';
            a = 3;
        case 12
            action = 'north';
            a = 3;
        case 32
            action = 'east';
            a = 2;
        case 13
            action = 'east';
            a = 2;
        case 23
            action = 'east';
            a = 2;
        case 33
            action = 'east';
            a = 2;
        case 42
            fprintf('Episode Done. Final State: [%i %i], Iterations: %i\n', state(1), state(2), iteration)
            break
        case 43
            fprintf('Episode Done. Final State: [%i %i], Iterations: %i\n', state(1), state(2), iteration)
            break
    end
    finalState = transition(initialState,action);
    r = reward(finalState);
    sample = r + gamma*max(qValue(finalState(1), finalState(2), :));
    qValue(state(1),state(2),a) = (1-alpha)*qValue(state(1),state(2),a) + alpha*sample;
    state = finalState;
    str1 = num2str(finalState(1));
    str2 = num2str(finalState(2));
    str = [str1 str2];
    st = str2double(str);
end

if iteration == maxIterations
    warning('Max Iterations Reached')
end

%%
disp('Hit Enter to continue to part b')
pause

%% Part b) Value Iteration

clear; close all

fprintf('----------- Part b) -----------\n')

qValue = zeros(4,3,4);
actionVect = {'south', 'east', 'north', 'west'};

gamma = 1;
alpha = 1;

state = [1 1];
str1 = num2str(state(1));
str2 = num2str(state(2));
str = [str1 str2];
st = str2double(str);

sumIterations = 0;
highestIteration = 0;

maxIterations = 200;        % Max steps to take per episode
numEpisodes = 1000;
for episode = 1:1:numEpisodes
    for iteration = 1:1:maxIterations
%         figure(1)
%         hold on
%         gridworld(qValue, state)
        initialState = state;
        switch st
            case 11
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 21
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 31
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 41
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 12
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 32
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 13
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 23
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 33
                a = round(4*rand(1,1) + .5);
                action = char(actionVect(a));
            case 42
                %fprintf('Episode %i Done. Final State: [%i %i], Iterations: %i\n', episode, state(1), state(2), iteration)
                break
            case 43
                %fprintf('Episode %i Done. Final State: [%i %i], Iterations: %i\n', episode, state(1), state(2), iteration)
                break
        end
        finalState = transition(initialState,action);
        r = reward(finalState);
        sample = r + gamma*max(qValue(finalState(1), finalState(2),:));
        qValue(state(1),state(2),a) = (1-alpha)*qValue(state(1),state(2),a) + alpha*sample;
        state = finalState;
        str1 = num2str(finalState(1));
        str2 = num2str(finalState(2));
        str = [str1 str2];
        st = str2double(str);
    end
    
    if iteration == maxIterations
        warning('Max Iterations Reached on episode %i\n', episode)
    end
    state = [1 1];
    str1 = num2str(state(1));
    str2 = num2str(state(2));
    str = [str1 str2];
    st = str2double(str);
    
    if mod(episode,100) == 0
        figure
        hold on
        gridworld(qValue, finalState)
        str = (['After ' num2str(episode) ' episodes']);
        title(str)   
    end
    
    sumIterations = sumIterations + iteration;
    if iteration > highestIteration
        highestIteration = iteration;
    end
end

avgIterations = sumIterations/numEpisodes;
fprintf('Average iterations per episode: %2.2f\n', avgIterations)
fprintf('Highest number of iterations reached: %i\n', highestIteration)

%%
disp('Hit Enter to continue to part c')
pause

%% Part c) Epsilon greedy Q-learning

clear; close all

fprintf('----------- Part c) -----------\n')

qValue = zeros(4,3,4);
actionVect = {'south', 'east', 'north', 'west'};
epsilon = .2;     % Epsilon greedy value %

gamma = 1;
alpha = .5;

state = [1 1];
str1 = num2str(state(1));
str2 = num2str(state(2));
str = [str1 str2];
st = str2double(str);

sumIterations = 0;
highestIteration = 0;

maxIterations = 250;        % Max steps to take per episode
numEpisodes = 5000;
for episode = 1:1:numEpisodes
    for iteration = 1:1:maxIterations
%         figure(1)
%         hold on
%         gridworld(qValue, state)
        initialState = state;
        e = rand(1);
        switch st
            case 11
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 21
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 31
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 41
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 12
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 22
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 32
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 13
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 23
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 33
                if e <= epsilon
                    a = round(4*rand(1,1) + .5);
                    action = char(actionVect(a));
                else
                    a = find(squeeze(qValue(state(1),state(2),:)) == max(squeeze(qValue(state(1),state(2),:))));
                    if length(a) > 1
                        pos = randi(length(a));
                        a = a(pos);
                    end
                    action = char(actionVect(a));
                end
            case 42
                %fprintf('Episode %i Done. Final State: [%i %i], Iterations: %i\n', episode, state(1), state(2), iteration)
                break
            case 43
                %fprintf('Episode %i Done. Final State: [%i %i], Iterations: %i\n', episode, state(1), state(2), iteration)
                break
        end
        finalState = transition(initialState,action);
        r = reward(finalState);
        sample = r + gamma*max(qValue(finalState(1), finalState(2),:));
        qValue(state(1),state(2),a) = (1-alpha)*qValue(state(1),state(2),a) + alpha*sample;
        state = finalState;
        str1 = num2str(finalState(1));
        str2 = num2str(finalState(2));
        str = [str1 str2];
        st = str2double(str);
    end
    
    if iteration == maxIterations
        warning('Max Iterations Reached on episode %i\n', episode)
    end
    state = [1 1];
    str1 = num2str(state(1));
    str2 = num2str(state(2));
    str = [str1 str2];
    st = str2double(str);
    
    if mod(episode,numEpisodes/5) == 0
        figure
        hold on
        gridworld(qValue, finalState)
        str = (['After ' num2str(episode) ' episodes']);
        title(str)   
    end
    
    sumIterations = sumIterations + iteration;
    if iteration > highestIteration
        highestIteration = iteration;
    end
end

avgIterations = sumIterations/numEpisodes;
fprintf('Average iterations per episode: %2.2f\n', avgIterations)
fprintf('Highest number of iterations reached: %i\n', highestIteration)
