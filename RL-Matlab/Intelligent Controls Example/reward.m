%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reward.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function returns the reward for an input state in the 
% "grid world" problem created by the UC Berkeley AI program.   
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

function r = reward(state)

if state(1) == 4 && state(2) == 3
    r = 10;
elseif state(1) == 4 && state(2) == 2
    r = -10;
elseif state(1) == 2 && state(2) == 2
    r = -10;
else
    r = -2;
end
end

    