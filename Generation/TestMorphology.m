function proportion = TestMorphology(x)

    % Parameters:
    % counter_radius: 10 to 15 (mm), radius of counter
    % hole_rf: 0 to 1. radial coordinate of hole position, as a proportion
        % of (counterradius-7)
    % hole_theta: 0 to 2*pi. theta coordinate of hole position.
    % 3 circles are removed, from shape, with parameters:
    % rhof_i: 0 to 2. r coordinate of circle position, as a proportion of
        % counterradius
    % theta_i: 0 to 2*pi. theta coordinate of circle position.
    % rf_i: 0 to 1.

    [holex, holey] = pol2cart(x.hole_theta, x.hole_rf*(x.counter_radius-7));

    [subx1, suby1] = pol2cart(x.theta_1, x.rhof_1*x.counter_radius);
    [subx2, suby2] = pol2cart(x.theta_2, x.rhof_2*x.counter_radius);
    [subx3, suby3] = pol2cart(x.theta_3, x.rhof_3*x.counter_radius);

    subtractive = [subx1 suby1 x.rf_1*x.rhof_1*x.counter_radius;...
        subx2 suby2 x.rf_2*x.rhof_2*x.counter_radius;...
        subx3 suby3 x.rf_3*x.rhof_3*x.counter_radius];

    counter = Counter(x.counter_radius, [holex holey], ones(3), ones(3),...
                ones(3), subtractive);

    % BO minimisation, so return proportion not in modal bin
    proportion = 1 - counter.testrepeatability();
end
