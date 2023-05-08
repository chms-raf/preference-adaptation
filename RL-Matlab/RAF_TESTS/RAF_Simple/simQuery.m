%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simQuery.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function simulates user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 4/9/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function action = simQuery(initialState, actor)

    if actor == "hungry"
        switch initialState
            case "eat"
                action = "stay";
            case "anomaly"
                action = "stay";
            case "success"
                action = "stay";
            case "fail"
                action = "stay";
            case "food"
                action = "stay";
            case "nofood"
                action = "quit";
        end
    elseif actor == "full"
        switch initialState
            case "eat"
                action = "stay";
            case "anomaly"
                action = "quit";
            case "success"
                action = "quit";
            case "fail"
                action = "quit";
            case "food"
                action = "quit";
            case "nofood"
                action = "quit";
        end
    elseif actor == "indecisive"
        randomness = rand;
        switch initialState
            case "eat"
                action = "stay";
            case "anomaly"
                if randomness < 0.5
                    action = "stay";
                else
                    action = "quit";
                end
            case "success"
                action = "stay";
            case "fail"
                if randomness < 0.5
                    action = "stay";
                else
                    action = "quit";
                end
            case "food"
                if randomness < 0.5
                    action = "stay";
                else
                    action = "quit";
                end
            case "nofood"
                action = "quit";
        end
    else
        error("Invalid actor")
    end
end
    
