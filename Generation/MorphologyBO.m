BO(0);
BO(1);
BO(2);
BO(3);
BO(4);

function BO(level)

    %initialise variables for optimization
    v1 = optimizableVariable('counter_radius',[10 15],'Type', 'real');
    v2 = optimizableVariable('hole_rf',[0 1],'Type', 'real');
    v3 = optimizableVariable('hole_theta',[0 2*pi],'Type', 'real');
    v4 = optimizableVariable('rhof_1',[0 2],'Type', 'real');
    v5 = optimizableVariable('theta_1',[0 2*pi],'Type', 'real');
    v6 = optimizableVariable('rf_1',[0 1],'Type', 'real');
    v7 = optimizableVariable('rhof_2',[0 2],'Type', 'real');
    v8 = optimizableVariable('theta_2',[0 2*pi],'Type', 'real');
    v9 = optimizableVariable('rf_2',[0 1],'Type', 'real');
    v10 = optimizableVariable('rhof_3',[0 2],'Type', 'real');
    v11 = optimizableVariable('theta_3',[0 2*pi],'Type', 'real');
    v12 = optimizableVariable('rf_3',[0 1],'Type', 'real');
    
    % counter_radius: 10 to 15 (mm), radius of counter
    % hole_rf: 0 to 1. radial coordinate of hole position, as a proportion
        % of (counterradius-7)
    % hole_theta: 0 to 2*pi. theta coordinate of hole position.
    % 3 circles are removed, from shape, with parameters:
    % rhof_i: 0 to 2. r coordinate of circle position, as a proportion of
        % counterradius
    % theta_i: 0 to 2*pi. theta coordinate of circle position.
    % rf_i: 0 to 1.
    
    savename = 'Morphology/BOTest' + string(level) + '.mat';
    
    bayesianhandle = @(x)TestMorphology(x, level);
    
    results = bayesopt(bayesianhandle,...
        [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12],...
        'Verbose',1,...
        'MaxObjectiveEvaluations',300,...
        'MaxTime',10*36000,...
	    'OutputFcn',@saveToFile,...
        'SaveFileName',savename);
    
    % BayesianOptimization object is returned
    % default acquisition function is 'expected-improvement-per-second-plus'

end
