function data = extract_hsv_features(frame_path,bins,rsz)
% change the size of image in order to speed up the extraction time
% number of bines [H S V], e.i.,[32 4 2]


files = dir(frame_path);
fn = (natsortfiles({files.name}))';

data = [];
for i = 3:numel(fn)
    img = imread(fullfile(frame_path, fn{i}));    
    img = im2double(img);
    rsz_img = imresize(img,rsz);
    hsv_img = rgb2hsv(rsz_img);
    x = extract_feature_hsv_bins(hsv_img,1,[bins(1) bins(2) bins(3)]);
    data = [data; x]; %#ok<AGROW>
end