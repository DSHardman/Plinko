v = VideoReader('F1.wmv');
load('F.mat');

allpaths(size(times,1),1) = Pathtaken();
for i = 1:size(times,1)
    startframe = round((times(i,1)+10)*v.FrameRate);
    endframe = round((times(i,2)+10)*v.FrameRate);
    locations = zeros(endframe-startframe+1,2);
    for j = 1:size(locations,1)
        location = plinkoMask(read(v,startframe+j-1));
        if ~isnan(location)
            locations(j,:) = location;
        else
            locations(j,:) = [NaN NaN];
        end
    end
    allpaths(i) = Pathtaken(locations);
    fprintf('Completed %d/%d\n', i, size(times,1));
end


%imshow(read(v,75));

%im = read(v,75);
%location = plinkoMask(im);
%scatter(location(1),location(2));

