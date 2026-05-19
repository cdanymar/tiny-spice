classdef (Sealed) VoltageSource < TinySpice.Circuit.VoltageDefinedDevice
    methods (Access = public)
        function handles = draw(U, axes, x, y, angle)
            g = U.GridSize;
            r = g;

            theta = linspace(0, 2*pi, 60);

            circle = U.rotate(angle) * [
                r*cos(theta),   NaN,   0,   0,   NaN,    0,    0;
                r*sin(theta),   NaN,   r, 2*g,   NaN,   -r, -2*g;
            ];

            labels = U.rotate(angle) * [
                  0,    0;
                r/2, -r/2;
            ];

            handles = [
                line(axes, circle(1, :) + x, circle(2, :) + y),
                text(axes, labels(1, 1) + x, labels(2, 1) + y, '+', HorizontalAlignment = 'center')
                text(axes, labels(1, 2) + x, labels(2, 2) + y, '−', HorizontalAlignment = 'center')
            ];
        end

        function [in, out] = getTerminals(U, x, y, angle)
            [in, out] = getTerminals@TinySpice.Circuit.Device(U, x, y, angle - 90);
        end

        function [A, z] = stamp(U, A, z, in, out, nodeCount, frequency)
            k = nodeCount + U.Index;

            if (in > 0)
                A(in, k) = A(in, k) + 1;
                A(k, in) = A(k, in) + 1;
            end

            if (out > 0)
                A(out, k) = A(out, k) - 1;
                A(k, out) = A(k, out) - 1;
            end

            z(k) = U.Value;
        end
    end
end