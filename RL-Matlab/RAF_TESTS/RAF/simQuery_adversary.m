%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% query.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function asks the user which action to perform and
% returns the result.

% This version simulates someone who changes their mind and has more
% randomness in their decisions.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 2/14/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function action = simQuery_adversary(initialState, num_food)

    randomness = rand;
    
    switch initialState
        case "eat"
            action = "stay";
        case "anomaly"
            if randomness < 0.5
                action = "quit";
            else
                action = "stay";
            end
        case "success"
            action = "stay";
        case "fail"
            action = "quit";
        case "estop"
            action = "quit";
        case "food"
            if num_food == 6
                action = "stay";
            else
                action = "quit";
            end
%             if randomness < 0.5
%                 action = "quit";
%             else
%                 action = "stay";
%             end
        case "nofood"
            action = "quit";
    end
end
    
