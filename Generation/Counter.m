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
            obj.radius = radius;
            obj.holeloc = holeloc;
            obj.inclination = inclination;
            obj.theta = theta;
            obj.density = density;
            obj.subtractive = subtractive;
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
    end
end