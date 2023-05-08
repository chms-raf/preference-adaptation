%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transition_2.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function returns the final state given an initial state

% This version incorporates the tracking of food items on a plate, rather
% than just based on probability.
% 
% This version also does not allow the "stay" action at state "no food"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 2/23/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function finalState = transition_2(initialState, action, actions, food_num)

    randomness = rand;
    
    if action == "input"
        fprintf('Current State: %s\n', initialState)
            user_action = input('Enter action surrounded by double quotes (stay or quit): ');
            while (~isa(user_action,'string') || ~any(strcmp(actions, user_action)))
                disp('Invalid final state.')
                user_action = input('Enter action surrounded by double quotes (stay or quit): ');
            end
        action = user_action;
    end

    switch action      
        case "stay"
            if initialState == "eat"
                if randomness < 0.89
                    finalState = "success";
                elseif randomness < 0.94
                    finalState = "fail";
                elseif randomness < 0.99
                    finalState = "anomaly";
                else
                    finalState = "estop";
                end
            elseif (initialState == "anomaly" || initialState == "success" || initialState == "fail")
                if food_num > 0
                    finalState = "food";
                else
                    finalState = "nofood";
                end
            elseif initialState == "food"
                finalState = "eat";
                
            elseif initialState == "nofood"
                finalState = "end";
            end
        case "quit"
            finalState = "end";
    end
end
    
