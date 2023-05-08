% Color test

clear; clc; close all

% red = [1, 0, 0];
% green = [0, 1, 0];
% colors = [linspace(red(1),green(1),200)', linspace(red(2),green(2),200)', linspace(red(3),green(3),200)'];
% 
% temp = randi([-100,100],1,1);
% B = temp + 100;
% blah = colors(B,:);
% 
% OB = [0 0; 12 0; 12 12; 0 12; 0 0];
% 
% c1 = [ 6.0, 5.0];
% c2 = [ 8.5, 1.5];
% c3 = [10.5, 2.0];
% 
% obstacle1 = [c1(1)-1 c1(2)-1; c1(1)+1 c1(2)-1; c1(1)+1 c1(2)+1; c1(1)-1 c1(2)+1; c1(1)-1 c1(2)-1]; 
% obstacle2 = [c2(1)-1 c2(2)-1; c2(1)+1 c2(2)-1; c2(1)+1 c2(2)+1; c2(1)-1 c2(2)+1; c2(1)-1 c2(2)-1]; 
% obstacle3 = [c3(1)-1 c3(2)-1; c3(1)+1 c3(2)-1; c3(1)+1 c3(2)+1; c3(1)-1 c3(2)+1; c3(1)-1 c3(2)-1]; 
% 
% figure
% plot(OB(:,1),OB(:,2))
% axis([-1 13 -1 13])
% 
% fill(obstacle1(:,1), obstacle1(:,2),blah)
% fill(obstacle2(:,1), obstacle2(:,2),blah)
% fill(obstacle3(:,1), obstacle3(:,2),blah)

qValue = zeros(4,3,4);
qValue(1,1,1) = 200;
qValue(1,3,2) = 30;
qValue(3,3,2) = -30;
state = [1 1];

figure(1)
hold on
gridworld(qValue, state)