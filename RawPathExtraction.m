locations = extractframes(VideoReader('C:\Users\dshar\Downloads\(output001)seven.wmv'));
save("seven.mat", "locations");
fprintf("7 complete\n");

function locations = extractframes(v)
    
    startframe = 1;
    endframe = v.NumFrames;
    
    locations = zeros(endframe-startframe+1,2);
    for j = 1:size(locations,1)
        % evalc removes tie warning: careful!
        evalc("location = mechanisedMask(read(v,startframe+j-1));");
        if ~isnan(location)
            locations(j,:) = location;
        else
            locations(j,:) = [NaN NaN];
        end
        if mod(j, 1000) == 0
            fprintf('%d/%d frames\n', j, endframe)
        end
    
    end
end