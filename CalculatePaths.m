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

