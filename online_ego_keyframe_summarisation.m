function S = online_ego_keyframe_summarisation(data, method, params)

% Run specified method on data to extract keyframes
% Edited by Paria 21/08/2018
% =========================================================================
% Run summarisation

switch method
                       
      case 'Budget CC'
        if numel(params) ~= 4 && numel(params) ~= 5
            err(method)
        end
        
        if numel(params) == 3
            bsize = params(1); % buffer size
            minseg = params(2); % minimum segment length
            thresh = params(3); % threshold for keyframe similarity
            budget = params(4); % maximum number of keyframes
            S = keyframes_budget_controlchart(data,bsize, ...
                minseg,thresh, budget);
        else
            bsize = params{1}; % buffer size
            minseg = params{2}; % minimum segment length
            thresh = params{3}; % threshold for keyframe similarity
            budget = params{4}; % total number of keyframes
            framepath = params{5};
            S = keyframes_budget_controlchart(data,bsize, ...
                minseg,thresh, budget, framepath);
        end
                               
        % Uniform Evenet
    case 'Uniform Event'
        if isempty(params) 
            err(method)
        end
        numevents = params(1);
        S = keyframe_events_uniform(data,numevents);
    
    % Uniform time Interval
    case 'Uniform Time Interval'
        if isempty(params) 
            err(method)
        end
        ti = params(1);% time interval by seconds, every 70 seconds
        S = keyframe_timeinterval_uniform(data,ti);
        
    otherwise
        error(['No match found for method ' method]);
end
end

function err(method)
    error(['Incorrect number of parameters for ' method])
end
