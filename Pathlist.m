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
%             text(40, height, string(obj.left()),...
%                 'color', col, 'fontsize', 15);
%             text(170, height, string(obj.right()),...
%                 'color', col, 'fontsize', 15);
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

        function plothistogram(obj, edges)
            xends = zeros(length(obj.pathlist), 1);
            for i = 1:length(obj.pathlist)
                xends(i) = obj.pathlist(i).path(end, 1);
            end
            histogram(xends,edges)
        end

        function animatehistogram(obj, edges, image)
            xends = zeros(length(obj.pathlist), 1);
            for i = 1:length(obj.pathlist)
                xends(i) = obj.pathlist(i).path(end, 1);
            end
            if nargin == 3
                subplot(1,2,1); imshow(image); hold on
            end
            for i = 1:length(obj.pathlist)
                if nargin==3
                    subplot(1,2,1); plot(obj.pathlist(i).path(:,1), obj.pathlist(i).path(:,2), 'color', 'k');
                else
                    subplot(1,2,1); obj.pathlist(i).plotpath(); hold on
                end
                subplot(1,2,2); histogram(xends(1:i), edges, 'Normalization','probability');
                ylim([0 0.5]);
                set(gca, 'LineWidth', 2, 'FontSize', 15, 'xticklabel', []); box off;
                ylabel('Probability');

                set(gcf, 'color', 'w',...
                    'Position', 1000*[0.1866    0.4394    1.1160    0.2936]);
                pause(0.1);
            end
        end
    end
end

