%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transition.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function returns the final state given an initial state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 2/14/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function finalState = transition(initialState, action, actions)

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
                if randomness < 0.85
                    finalState = "success";
                elseif randomness < 0.9
                    finalState = "fail";
                elseif randomness < 0.95
                    finalState = "estop";
                else
                    finalState = "anomaly";
                end
            elseif (initialState == "anomaly" || initialState == "success" || initialState == "fail")
                if randomness < 0.83
                    finalState = "food";
                else
                    finalState = "nofood";
                end
            elseif (initialState == "food" || initialState == "nofood")
                finalState = "eat";
            end
        case "quit"
            finalState = "end";
    end
end
    
