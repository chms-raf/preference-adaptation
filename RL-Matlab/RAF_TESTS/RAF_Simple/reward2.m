%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reward.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function returns the reward.   
% ---------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 4/9/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r = reward2(state, action, future_state)

    if state == "eat"
        if action == "stay"
            if future_state == "anomaly"
                r = -1;
            elseif future_state == "success"
                r = 1;
            elseif future_state == "fail"
                r = -1;
            end
        elseif action == "quit"
            r = 1;
        end
    elseif state == "anomaly"
        if action == "stay"
            if future_state == "food"
                r = -1;
            elseif future_state == "nofood"
                r = -1;
            end
        elseif action == "quit"
            r = 1;
        end
    elseif state == "success"
        if action == "stay"
            if future_state == "food"
                r = 1;
            elseif future_state == "nofood"
                r = -1;
            end
        elseif action == "quit"
            r = 1;
        end
    elseif state == "fail"
        if action == "stay"
            if future_state == "food"
                r = 1;
            elseif future_state == "nofood"
                r = -1;
            end
        elseif action == "quit"
            r = 1;
        end
    elseif state == "food"
        if action == "stay"
            r = 1;
        elseif action == "quit"
            r = 1;
        end
    elseif state == "nofood"
        if action == "stay"
            r = -1;
        elseif action == "quit"
            r = 1;
        end
    end
end

    