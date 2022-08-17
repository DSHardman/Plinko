classdef Pathlist < handle
   
    properties
        pathlist
        corners
    end
    
    methods
        function obj = Pathlist(pathlist, corners)
            % Constructor
            if nargin == 0
                obj.pathlist = NaN;
                obj.corners = NaN;
            elseif nargin == 1
                obj.pathlist = pathlist;
                obj.corners = NaN;
            else
                obj.pathlist = pathlist;
                obj.corners = corners;
            end
        end
        
        function plotpaths(obj, col)
            % Plot all paths contained by object
            if nargin==1
                col = 'k';
            end
            for i = 1:length(obj.pathlist)
                obj.pathlist(i).plotpath(col);
                hold on
            end
        end

        function shiftcoordinates(obj, corners)
            % Scale based on lower left/upper right marked positions
            for i = 1:size(obj.pathlist,1)
                shiftcoordinates(obj.pathlist(i), corners);
            end
        end

        function edges = getedges(obj, level)
        % For mechanised board histograms: level 1 (single peg) to 6
            % First calculate in range 0 -> 1
            if level == 1
                edges = [0.1843 0.744; 0.5371 0.744; 0.8899 0.744];
            elseif mod(level,2) == 0
                edges = [0.1843 0.2674:0.0783:0.8157 0.8899].';
                edges = [edges (0.078 + (6-level)*0.1332)*ones(10,1)];
            else
                edges = [0.1843 0.30656:0.0783:0.77654 0.8899].';
                edges = [edges (0.078 + (6-level)*0.1332)*ones(9,1)];
            end

            % Then scale by given corner coordinates
            edges(1,:) = obj.corners(1,1) + edges(1,:)*(obj.corners(2,1)-obj.corners(1,1));
            edges(2,:) = obj.corners(1,2) + edges(2,:)*(obj.corners(2,2)-obj.corners(1,2));
        end
        
        function leftright = leftright(obj)
        % for single bounce PMMA tests: left or right
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
            % single bounce tests
            leftright = obj.leftright();
            left = leftright(1);
        end
        
        function right = right(obj)
            % single bounce tests
            leftright = obj.leftright();
            right = leftright(2);
        end

        function plothistogram(obj, level)
            % Exit distribution histogram
            edges = obj.getedges(level);

            xends = zeros(length(obj.pathlist), 1);
            for i = 1:length(obj.pathlist)
                checkpoint = find(obj.pathlist(i).path(:,2)<edges(1,2), 1, 'first');
                if ~isempty(checkpoint)
                    xends(i) = obj.pathlist(i).path(checkpoint, 1);
                else
                    xends(i) = obj.pathlist(i).path(end, 1);
                end
            end
            histogram(xends,edges(:,1), 'Normalization', 'probability');
            set(gca, 'LineWidth', 2, 'FontSize', 15); box off;
            ylabel('Probability');
        end

        function allhistograms(obj)
            for i = 1:6
                subplot(1,6,i);
                obj.plothistogram(i);
            end
        end

        function animatehistogram(obj, level, image)
            % Paths (optional on top of image), with regularly updating histogram
            edges = obj.getedges(level);
            subplot(1,2,1);
            line([edges(1,1) edges(end,1)], [edges(1,2) edges(1,2)], 'color', 'r');
            hold on
            xends = zeros(length(obj.pathlist), 1);
            for i = 1:length(obj.pathlist)
                checkpoint = find(obj.pathlist(i).path(:,2)<edges(1,2), 1, 'first');
                if ~isempty(checkpoint)
                    xends(i) = obj.pathlist(i).path(checkpoint, 1);
                else
                    xends(i) = obj.pathlist(i).path(end, 1);
                end
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
                subplot(1,2,2); histogram(xends(1:i), edges(:,1), 'Normalization','probability');
                set(gca, 'LineWidth', 2, 'FontSize', 15, 'xticklabel', []); box off;
                ylabel('Probability');

                set(gcf, 'color', 'w',...
                    'Position', 1000*[0.1866    0.4394    1.1160    0.2936]);
                pause(0.1);
            end
        end
    end
end

