% Create Pathlist object from raw tracked data

% x & y coordinates for path to begin
upperlimit = 120;
upperleftlimit = 500;

% y coordinate for paths to end
lowerlimit = 710;

index = 1;

hookpaths = [];

while index < length(locations)
    while index < length(locations)
        if locations(index, 2) < upperlimit && locations(index, 1) > upperleftlimit
            startindex = index;
            break
        end
        index = index + 1;
    end

    while index < length(locations)
        if locations(index, 2) > lowerlimit
            endindex = index;
            break
        end
        index = index + 1;
    end
    
    path = Pathtaken(locations(startindex:endindex, :));
    hookpaths = [hookpaths; path];
end

hookpaths = Pathlist(hookpaths);