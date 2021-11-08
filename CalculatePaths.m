%% original MDF & PMMA vertical tests

v = VideoReader('PMMATests/Videos/PMMA_L2_YB.wmv');

figure();
offsets = 10.6;

for o = 1:length(offsets)
    offset = offsets(o);
    allpaths(size(times,1),1) = Pathtaken();
    for i = 1:size(times,1)
        startframe = round((times(i,1)+offset)*v.FrameRate);
        endframe = round((times(i,2)+offset)*v.FrameRate);
        locations = zeros(endframe-startframe+1,2);
        for j = 1:size(locations,1)
            location = createRedMask(read(v,startframe+j-1));
            if ~isnan(location)
                locations(j,:) = location;
            else
                locations(j,:) = [NaN NaN];
            end
        end
        allpaths(i) = Pathtaken(locations);
        %fprintf('Completed %d/%d\n', i, size(times,1));
    end
    fprintf('Completed %f\n', offset);

    subplot(3,3,o)
    for i = 1:size(times, 1)
        allpaths(i).plotpath()
        hold on
    end
end

%% calculate paths from rotating system

v = VideoReader('RotationTests/MaskedVideos/of50mask.mp4');
imshow(read(v,50));
centre = ginput(1);
close();

locations = zeros(v.NumFrames-30, 2);
for i = 1:v.NumFrames-30
    location = SmallRedMask(read(v,i));
    if isnan(location)
        locations(i,:) = [nan nan];
    else
        locations(i,:) = [location(1)-centre(1) location(2)-centre(2)];
    end
end

of50rotate = RotatingPath(locations);
fprintf('complete\n');

v = VideoReader('RotationTests/MaskedVideos/z30mask.mp4');
imshow(read(v,50));
centre = ginput(1);
close();

locations = zeros(v.NumFrames-30, 2);
for i = 1:v.NumFrames-30
    location = SmallRedMask(read(v,i));
    if isnan(location)
        locations(i,:) = [nan nan];
    else
        locations(i,:) = [location(1)-centre(1) location(2)-centre(2)];
    end
end

z30rotate = RotatingPath(locations);
fprintf('complete\n');

v = VideoReader('RotationTests/MaskedVideos/zf30mask.mp4');
imshow(read(v,50));
centre = ginput(1);
close();

locations = zeros(v.NumFrames-30, 2);
for i = 1:v.NumFrames-30
    location = SmallRedMask(read(v,i));
    if isnan(location)
        locations(i,:) = [nan nan];
    else
        locations(i,:) = [location(1)-centre(1) location(2)-centre(2)];
    end
end

zf30rotate = RotatingPath(locations);
fprintf('complete\n');

v = VideoReader('RotationTests/MaskedVideos/zf50mask.mp4');
imshow(read(v,50));
centre = ginput(1);
close();

locations = zeros(v.NumFrames-30, 2);
for i = 1:v.NumFrames-30
    location = SmallRedMask(read(v,i));
    if isnan(location)
        locations(i,:) = [nan nan];
    else
        locations(i,:) = [location(1)-centre(1) location(2)-centre(2)];
    end
end

zf50rotate = RotatingPath(locations);
fprintf('complete\n');

