classdef (Sealed) CurrentSource < TinySpice.Circuit.Device
    methods (Access = public)
        function handles = draw(cs, axes, x, y, rotation)
            g     = cs.GridSize;
            theta = linspace(0, 2 * pi, 60);

            r = 0.8 * g;
            xCircleTop = r * cos(theta);
            yCircleTop = r * sin(theta) + 0.5 * g;
            xCircleBot = r * cos(theta);
            yCircleBot = r * sin(theta) - 0.5 * g;

            xShaft = [0, 0];
            yShaft = [-0.6 * g, 0.6 * g];

            xHead = [-g / 5, 0, g / 5, 0];
            yHead = [0.3 * g, 0.6 * g, 0.3 * g, 0.6 * g];

            xLeadT = [0, 0];
            yLeadT = [1.3 * g, 2 * g];

            xLeadB = [0, 0];
            yLeadB = [-1.3 * g, -2 * g];

            [xCircleTop, yCircleTop] = cs.rotatePoints(xCircleTop, yCircleTop, rotation);
            [xCircleBot, yCircleBot] = cs.rotatePoints(xCircleBot, yCircleBot, rotation);
            [xShaft,     yShaft    ] = cs.rotatePoints(xShaft,     yShaft,     rotation);
            [xHead,      yHead     ] = cs.rotatePoints(xHead,      yHead,      rotation);
            [xLeadT,     yLeadT    ] = cs.rotatePoints(xLeadT,     yLeadT,     rotation);
            [xLeadB,     yLeadB    ] = cs.rotatePoints(xLeadB,     yLeadB,     rotation);

            color = [1, 1, 1];
            h1 = plot(axes, xCircleTop + x, yCircleTop + y, Color = color, LineWidth = 1.5);
            h2 = plot(axes, xCircleBot + x, yCircleBot + y, Color = color, LineWidth = 1.5);
            h3 = plot(axes, xShaft     + x, yShaft     + y, Color = color, LineWidth = 1.5);
            h4 = plot(axes, xHead      + x, yHead      + y, Color = color, LineWidth = 1.5);
            h5 = plot(axes, xLeadT     + x, yLeadT     + y, Color = color, LineWidth = 1.5);
            h6 = plot(axes, xLeadB     + x, yLeadB     + y, Color = color, LineWidth = 1.5);

            handles = [h1, h2, h3, h4, h5, h6];
        end

        function [entry, exit] = getTerminals(cs, x, y, rotation)
            g = cs.GridSize;

            [ex, ey] = cs.rotatePoints(0, 2 * g, rotation);
            [xx, xy] = cs.rotatePoints(0, -2 * g, rotation);

            entry = [ex + x, ey + y];
            exit  = [xx + x, xy + y];
        end

        function [A, z] = stamp(cs, A, z, n1, n2, ~, ~)
            if (n1 > 0)
                z(n1) = z(n1) + cs.Value;
            end

            if (n2 > 0)
                z(n2) = z(n2) - cs.Value;
            end
        end
    end
end