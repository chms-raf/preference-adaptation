%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% query.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: This function queries the user for input.   
% ---------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jack Schultz
% Date created: 4/9/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function action = query(initialState, actions)
    fprintf('Current State: %s\n', initialState)
    user_action = string(input('Enter action (stay or quit): ', "s"));
    while (~isa(user_action,'string') || ~any(strcmp(actions, user_action)))
        disp('Invalid final state.')
        user_action = input('Enter action (stay or quit): ', "s");
    end
    
    action = user_action;
end