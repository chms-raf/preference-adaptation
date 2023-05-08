%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transition.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function returns the final state given an initial state
% and action in the "grid world" problem created by the UC Berkeley AI
% program.
% ---------------------------
% Licensing Information:  You are free to use or extend these projects for
% educational purposes provided that (1) you do not distribute or publish
% solutions, (2) you retain this notice, and (3) you provide clear
% attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
%
% Attribution Information: The Pacman AI projects were developed at UC Berkeley.
% The core projects and autograders were primarily created by John DeNero
% (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
% Student side autograding was added by Brad Miller, Nick Hay, and
% Pieter Abbeel (pabbeel@cs.berkeley.edu).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Eric Schearer
% Date created: 4/23/18
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function finalState = transition(initialState,action)

randomness = rand;

% go where the action clc tells you to go
switch action
    case 'east'
        if randomness < 0.85
            finalState = [initialState(1)+1 initialState(2)];
        elseif randomness < 0.9
            finalState = [initialState(1)-1 initialState(2)];
        elseif randomness < 0.95
            finalState = [initialState(1) initialState(2)+1];
        else
            finalState = [initialState(1) initialState(2)-1];
        end
    case 'west'
        if randomness < 0.85
            finalState = [initialState(1)-1 initialState(2)];
        elseif randomness < 0.9
            finalState = [initialState(1)+1 initialState(2)];
        elseif randomness < 0.95
            finalState = [initialState(1) initialState(2)+1];
        else
            finalState = [initialState(1) initialState(2)-1];
        end
    case 'north'
        if randomness < 0.85
            finalState = [initialState(1) initialState(2)+1];
        elseif randomness < 0.9
            finalState = [initialState(1)-1 initialState(2)];
        elseif randomness < 0.95
            finalState = [initialState(1)+1 initialState(2)];
        else
            finalState = [initialState(1) initialState(2)-1];
        end
    case 'south'
        if randomness < 0.85
            finalState = [initialState(1) initialState(2)-1];
        elseif randomness < 0.9
            finalState = [initialState(1)-1 initialState(2)];
        elseif randomness < 0.95
            finalState = [initialState(1)+1 initialState(2)];
        else
            finalState = [initialState(1) initialState(2)+1];
        end
end

% don't go out of bounds or into the black block
if finalState(1) > 4 || finalState(1) < 1 || finalState(2) > 3 || finalState(2) < 1
    finalState = initialState;
end
if finalState(1) == 2 && finalState(2) == 2 
    finalState = initialState;
end
    
