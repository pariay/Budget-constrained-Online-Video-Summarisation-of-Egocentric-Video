function data = extract_colorlayout_features(frame_path,blocks)

files = dir(frame_path);
fn = (natsortfiles({files.name}))';

data = [];
for i = 3:numel(fn)
    img = imread(fullfile(frame_path, fn{i}));
    x  = extract_ColorLayout(img, blocks);
    data = [data; x]; %#ok<AGROW>
end
