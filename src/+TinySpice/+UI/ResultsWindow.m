classdef (Sealed) ResultsWindow < handle
    properties (Constant, Access = private)
        Width  = 300;
        Height = 400;
    end

    methods (Access = public)
        function rw = ResultsWindow(voltages, currents)
            window = uifigure(                                             ...
                Name     = 'AC Analysis Results',                       ...
                Position = [500, 200, rw.Width, rw.Height],             ...
                Resize   = false                                        ...
            );

            lines = {};

            for i = 1:numel(voltages)
                lines{end + 1} = sprintf('V(node %d) = %.4g V', i, voltages(i));
            end

            for i = 1:numel(currents)
                lines{end + 1} = sprintf('I(source %d) = %.4g A', i, currents(i));
            end

            uitextarea(window,                                             ...
                Value    = lines,                                       ...
                Position = [16, 16, rw.Width - 32, rw.Height - 32],     ...
                Editable = false                                        ...
            );
        end
    end
end