classdef (Sealed) Resistor < UI.InteractableDevice
    properties (SetAccess = protected)
        Width  = 60;
        Height = 20;
    end

    methods (Access = public)
        function resistor = Resistor(ax, x, y)
            resistor@UI.InteractableDevice(x, y, ax);
            
            resistor.calculatePins();
            resistor.draw();
        end

        function draw(resistor)
        end
    end

    methods (Access = private)
        function onResistorClick(resistor, ~, ~)
        end
    end
end