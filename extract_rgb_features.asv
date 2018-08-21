function data = extract_rgb_features(frame_path)

% add function path (vid library)
addpath(['C:\Users\eep801\Documents\MATLAB\Programes\CNN\'...
    'Original_MatConvNet\matconvnet-1.0-beta24\EgoCentric_Codes\'...
    'features\'])

files = dir(frame_path);
fn = (natsortfiles({files.name}))';

data = [];
for i = 3:numel(fn)
    im = imread(fullfile(frame_path, fn{i}));
    x = vid_get_features(im,'RGB',9);
    data = [data; x]; %#ok<AGROW>
end