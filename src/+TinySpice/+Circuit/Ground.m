classdef (Sealed) Ground < handle
    properties (Constant, Access = private)
        GridSize = 20;
    end

    properties (Access = public)
        Position (1,2) double
    end

    methods (Access = public)
        function handles = draw(gnd, axes, x, y, angle)
            g = gnd.GridSize;

            lead = gnd.rotate(angle) * [
                0,  0;
                0, -g;
            ];

            triangle = gnd.rotate(angle) * [
                -g/2, g/2,    0, -g/2;
                -g,    -g, -2*g,   -g;
            ];

            handles = [
                line(axes,     lead(1, :) + x,     lead(2, :) + y),
                line(axes, triangle(1, :) + x, triangle(2, :) + y)
            ];
        end
    end

    methods (Access = private)
        function R = rotate(device, angle)
            R = [cosd(angle), -sind(angle); sind(angle),  cosd(angle)];
        end
    end
end