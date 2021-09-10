classdef Pathtaken
   
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
        
        function plotpath(obj)
            x = -obj.path(1:end,2);
            y = obj.path(1:end,1);
            plot(x,y, 'Color', 'w');
            set(gca,'Color','k', 'XTick', [], 'YTick', []);
        end
        
    end
end

