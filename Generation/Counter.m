classdef Counter
    properties
        radius % of counter /mm
        holeloc % x/y coordinates of payload hole
        inclination % 9 grid points for generating inclination field
        theta % 9 grid points for generating theta field
        density % 9 grid points for generating density field
        subtractive % Details of circles to be removed from morphology
    end

    methods
        function obj = Counter(radius, holeloc, inclination, theta,...
                density, subtractive)
            % CONSTRUCTOR
            if nargin > 0
                obj.radius = radius;
                obj.holeloc = holeloc;
                obj.inclination = inclination;
                obj.theta = theta;
                obj.density = density;
                obj.subtractive = subtractive;
            end
        end

        function generate(obj, filename)
        % Acess IceSL API to create gcode file for printable counter

            % Write matrices to text files which are accessed by IceSL
            circles = [0 0 obj.radius; obj.holeloc 5; obj.subtractive];
            writematrix(circles, 'CounterData/circles.txt');
            [Xq,Yq] = meshgrid((0:63),(0:63));
            [X, Y] = meshgrid((0:31.5:63),(0:31.5:63));
            writematrix(interp2(X,Y,obj.inclination,Xq,Yq),...
                'CounterData/inclination.txt');
            writematrix(interp2(X,Y,obj.theta,Xq,Yq),...
                'CounterData/theta.txt');
            writematrix(interp2(X,Y,obj.density,Xq,Yq),...
                'CounterData/density.txt');
            f = fopen('CounterData/CounterName.txt','w');
            fprintf(f, filename);
            fclose(f);
            
            % Generate gcode from command line
            fprintf('Slicing Counter...\n');
            evalc("system('IceSL-slicer.exe --io -s" + ...
                " MorphologyGeneration.lua');");
            fprintf('Counter Sliced.\n');

            % View counter
            %system(filename + ".gcode");
        end

        function plot(obj)
        % Shows 2D shape morphology
            % Plot main counter
            pos = [-obj.radius -obj.radius 2*obj.radius 2*obj.radius]; 
            rectangle('Position',pos,'Curvature',[1 1],...
                'FaceColor', 'red', 'EdgeColor', 'none');
            hold on; axis equal;

            % Plot subtractive holes
            for i = 1:size(obj.subtractive, 1)
                pos = [obj.subtractive(i,1)-obj.subtractive(i,3),...
                    obj.subtractive(i,2)-obj.subtractive(i,3),...
                    2*obj.subtractive(i,3), 2*obj.subtractive(i,3)];
                rectangle('Position',pos,'Curvature',[1 1],...
                    'FaceColor', 'white', 'EdgeColor', 'none');
            end
            
            % Maintain payload hole
            pos = [obj.holeloc(1)-7, obj.holeloc(2)-7, 14, 14];
            rectangle('Position',pos,'Curvature',[1 1],...
                'FaceColor', 'red', 'EdgeColor', 'none');
            pos = [obj.holeloc(1)-5, obj.holeloc(2)-5, 10, 10];
            rectangle('Position',pos,'Curvature',[1 1],...
                'FaceColor', 'white', 'EdgeColor', 'none');
            ylim([-15 15]); xlim([-15 15]);
            set(gca,'XColor', 'none','YColor','none')

        end

        function plotinclination(obj)
        % Shows inclination field as filled contour map
            [Xq,Yq] = meshgrid((0:63),(0:63));
            [X, Y] = meshgrid((0:31.5:63),(0:31.5:63));
            contourf(Xq, Yq, interp2(X,Y,obj.inclination,Xq,Yq));
            axis square
            set(gca,'XColor', 'none','YColor','none')
            colorbar()
            caxis([0 1])
        end

        function plottheta(obj)
        % Shows theta field as filled contour map
            [Xq,Yq] = meshgrid((0:63),(0:63));
            [X, Y] = meshgrid((0:31.5:63),(0:31.5:63));
            contourf(Xq, Yq, interp2(X,Y,obj.theta,Xq,Yq));
            axis square
            set(gca,'XColor', 'none','YColor','none')
            colorbar()
            caxis([0 1])
        end

        function plotdensity(obj)
        % Shows density field as filled contour map
            [Xq,Yq] = meshgrid((0:63),(0:63));
            [X, Y] = meshgrid((0:31.5:63),(0:31.5:63));
            contourf(Xq, Yq, interp2(X,Y,obj.density,Xq,Yq));
            axis square
            set(gca,'XColor', 'none','YColor','none')
            colorbar()
            caxis([0 1])
        end

        function plotall(obj)
        % Show morphology, inclination, theta, and density in 1x4 subplot
            figure();
            subplot(1,4,1); obj.plot();
            subplot(1,4,2); obj.plotinclination(); title('Inclination');
            subplot(1,4,3); obj.plottheta(); title('Theta');
            subplot(1,4,4); obj.plotdensity(); title('Density');
            set(gcf, 'Position', 1000*[0.0066 0.5042 1.5000 0.3538])
        end

        function generatesolid(obj, filename)
            % Visualise a single simulation with default parameters
            circles = [0 0 obj.radius; obj.holeloc 5; obj.subtractive];
            writematrix(circles, 'CounterData/circles.txt');
            f = fopen('CounterData/CounterName.txt','w');
            fprintf(f, filename);
            fclose(f);
            % Generate .obj file of solid shape using IceSL API
            evalc("system('IceSL-slicer.exe --io -s" +...
                " ../Simulations/STLMorphology.lua');");
        end

        function simulate(obj)
            % Visualise a single simulation with default parameters
            circles = [0 0 obj.radius; obj.holeloc 5; obj.subtractive];
            writematrix(circles, 'CounterData/circles.txt');
            f = fopen('CounterData/CounterName.txt','w');
            fprintf(f, 'simulated');
            fclose(f);
            % Generate .obj file of solid shape using IceSL API
            evalc("system('IceSL-slicer.exe --io -s" +...
                " ../Simulations/MeshMorphology.lua');");
            % Simulate and visualise path using pychrono
            evalc("system('py ../Simulations/DropSingle.py " +  "simulated " +...
                "1" + "');");
        end

        function factor = testrepeatability(obj, histbool)
            % Visualise a single simulation with default parameters
            circles = [0 0 obj.radius; obj.holeloc 5; obj.subtractive];
            writematrix(circles, 'CounterData/circles.txt');
            f = fopen('CounterData/CounterName.txt','w');
            fprintf(f, 'simulated');
            fclose(f);
            % Generate .obj file of solid shape using IceSL API
            evalc("system('IceSL-slicer.exe --io -s" +...
                " ../Simulations/MeshMorphology.lua');");
            % Test repeatability using pychrono
            evalc("system('py ../Simulations/TestRepeatability.py simulated');");
            % Read data from file
            repeats = readNPY("../Simulations/Meshes/simulated.npy");

            X = repeats(:, end);
            X(isnan(X)) = []; % Remove NaN elements
%             if length(X) > 70
%                 deviation = std(X); % return std of output positions
%             else
%                 deviation = 300; % set high if there are too many NaN elements
%             end

            % Output proportion of runs which land in the highest scoring
            % bin
            edges = [-160 -122.5 -87.5 -52.5 -17.5 17.5 52.5 87.5 122.5 160];
            Y = discretize(X, edges);
            %factor = length(find(Y==mode(Y)))/length(Y);
            %factor = 9*length(X) - sum(Y); %minimisation: bias to right
            factor = 0;
            for i = 1:length(Y)
                if isnan(Y(i))
                    factor = factor + 9;
                else
                    %factor = factor + 9 - Y(i); % first bias
                    factor = factor + Y(i) - 1; % second bias
                end
            end

            if nargin == 2 && histbool == 1 % plot histogram if requested
                histogram(X,edges)
            end
        end
    end
end