%% Randomly generate counter

counterradius = 10 + 5*rand(); % between 10 & 15
[holex, holey] = pol2cart(2*pi*rand(), (counterradius-7)*rand());
subtractive = zeros(3,3);
for i = 1:size(subtractive, 1)
    subr = 2*counterradius*rand();
    [subx, suby] = pol2cart(2*pi*rand(), subr);
    if subr <= counterradius
        subtractive(i,:) = [subx suby subr*rand()];
    else
        subtractive(i,:) = [subx suby subr + counterradius*(rand() - 1)];
    end
end

% Randomise material fields
inclination = rand(3);
theta= rand(3);
density = rand(3);

testcounter = Counter(counterradius, [holex holey], inclination, theta,...
                density, subtractive);