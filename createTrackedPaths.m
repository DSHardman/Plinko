% turn paths into objects
% horrible horrible code for one time use

index = 1;

Apaths = [];

while index < length(locations)
    while index < length(locations)
        if locations(index, 2) < 120 && locations(index, 1) > 770
            startindex = index;
            break
        end
        index = index + 1;
    end

    while index < length(locations)
        if locations(index, 2) > 840
            endindex = index;
            break
        end
        index = index + 1;
    end
    
    path = Pathtaken(locations(startindex:endindex, :));
    Apaths = [Apaths; path];
end

Apaths = Pathlist(Apaths);