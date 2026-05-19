classdef (Sealed) ResultsWindow < handle
    properties (Constant, Access = private)
        Width  = 340;
        Height = 400;
    end

    methods (Access = public)
        function rw = ResultsWindow(results)
            win = uifigure(Name = 'AC Analysis Results', Position = [500, 200, rw.Width, rw.Height], Resize   = false);

            lines = {};
            for i = 1:numel(results)
                r    = results(i);
                name = r.Name;
                if isempty(name); name = sprintf('Device %d', i); end

                lines{end + 1} = sprintf('[ %s ]', name);
                lines{end + 1} = sprintf('  V = %s', prettify(r.Voltage, 'V'));
                lines{end + 1} = sprintf('  I = %s', prettify(r.Current, 'A'));
                lines{end + 1} = '';
            end

            uitextarea(win,                                         ...
                Value    = lines,                                   ...
                Position = [16, 16, rw.Width - 32, rw.Height - 32], ...
                Editable = false,                                   ...
                FontName = 'Courier New'                            ...
            );

            function str = prettify(val, unit)
                mag   = abs(val);
                phase = rad2deg(angle(val));
                str   = sprintf('%.4g %s  ∠ %.1f°', mag, unit, phase);
            end
        end
    end
end