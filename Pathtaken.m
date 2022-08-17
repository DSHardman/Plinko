classdef Pathtaken < handle
   
    properties
        path
    end
    
    methods
        function obj = Pathtaken(locations)
        % Constructor
            if nargin == 0
                obj.path = NaN;
            else
                obj.path = locations;
            end
        end
        
        function plotpath(obj, col)
        % Single plot of given colour
            if nargin==1
                col = 'k';
            end
                
            plot(-obj.path(:,1), obj.path(:,2), 'Color', col);
        end
        
       function scatterpath(obj, direction)
       % Debugging: plot points one-by-one from beginning or end
            x = obj.path(1:end,1);
            y = -obj.path(1:end,2);
            if direction == 0
                for i = 1:length(x)
                    scatter(x(i),y(i)+150);
                    xlim([0 210])
                    ylim([0 150])
                    title(string(i));
                    pause()
                    hold on
                end
            else
                for i = 1:length(x)
                    scatter(x(end-i+1),y(end-i+1)+150);
                    xlim([0 210])
                    ylim([0 150])
                    title(string(i));
                    pause()
                    hold on
                end
            end
        end
        
        function shiftcoordinates(obj, corners)
            % Given marked positions on board, scale 0 -> 1
            % Bottom left; Top right
            for i = 1:size(obj.path, 1)
                % relative to top left corner
                obj.path(i,:) = obj.path(i,:) - corners(1,:);
                obj.path(i, 1) = obj.path(i, 1)/(corners(2,1)-corners(1,1));
                obj.path(i, 2) = obj.path(i, 2)/(corners(2,2)-corners(1,2));
            end
            
        end
        
        function makechanges(obj, changes)
        % Remove desired tracked points from beginning or end
            obj.path = obj.path(changes(1)+1:end-changes(2), :);
        end
        
    end
end

