classdef (Sealed) Resistor < TinySpice.Circuit.Device
    methods (Access = public)
        function handles = draw(resistor, axes, x, y, angle)
            g  = resistor.GridSize;
            bw = g;
            bh = g / 2;

            xLeadL = [-2*g, -bw];
            yLeadL = [0, 0];
            xLeadR = [bw, 2*g];
            yLeadR = [0, 0];

            xBox = [-bw,  bw, bw, -bw, -bw];
            yBox = [-bh, -bh, bh,  bh, -bh];

            [xLeadL, yLeadL] = resistor.rotatePoints(xLeadL, yLeadL, angle);
            [xLeadR, yLeadR] = resistor.rotatePoints(xLeadR, yLeadR, angle);
            [xBox, yBox] = resistor.rotatePoints(xBox, yBox, angle);

            color = [1, 1, 1];
            h1 = plot(axes, xLeadL + x, yLeadL + y, Color = color, LineWidth = 1.5);
            h2 = plot(axes, xLeadR + x, yLeadR + y, Color = color, LineWidth = 1.5);
            h3 = plot(axes, xBox   + x, yBox   + y, Color = color, LineWidth = 1.5);

            handles = [h1, h2, h3];
        end

        function [in, out] = getTerminals(resistor, x, y, angle)
            g = resistor.GridSize;

            [ix, iy] = resistor.rotatePoints(-2 * g, 0, angle);
            [ox, oy] = resistor.rotatePoints( 2 * g, 0, angle);

            in  = [ix + x, iy + y];
            out = [ox + x, oy + y];
        end

        function [A, z] = stamp(resistor, A, z, n1, n2, nodeCount, frequency)
            Y = 1 / resistor.Value;

            if (n1 > 0)
                A(n1, n1) = A(n1, n1) + Y;
            end

            if (n2 > 0)
                A(n2, n2) = A(n2, n2) + Y;
            end

            if (n1 > 0) && (n2 > 0)
                A(n1, n2) = A(n1, n2) - Y;
                A(n2, n1) = A(n2, n1) - Y;
            end
        end
    end
end