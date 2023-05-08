%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transition.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function returns the final state given an initial state
% and action.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 4/9/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function finalState = transition(initialState, action, food_num)

    randomness = rand;
    
    if action == "quit"
        finalState = "end";
    elseif action == "stay"
        switch initialState
            case "eat"
                if randomness < 0.9
                    finalState = "success";
                elseif randomness < 0.95
                    finalState = "fail";
                else
                    finalState = "anomaly";
                end
            case "anomaly"
                if food_num > 0
                    finalState = "food";
                else
                    finalState = "nofood";
                end
            case "success"
                if food_num > 0
                    finalState = "food";
                else
                    finalState = "nofood";
                end
            case "fail"
                if food_num > 0
                    finalState = "food";
                else
                    finalState = "nofood";
                end
            case "food"
                finalState = "eat";
            case "nofood"
                finalState = "end";
        end
    else
        error("Invalid Action.")
    end
end
    
