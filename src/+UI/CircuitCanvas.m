classdef (Sealed) CircuitCanvas < UI.TinySpiceUI
    methods (Access = public)
        function circuitCanvas = CircuitCanvas(window)
            arguments
                window matlab.ui.Figure
            end
        end
    end
end
