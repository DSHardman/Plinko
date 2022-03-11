%% Randomly generate population

n = 6;

clear testpopulation
testpopulation(n, 1) = Counter();

for i = 1:n
    counterradius = 10 + 5*rand(); % between 10 & 15
    [holex, holey] = pol2cart(2*pi*rand(), (counterradius-7)*rand());
    subtractive = zeros(3,3);
    for j = 1:size(subtractive, 1)
        subr = 2*counterradius*rand();
        [subx, suby] = pol2cart(2*pi*rand(), subr);
        if subr <= counterradius
            subtractive(j,:) = [subx suby subr*rand()];
        else
            subtractive(j,:) = [subx suby subr + counterradius*(rand() - 1)];
        end
    end
    
    % Randomise material fields
    inclination = rand(3);
    theta= rand(3);
    density = 0.1 + 0.6*rand(3);
    
    testcounter = Counter(counterradius, [holex holey], inclination, theta,...
                    density, subtractive);
    testpopulation(i, 1) = testcounter;
end
testpopulation = Population(testpopulation);
%testpopulation.generate('output');