classdef (Sealed) CurrentSource < TinySpice.Circuit.Device
    methods (Access = public)
        function handles = draw(U, axes, x, y, angle)
            g = U.GridSize;
            r = g;

            theta = linspace(0, 2*pi, 60);

            circle = U.rotate(angle) * [
                r*cos(theta),   NaN,   0,   0,   NaN,    0,    0;
                r*sin(theta),   NaN,   r, 2*g,   NaN,   -r, -2*g;
            ];

            shaft = U.rotate(angle) * [
                     0,     0;
                -0.5*r, 0.5*r;
            ];
            head = U.rotate(angle) * [
                 -r/4,     0,   r/4;
                0.1*r, 0.5*r, 0.1*r;
            ];

            handles = [
                line(axes, circle(1, :) + x, circle(2, :) + y),
                line(axes,  shaft(1, :) + x,  shaft(2, :) + y),
                line(axes,   head(1, :) + x,   head(2, :) + y)
            ];
        end

        function [in, out] = getTerminals(I, x, y, angle)
            [in, out] = getTerminals@TinySpice.Circuit.Device(I, x, y, angle - 90);
        end

        function [A, z] = stamp(I, A, z, in, out, nodeCount, frequency)
            if (in > 0)
                z(in) = z(in) + I.Value;
            end

            if (out > 0)
                z(out) = z(out) - I.Value;
            end
        end
    end
end