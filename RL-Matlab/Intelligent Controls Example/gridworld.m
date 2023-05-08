%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gridworld.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function plots the "grid world" environment created by
% the UC Berkeley AI program.  It takes a 4x3x4 matrix of Q-values where
% first two dimensions represent the indices of the square that represents
% the state and the third dimension represents the action.  The order of
% actions is bottom, right, top, left.
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

function gridworld(qValue, state)

bottomX = [0 0.5 1]';
bottomY = [0 0.5 0]';
leftX = [0 0.5 0]';
leftY = [0 0.5 1]';
rightX = [1 0.5 1]';
rightY = [0 0.5 1]';
topX = [0 0.5 1]';
topY = [1 0.5 1]';

red = [.8, 0, 0];
green = [0, .8, 0];
white = [0, 0, 0];
L = 20;
colors1 = [linspace(red(1),white(1),L/2)', linspace(red(2),white(2),L/2)', linspace(red(3),white(3),L/2)'];
colors2 = [linspace(white(1),green(1),L/2)', linspace(white(2),green(2),L/2)', linspace(white(3),green(3),L/2)'];
colors = [colors1; colors2];
%qValue = zeros(4,3,4);

% figure(1)
% hold on
for i = 1:4
    for j = 1:3
        if qValue(i,j,1) < -(L/2)
            colorVal = 1;
        elseif qValue(i,j,1) > L/2
            colorVal = L;
        else
            colorVal = round(qValue(i,j,1)) + L/2;
        end
        
        if colorVal <= 0
            colorVal = 1;
        end
        fill(bottomX+i-1,bottomY+j-1,colors(colorVal,:),'EdgeColor','w')
        txt = num2str(qValue(i,j,1),'%1.2f');
        text(0.3+i-1,0.2+j-1,txt,'Color','white')
        
        if qValue(i,j,4) < -(L/2)
            colorVal = 1;
        elseif qValue(i,j,4) > L/2
            colorVal = L;
        else
            colorVal = round(qValue(i,j,4)) + L/2;
        end
        if colorVal <= 0
            colorVal = 1;
        end
        fill(leftX+i-1,leftY+j-1,colors(colorVal,:),'EdgeColor','w')
        txt = num2str(qValue(i,j,4),'%1.2f');
        text(0.05+i-1,0.5+j-1,txt,'Color','white')
        
        if qValue(i,j,2) < -(L/2)
            colorVal = 1;
        elseif qValue(i,j,2) > L/2
            colorVal = L;
        else
            colorVal = round(qValue(i,j,2)) + L/2;
        end
        if colorVal <= 0
            colorVal = 1;
        end
        fill(rightX+i-1,rightY+j-1,colors(colorVal,:),'EdgeColor','w')
        
        txt = num2str(qValue(i,j,2),'%1.2f');
        text(0.6+i-1,0.5+j-1,txt,'Color','white')
        
        if qValue(i,j,3) < -(L/2)
            colorVal = 1;
        elseif qValue(i,j,3) > L/2
            colorVal = L;
        else
            colorVal = round(qValue(i,j,3)) + L/2;
        end
        if colorVal <= 0
            colorVal = 1;
        end
        fill(topX+i-1,topY+j-1,colors(colorVal,:),'EdgeColor','w')
        
        txt = num2str(qValue(i,j,3),'%1.2f');
        text(0.3+i-1,0.8+j-1,txt,'Color','white')
        
        if i==2 && j == 2
            fill([1 2 2 1],[1 1 2 2],[128 128 128]/255,'EdgeColor','w')
        end
        if i==4 && j == 2
            fill([3 4 4 3],[1 1 2 2],'r','EdgeColor','w')
        end
        if i==4 && j == 3
            fill([3 4 4 3],[2 2 3 3],'g','EdgeColor','w')
        end
        
    end
end
plot(state(1)-0.5,state(2)-0.5,'o','MarkerFaceColor','m','MarkerSize',20)
axis image
