classdef (Sealed) Resistor < TinySpice.Circuit.Device
    methods (Access = public)
        function handles = draw(R, axes, x, y, angle)
            g  = R.GridSize;
            w = g;
            h = g / 2;

            rect = R.rotate(angle) * [
                -2*g, -w,   NaN,   -w,  w, w, -w, -w,   NaN,   w, 2*g;
                   0,  0,   NaN,   -h, -h, h,  h, -h,   NaN,   0,   0;
            ];

            handles = [
                line(axes, rect(1, :) + x, rect(2, :) + y)
            ];
        end

        function [A, z] = stamp(R, A, z, in, out, nodeCount, frequency)
            Y = 1 / R.Value;

            if (in > 0)
                A(in, in) = A(in, in) + Y;
            end

            if (out > 0)
                A(out, out) = A(out, out) + Y;
            end

            if (in > 0) && (out > 0)
                A(in, out) = A(in, out) - Y;
                A(out, in) = A(out, in) - Y;
            end
        end
    end
end