%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reward.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function returns the reward.   
% ---------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 4/9/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r = reward(state)

    if state == "success"
        r = 5;
    elseif state == "fail"
        r = -2;
    elseif state == "anomaly"
        r = -1;
     elseif state == "eat"
        r = -1;
    elseif state == "food"
        r = -1;
    elseif state == "nofood"
        r = -1;
    elseif state == "end"
        r = -1;
    else
        r = -1;
    end
end

    