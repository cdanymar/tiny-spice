classdef (Sealed) Inductor < TinySpice.Circuit.VoltageDefinedDevice
    methods (Access = public)
        function handles = draw(L, axes, x, y, angle)
            g  = L.GridSize;

            n = 3;
            r = g / n;
            w = n * r;

            theta = linspace(pi, 0, 20);
            xBumps = [];
            yBumps = [];

            for (i = 0:n-1)
                cx = -w + r + i * 2 * r;

                xBumps = [xBumps, cx + r * cos(theta)];
                yBumps = [yBumps,      r * sin(theta)];
            end

            path = L.rotate(angle) * [
                -2*g, -w,   NaN,   xBumps,   NaN,   w, 2*g;
                   0,  0,   NaN,   yBumps,   NaN,   0,   0;
            ];

            handles = [
                line(axes, path(1, :) + x, path(2, :) + y)
            ];
        end


        function [A, z] = stamp(L, A, z, in, out, nodeCount, frequency)
            k = nodeCount + L.Index;
            Z = 2i*pi * frequency * L.Value;

            if (in > 0)
                A(in, k) = A(in, k) + 1;
                A(k, in) = A(k, in) + 1;
            end

            if (out > 0)
                A(out, k) = A(out, k) - 1;
                A(k, out) = A(k, out) - 1;
            end

            A(k, k) = A(k, k) - Z;
        end
    end
end