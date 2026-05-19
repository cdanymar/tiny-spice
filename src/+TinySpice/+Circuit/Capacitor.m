classdef (Sealed) Capacitor < TinySpice.Circuit.Device
    methods (Access = public)
        function handles = draw(cap, axes, x, y, rotation)
            g  = cap.GridSize;
            pw = g / 6;
            ph = g / 2;

            xLeadL = [-2 * g, -pw];
            yLeadL = [0, 0];

            xLeadR = [pw, 2 * g];
            yLeadR = [0, 0];

            xPlateL = [-pw, -pw];
            yPlateL = [-ph, ph];

            xPlateR = [pw, pw];
            yPlateR = [-ph, ph];

            [xLeadL,  yLeadL ] = cap.rotatePoints(xLeadL,  yLeadL,  rotation);
            [xLeadR,  yLeadR ] = cap.rotatePoints(xLeadR,  yLeadR,  rotation);
            [xPlateL, yPlateL] = cap.rotatePoints(xPlateL, yPlateL, rotation);
            [xPlateR, yPlateR] = cap.rotatePoints(xPlateR, yPlateR, rotation);

            color = [1, 1, 1];
            h1 = plot(axes, xLeadL  + x, yLeadL  + y, Color = color, LineWidth = 1.5);
            h2 = plot(axes, xLeadR  + x, yLeadR  + y, Color = color, LineWidth = 1.5);
            h3 = plot(axes, xPlateL + x, yPlateL + y, Color = color, LineWidth = 3.0);
            h4 = plot(axes, xPlateR + x, yPlateR + y, Color = color, LineWidth = 3.0);

            handles = [h1, h2, h3, h4];
        end

        function [entry, exit] = getTerminals(cap, x, y, rotation)
            g = cap.GridSize;

            [ex, ey] = cap.rotatePoints(-2*g, 0, rotation);
            [xx, xy] = cap.rotatePoints( 2*g, 0, rotation);

            entry = [ex + x, ey + y];
            exit  = [xx + x, xy + y];
        end

        function [A, z] = stamp(cap, A, z, n1, n2, nodeCount, frequency)
            Y = 1j * 2 * pi * frequency * cap.Value;

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