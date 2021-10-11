classdef Pathtaken < handle
   
    properties
        path
    end
    
    methods
        function obj = Pathtaken(locations)
            if nargin == 0
                obj.path = NaN;
            else
                obj.path = locations;
            end
        end
        
        function plotpath(obj, col)
            if nargin==1
                col = 'k';
            end
                
            %x = -obj.path(1:end,2);
            x = obj.path(1:end,1);
            %y = obj.path(1:end,1);
            y = -obj.path(1:end,2);
            plot(x,y+150, 'Color', col);
            %set(gca,'Color','k', 'XTick', [], 'YTick', []);
            %xlim([0 210])
            %ylim([0 150])
        end
        
       function scatterpath(obj, direction)
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
            %set(gca,'Color','k', 'XTick', [], 'YTick', []);
        end
        
        function shiftcoordinates(obj, corners)
            l1 = norm(corners(3,:).' - corners(4,:).');
            l2 = norm(corners(2,:).' - corners(1,:).');

            h1 = norm(corners(1,:).' - corners(4,:).');
            h2 = norm(corners(2,:).' - corners(3,:).');
            
            for i = 1:size(obj.path, 1)
                % relative to top left corner
                obj.path(i,:) = obj.path(i,:) - corners(1,:);
                obj.path(i, 1) = obj.path(i, 1)*(420/(l1+l2));
                obj.path(i, 2) = obj.path(i, 2)*(300/(h1+h2));
            end
            
        end
        
        function makechanges(obj, changes)
            obj.path = obj.path(changes(1)+1:end-changes(2), :);
        end
        
    end
end

