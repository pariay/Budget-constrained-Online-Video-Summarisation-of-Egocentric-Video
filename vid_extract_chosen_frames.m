function f = vid_extract_chosen_frames(odir,index,scale_factor)
%VID_EXTRACT_CHOSEN_FRAMES returns the frames with numbers given in set
% 'index', retrieved from folder 'odir'. An optional 'scale_factor' allows
% for resizing the images.
%
%========================================================================
% (c) Fox's Vis Toolbox                                             ^--^
% 03.03.2017 -----------------------------------------------------  \oo/
% -------------------------------------------------------------------\/-%

if ~exist(odir,'dir') % check for folder
    error('There is no folder  - %s -',odir)
end

for i = 1:numel(index)
    if nargin == 3
        f{i} = imresize(imread([odir,'/',num2str(index(i)),'.jpg']),...
            scale_factor);
    else
        f{i} = imread([odir,'/',num2str(index(i)),'.jpg']);
    end
end

