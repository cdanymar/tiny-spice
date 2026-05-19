classdef (Sealed) Inductor < TinySpice.Circuit.VoltageDefinedDevice
    methods (Access = public)
        function handles = draw(ind, axes, x, y, rotation)
            g    = ind.GridSize;
            rb   = g / 4;
            nb   = 4;
            hw   = nb * rb;
            theta = linspace(pi, 0, 20);

            xLeadL = [-2 * g, -hw];
            yLeadL = [0, 0];

            xLeadR = [hw, 2 * g];
            yLeadR = [0, 0];

            xBumps = [];
            yBumps = [];
            for i = 0:nb - 1
                cx     = -hw + rb + i * 2 * rb;
                xBumps = [xBumps, cx + rb * cos(theta)];
                yBumps = [yBumps,      rb * sin(theta)];
            end

            [xLeadL, yLeadL] = ind.rotatePoints(xLeadL, yLeadL, rotation);
            [xLeadR, yLeadR] = ind.rotatePoints(xLeadR, yLeadR, rotation);
            [xBumps, yBumps] = ind.rotatePoints(xBumps, yBumps, rotation);

            color = [1, 1, 1];
            h1 = plot(axes, xLeadL + x, yLeadL + y, Color = color, LineWidth = 1.5);
            h2 = plot(axes, xLeadR + x, yLeadR + y, Color = color, LineWidth = 1.5);
            h3 = plot(axes, xBumps + x, yBumps + y, Color = color, LineWidth = 1.5);

            handles = [h1, h2, h3];
        end

        function [entry, exit] = getTerminals(ind, x, y, rotation)
            g = ind.GridSize;

            [ex, ey] = ind.rotatePoints(-2*g, 0, rotation);
            [xx, xy] = ind.rotatePoints( 2*g, 0, rotation);

            entry = [ex + x, ey + y];
            exit  = [xx + x, xy + y];
        end

        function [A, z] = stamp(ind, A, z, n1, n2, nodeCount, freq)
            k = nodeCount + ind.Index;
            Z = 1j * 2 * pi * freq * ind.Value;

            if (n1 > 0)
                A(n1, k) = A(n1, k) + 1;
                A(k, n1) = A(k, n1) + 1;
            end

            if (n2 > 0)
                A(n2, k) = A(n2, k) - 1;
                A(k, n2) = A(k, n2) - 1;
            end

            A(k, k) = A(k, k) - Z;
        end
    end
end