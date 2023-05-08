%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% query.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function asks the user which action to perform and
% returns the result.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 2/14/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function action = simQuery(initialState)

    switch initialState
        case "eat"
            action = "stay";
        case "anomaly"
            action = "quit";
        case "success"
            action = "stay";
        case "fail"
            action = "quit";
        case "estop"
            action = "quit";
        case "food"
            action = "stay";
        case "nofood"
            action = "quit";
    end
end
    
