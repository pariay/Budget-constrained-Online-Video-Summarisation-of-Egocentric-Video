
% ** Budget-constrained Online Video Summarisation of Egocentric Video **
 
% If you use this code, please cite this paper:
% Title: Budget-constrained Online Video Summarisation of Egocentric Video
% Authors: Paria Yousefi, Clare E. Matthews, and Ludmila I. Kuncheva
% Conference: International Symposium on Visual Computing (ISVC 2018), USA

% This is the code we used for the experiments in this paper to tune the 
% parameters of the proposed method on the ADL dataset. The chosen feature
% space was RGB moments. 
% ------------------------------------------------------------------------

% read_video: set to 'true' if the videos are in MP4 format and to 'false'
%     if the frames are already stored separately.
%
% adlpath: the video directory. 
% 
% features: determines the feature space to be extracted
%


% Paria Yousefi 21/08/2018
% -------------------------------------------------------------------------
clear
clc
close all
warning off

vid = 20; % video number
features = 'RGB'; % RGB - HSV  - Color Layout
read_video = false; % true if you don't have frames
                   % false if you have frames

% Set this based on your video directory
adlpath = ([pwd 'DataBases\ActivityOfDailyLiving\']);

if ~isstring(vid)
    if vid < 10
        vid = [ '0' num2str(vid)];
    else
        vid = num2str(vid);
    end
end

svresults = ([pwd '\results\']);

% Features
featpath = [adlpath 'Features\P_' vid '\'];
nofolder = exist(featpath,'file') ~= 7;
nofile = exist([featpath 'P_' vid '_' features '.mat'],'file') ~= 2;

if nofolder || nofile
    data = extract_features(read_video, features, vid, adlpath);
else
    load(fullfile(featpath,['P_' vid '_' features '.mat']))
end

% Frames directory
framepath = [adlpath 'Frames\P_' vid '\'];

% -------------------------------------------------------------------------
% Methods

methods = containers.Map;

% -------------------------------------------------------------------------
buffer =  60; % 20:20:60;
ms =  13; % 7:15; % minimum segment size
threshold = 0.7; % 0.4:0.1:0.8; % threshold for kf similarity
budget = 28; %21

% -------------------------------------------------------------------------
% Budget CC method - ignoring similar keyframes
% We decided to go for this method which is easier to explain-BCC

params = {buffer, ms, threshold, budget, framepath};
methods('Budget CC') = params;

% -------------------------------------------------------------------------
% Uniform Event

numevents = 5; % number of events
methods('Uniform Event') = combvec(numevents)';

% -------------------------------------------------------------------------
% Run summarisation and evaluation for each method and each parameter set

valstar = containers.Map;
paramstar = containers.Map;

names = methods.keys;

results = cell(4, numel(names));
for mi = 1:numel(names)
    method = names{mi};
    disp(method)
    params = methods(method);
    nparams = size(params, 1);
    
    S = online_ego_keyframe_summarisation(data, method, params(:));
    
    results{1,mi} = method;
    results{2,mi}= params;
    
    if isempty(S)
        results{3,mi} = 0;
    else
        % Display the results
        frame_summary = vid_extract_chosen_frames(framepath,S',0.7);
        vid_montage(frame_summary,[3,ceil(size(S,2)/3)],...
            [1 1 1]*0.8,0.1)
        title(method)
               
        % Save keyframes
        mkdir([svresults '\results\P_' vid '\' method '\'])
        for fw = 1: size(S,2)
            imwrite(frame_summary{fw},[svresults 'results\P_' vid ...
                '\' method '\' num2str(S(fw)) '.jpg'])
        end
        results{3,mi} = S ;
        results{4,mi} = frame_summary;
        
    end
    
end




