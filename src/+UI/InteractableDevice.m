classdef (Abstract) InteractableDevice < UI.TinySpiceUI
    properties (Access = public)
        X          double
        Y          double
        CanvasAxes matlab.ui.control.UIAxes
        Sprite

        Name
        Value
        EntryNode
        ExitNode
    end

    properties (Abstract, SetAccess = protected)
        Width  double
        Height double
    end

    methods (Access = public)
        function device = InteractableDevice(x, y, axes)
            device.X = x;
            device.Y = y
            device.CanvasAxes = axes;
        end

        function calculatePins(device)
            offset = device.Width / 2;
            device.Pins = [
                device.X - offset, device.Y;
                device.X + offset, device.Y;
            ];
        end

        function debugPivots(device)
            radius = 3;

            for i = 1:size(device.Pins, 1)
                rectangle(device.CanvasAxes, ...
                    Position  = [device.Pins(i,1) - radius, device.Pins(i,2) - radius, radius*2, radius*2], ...
                    Curvature = [1 1], ...
                    FaceColor = "red", ...
                    EdgeColor = "none", ...
                    HitTest   = "off" ...
                );
            end
        end

        function path = getResourcePath(obj, fileName)
            fullPath = which('UI.InteractableDevice');
            thisDir = fileparts(fullPath);
            projectRoot = fileparts(fileparts(thisDir));

            path = fullfile(projectRoot, 'sprites', fileName);
        end
    end

    methods (Access = protected)
        function showPropertiesWindow(device)

        end
    end

    methods (Abstract, Access = public)
        % todo place
        draw(device);
    end
end
