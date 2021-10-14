classdef Pathlist < handle
   
    properties
        pathlist
    end
    
    methods
        function obj = Pathlist(pathlist)
            if nargin == 0
                obj.pathlist = NaN;
            else
                obj.pathlist = pathlist;
            end
        end
        
        function plotpaths(obj, col, height)
            if nargin==1
                col = 'k';
            end
                
            for i = 1:length(obj.pathlist)
                obj.pathlist(i).plotpath(col);
                hold on
            end
            text(40, height, string(obj.left()),...
                'color', col, 'fontsize', 15);
            text(170, height, string(obj.right()),...
                'color', col, 'fontsize', 15);
        end
        
        function leftright = leftright(obj)
            leftright = [0 0];
            for i = 1:length(obj.pathlist)
                path = obj.pathlist(i);
                if path.path(end,1) > 100
                    leftright(1,2) = leftright(1,2) + 1;
                elseif path.path(end,1) < 100
                    leftright(1,1) = leftright(1,1) + 1;
                end
            end
        end
        
        function left = left(obj)
            leftright = obj.leftright();
            left = leftright(1);
        end
        
        function right = right(obj)
            leftright = obj.leftright();
            right = leftright(2);
        end
    end
end

