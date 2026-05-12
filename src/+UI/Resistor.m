classdef (Sealed) Resistor < UI.InteractableDevice
    properties (Constant, Access = private)
        Width  = 60;
        Height = 20;
    end

    methods (Access = public)
        function resistor = Resistor(ax, x, y)
            resistor@UI.InteractableDevice(x, y, ax);
            resistor.draw();
        end

        function [x, y] = getPivotPositions(resistor)
            x = [resistor.X - (resistor.Width / 2), resistor.X + (resistor.Width / 2)];
            y = [resistor.Y, resistor.Y];
        end

        function draw(resistor)
            [pivotX, pivotY] = resistor.getPivotPositions();

            w = resistor.Width * 2/3;
            h = resistor.Height;

            l = resistor.X - (w / 2);
            b = resistor.Y - (h / 2);

            resistor.drawLine([pivotX(1), l], [resistor.Y, resistor.Y]);
            resistor.drawLine([l + w, pivotX(2)], [resistor.Y, resistor.Y]);

            resistor.drawRectangle(l, b, w, h);

            resistor.drawPivot(pivotX(1), pivotY(1));
            resistor.drawPivot(pivotX(2), pivotY(2));
        end
    end

    methods (Access = protected)
    end
end