classdef (Sealed) VoltageSource < TinySpice.Circuit.VoltageDefinedDevice
    methods (Access = public)
        function handles = draw(vs, axes, x, y, rotation)
            color = [1 1 1];
            g     = vs.GridSize;
            r     = g;
            theta = linspace(0, 2 * pi, 60);

            xLeadT = [0, 0 ];
            yLeadT = [r, 2 * g];

            xLeadB = [0, 0];
            yLeadB = [-r, -2 * g];

            xPlus  =  0;
            yPlus  =  r / 2;

            xMinus =  0;
            yMinus = -r / 2;

            [xLeadT, yLeadT] = vs.rotatePoints(xLeadT, yLeadT, rotation);
            [xLeadB, yLeadB] = vs.rotatePoints(xLeadB, yLeadB, rotation);
            [xPlus,  yPlus ] = vs.rotatePoints(xPlus,  yPlus,  rotation);
            [xMinus, yMinus] = vs.rotatePoints(xMinus, yMinus, rotation);

            h1 = plot(axes, x + r * cos(theta), y + r * sin(theta), Color = color, LineWidth = 1.5);

            h2 = plot(axes, xLeadT + x, yLeadT + y, Color = color, LineWidth = 1.5);
            h3 = plot(axes, xLeadB + x, yLeadB + y, Color = color, LineWidth = 1.5);

            h4 = text(axes, xPlus  + x, yPlus  + y, '+', Color = color, FontSize = 11, HorizontalAlignment = 'center');
            h5 = text(axes, xMinus + x, yMinus + y, '−', Color = color, FontSize = 11, HorizontalAlignment = 'center');

            handles = [h1, h2, h3, h4, h5];
        end

        function [in, out] = getTerminals(voltageSource, x, y, rotation)
            g = voltageSource.GridSize;

            [ix, iy] = voltageSource.rotatePoints(0,  2*g, rotation);
            [ox, oy] = voltageSource.rotatePoints(0, -2*g, rotation);

            in  = [ix + x, iy + y];
            out = [ox + x, oy + y];
        end
    end
end