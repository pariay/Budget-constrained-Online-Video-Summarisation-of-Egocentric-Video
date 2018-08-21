function data = extract_features(read_video, select_descriptor, vid,...
    datapath)

% This function extracts features from video or frames
% Inputs:
%   1 - read_video : true or false
%        true: it converts video into frames and saves them into a folder.
%        false: it reads frames
%   2 - select_descriptor: choose type of descriptor
%           {CNN, Fisher, SceneCNN, RGB, Gist}
%   3 - vid: video number
%   4 - datapath : original path to the saved egocentric videos/frames.

% Output:
%   data: extracted features

% Paria Yousefi 07/06/2018  -----------------------------------------------
% -------------------------------------------------------------------------

if ~isstring(vid)
    if vid < 10
        vid = [ '0' num2str(vid)];
    else
        vid = num2str(vid);
    end
end

frame_path = [datapath '\Frames\P_' vid '\'];

% 1. Read Video and save frames into a folder -----------------------------
if read_video
    if exist([datapath '\Frames\P_' vid '\'], 'file') ~= 7
        mkdir([datapath '\Frames\P_' vid '\'])
        v = VideoReader([datapath '\Video\P_' num2str(vid) '.MP4']);
        NF = v.Duration * v.FrameRate;
        count = 1;
        for k = 1:round(v.FrameRate):NF
            % use read because of its ability to read certain frames
            vidFrame = read(v,k);
            fr_name = fullfile(frame_path,[num2str(count),'.jpg']);
            imwrite(vidFrame,fr_name);
            count = count+1;
        end
    end
end

% 2. Extract features -----------------------------------------------------
if exist([datapath '\Features\P_' vid '\'],'file') ~=7
    mkdir([datapath '\Features\P_' vid '\'])
end
feature_path = ([datapath '\Features\']);

switch select_descriptor
    
    case 'RGB'
        data = extract_rgb_features(frame_path);
        
    case 'HSV'
        rsz = 1/8;
        bins = [32 4 2];
        data = extract_hsv_features(frame_path,bins,rsz);
        
    case 'HSV-[32 4 2]'
        rsz = 1/8;
        bins = [32 4 2];
        data = extract_hsv_features(frame_path,bins,rsz);
        
    case 'HSV-[16 4 4]'
        rsz = 1;
        bins = [16 4 4];
        data = extract_hsv_features(frame_path,bins,rsz);
        
    case 'ColorLayout'
        blocks = 64;
        data = extract_colorlayout_features(frame_path,blocks);
                
end

save([feature_path 'P_' vid '\P_' vid '_' select_descriptor '.mat'],'data')    

end
