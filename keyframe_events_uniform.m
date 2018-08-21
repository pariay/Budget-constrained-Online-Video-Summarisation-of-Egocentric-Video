function S = keyframe_events_uniform(data,numevents)

di = size(data);
S = [];
eb = floor(linspace(1, di(1),numevents+1)); % event bouandaries

for i = 1: numevents
    points = data(eb(i):eb(i+1),:); % event points
    shot = eb(i) : eb(i+1);    
    kfnum = knnsearch(points, mean(points));
    kf = shot(kfnum);
    S = [S kf]; %#ok<AGROW>
end