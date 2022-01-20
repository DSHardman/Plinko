classdef Population
    properties
        counters % Array of Counter objects
    end

    methods
        function obj = Population(counters)
        % CONSTRUCTOR
            obj.counters = counters;
        end

        function generate(obj, filename)
        % Generate single gcode file to print entire population at once
        % Current slicer API only allows one bounding box to be applied per
        % field, so this is achieved by slicing each counter individually
        % and manually combining the gcode files

            % Arrange counters in grid on build plate
            spacing = 40;
            gridn = ceil(sqrt(size(obj.counters,1)));
            gridedge = -((gridn-1)/2)*spacing:spacing:((gridn-1)/2)*spacing;
            [X,Y] = meshgrid(gridedge,gridedge);
            X = reshape(X,[],1); Y = reshape(Y,[],1);
            translations = [X Y];

            % Generate and read through all gcode files, finding locations
            % at which each layer starts/ends
            no_layers = 10; % assume 3mm thickness and 0.3mm layers
            layerlocations = zeros(no_layers+1, size(obj.counters, 1));
            for i = 1:size(obj.counters, 1)
                fprintf('%d/%d\n', i, size(obj.counters, 1));
                obj.counters(i).generate("temp"+string(i));  
                f = fopen("temp"+string(i)+".gcode",'r');
                n = 1;
                layers = 0;
                line = fgetl(f);
                while ischar(line) && layers < 11
                    line = fgetl(f);
                    n = n + 1;
                    if contains(line,"Z0.3") % Find start of first layer
                        if layers % which begins from second occurrence
                            layerlocations(1, i) = n;
                        end
                        layers = 1;
                    % All other layers identified by zeroing extruder
                    elseif contains(line, "G92 E0") && layers
                        layers = layers + 1;
                        layerlocations(layers, i) = n;
                    end
                end
                fclose(f);
            end
            
            fprintf("Combining gcode...\n")

            % Copy printer setup lines to output file
            gcodestring = "";
            f = fopen("temp1.gcode",'r');
            for i = 1:layerlocations(1,1) - 1
                line = fgetl(f);
                gcodestring = gcodestring + line + "\n";
            end
            fclose(f);
            f = fopen(filename + ".gcode", 'w');
            fprintf(f, gcodestring);
            fclose(f);

            % This matrix stores final coordinates after each counter
            % layer, so nozzle can return before printing next layer
            known_coordinates = zeros(size(obj.counters, 1), 2);

            % Iterate through all counters' gcode in every layer
            for i = 1:no_layers
                for j = 1:size(obj.counters, 1)

                    % Extract translate from centre of this counter
                    xtrans = translations(j, 1);
                    ytrans = translations(j, 2);

                    % Return to end of previous layer
                    gcodestring = "";
                    if i > 1
                        f = fopen(filename + ".gcode", 'a');
                        fprintf(f, "G0 X" +...
                            string(known_coordinates(j, 1)+xtrans) +...
                            " Y" +...
                            string(known_coordinates(j, 2)+ytrans) + "\n");
                        fclose(f);
                    end

                    % Read layer gcode for the counter
                    f = fopen("temp"+string(j)+".gcode",'r');
                    entry = textscan(f, '%s',...
                        layerlocations(i+1,j)-layerlocations(i,j),...
                        'Headerlines', layerlocations(i, j)-1,...
                        'Delimiter' ,'\n');
                    fclose(f);
                   
                    for k = 1:layerlocations(i+1,j)-layerlocations(i,j)
                    % Iterate through each command, extracting and
                    % translating x/y coordinates where necessary
                        line = char(entry{1}{k});
                        xloc = strfind(line, "X");
                        yloc = strfind(line, "Y");
                        spaceloc = strfind(line, " ");
                        if ~isempty(xloc)
                            xstop = spaceloc(find(spaceloc>xloc,1))-1;
                            if isempty(xstop)
                                xval = str2double(line(xloc+1:end));
                            else
                                xval = str2double(line(xloc+1:xstop));
                            end

                            if ~isempty(yloc)
                                % Values of x and y given
                                ystop = spaceloc(find(spaceloc>yloc,1))-1;
                                if isempty(ystop)
                                    yval = str2double(line(yloc+1:end));
                                else
                                    yval = str2double(line(yloc+1:ystop));
                                end
                                line = line(1:xloc) +...
                                    string(xval+xtrans) + " Y" +...
                                    string(yval + ytrans) +...
                                    line(spaceloc(find(spaceloc>yloc,1)):end);
                            else
                                % Only values of x given
                                line = line(1:xloc) +...
                                    string(xval+xtrans) +...
                                    line(spaceloc(find(spaceloc>xloc,1)):end);
                            end
                        else
                            if ~isempty(yloc)
                                % Only values of y given
                                ystop = spaceloc(find(spaceloc>yloc,1))-1;
                                if isempty(ystop)
                                    yval = str2double(line(yloc+1:end));
                                else
                                    yval = str2double(line(yloc+1:ystop));
                                end
                                line = line(1:yloc) +...
                                    string(yval+ytrans) +...
                                    line(spaceloc(find(spaceloc>yloc,1)):end);
                            end
                        end

                        % Add the amended line to our commands
                        gcodestring = gcodestring + line + "\n";

                        % Update final coordinates of layer
                        if k == layerlocations(i+1,j)-layerlocations(i,j)
                            known_coordinates(j, :) = [xval yval];
                        end
                    end

                    % Write the counter's layer to file
                    f = fopen(filename + ".gcode", 'a');
                    fprintf(f, gcodestring + "G92 E0\n");
                    fclose(f);
                end
            end

            % Add generic commands to end of script
            f = fopen(filename + ".gcode", 'a');
            gcodestring = "nG0 F100 Z3.200000\nG92 E0\nG4 ;" + ...
                " wait\nM221 S100\nM104 S0 ; turn off temperature\n" + ...
                "M140 S0 ; turn off heatbed\nM107 ; turn off fan\n" + ...
                "G1 F6200 X0 Y200; home X axis\nM84 ; disable motors";
            fprintf(f, gcodestring);
            fclose(f);
            
            % Close and delete temporary gcode files
            fclose('all');
            system('del temp*.gcode');

            fprintf("gcode combined.\n")

            % View output
            system(string(filename) + ".gcode");
        end
    end
end