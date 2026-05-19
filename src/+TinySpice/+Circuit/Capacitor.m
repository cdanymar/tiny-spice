classdef (Sealed) Capacitor < TinySpice.Circuit.Device
    properties (Constant, Access = private)
        PadWidth = 2.5;
    end


    methods (Access = public)
        function handles = draw(C, axes, x, y, angle)
            g = C.GridSize;

            w = g / 6;
            h = g / 2;

            leads = C.rotate(angle) * [
                -2*g, -w,   NaN,    w, 2*g;
                   0,  0,   NaN,    0,   0;
            ];
            plates = C.rotate(angle) * [
                  -w, -w,   NaN,    w, w;
                  -h,  h,   NaN,   -h, h;
            ];

            handles = [
                line(axes,  leads(1, :) + x,  leads(2, :) + y),
                line(axes, plates(1, :) + x, plates(2, :) + y, LineWidth = C.PadWidth)
            ];
        end

        function [A, z] = stamp(C, A, z, in, out, nodeCount, frequency)
            Y = 2i*pi * frequency * C.Value;

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