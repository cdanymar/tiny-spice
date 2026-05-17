classdef (Sealed) Wire < handle
    methods (Access = public)
        function handles = draw(wire, axes, x1, y1, x2, y2)
            color = [1, 1, 1];

            h1 = plot(axes, [x1, x2], [y1, y1], Color = color, LineWidth = 1.5);
            h2 = plot(axes, [x2, x2], [y1, y2], Color = color, LineWidth = 1.5);

            handles = [h1, h2];
        end
    end
end