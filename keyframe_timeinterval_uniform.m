function S = keyframe_timeinterval_uniform(data,interval)

frames = size(data,1);
S = [];
st = 1;
while frames > 0
    if frames - interval > 0
        points = data(st:interval+st-1,:); 
        shot = st:interval+st-1;
    else
        points = data(st:end,:); 
        shot = st:size(data,1);
    end
    kfnum = knnsearch(points, mean(points));
    kf = shot(kfnum);
    S = [S kf]; %#ok<AGROW>
    
    st = interval+st;
    frames = frames - interval;
end