classdef RotatingPath < handle
   
    properties
        path
    end
    
    methods
        function obj = RotatingPath(locations)
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

            plot(obj.path(:,1), obj.path(:,2), 'Color', col);
            xlim([-400 400]);
            ylim([-400 400]);
            axis square
        end
        
        function plotunspun(obj, rpm, col)
            %remove constant rotation from plotted figure
            
            if nargin==2
                col = 'k';
            end
            
            [phis, rs] = cart2pol(obj.path(:,1), obj.path(:,2));
            for i = 1:length(phis)
                if ~isnan(phis(i) + rs(i))
                    t = i/30.0165; %frame rate is hard coded here
                    phis(i) = phis(i) - mod((rpm/60)*(2*pi)*t, 2*pi);
                end    
            end
            
            [xs, ys] = pol2cart(phis, rs);
            
            plot(xs,ys, 'Color', col);
            xlim([-400 400]);
            ylim([-400 400]);
            axis square
        end

        function radialhist(obj)
            radii = zeros(size(obj.path, 1), 1);
            for i = 1:size(obj.path, 1)
                radii(i) = norm(obj.path(i,:));
            end
            histogram(radii, [0:25:400], 'Normalization','probability');
            ylim([0 0.4]);
        end
        
    end
end

