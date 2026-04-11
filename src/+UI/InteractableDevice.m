classdef (Abstract) InteractableDevice < UI.TinySpiceUI
    properties (Access = public) % todo {mustBe's} % todo relative node positions
        X          double
        Y          double
        CanvasAxes matlab.ui.control.UIAxes
        Sprite
    end

    properties (Abstract, SetAccess = protected)
        Width  double
        Height double
    end

    methods (Access = public)
        function device = InteractableDevice(x, y, axes)
            % todo arguments & spacing
            device.X = x;
            device.Y = y
            device.CanvasAxes = axes;
        end
    end

    methods (Abstract, Access = public)
        % todo place
        draw(device);
    end
end
