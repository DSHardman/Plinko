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

v = VideoReader('RotationTests/Videos/Repeats/Ystar.mp4');
imshow(read(v,50));
centre = ginput(1);
radius = ginput(1);
radius = norm(radius - centre);
close();

locations = zeros(v.NumFrames, 2);
for n = 1:v.NumFrames
    
    im = imcrop(read(v,n), [centre(1)-radius centre(2)-radius radius*2 radius*2]);
    for i = 1:size(im,1)
        for j = 1:size(im,2)
            if norm([i j] - [radius radius]) > radius
                im(i,j,1) = 0;
                im(i,j,2) = 0;
                im(i,j,3) = 0;
            end
        end
    end
    
    location = plinkoMask(im);
    if isnan(location)
        locations(n,:) = [nan nan];
    else
        locations(n,:) = [location(1)-radius location(2)-radius];
    end
end
Ystarrotate = RotatingPath(locations);
