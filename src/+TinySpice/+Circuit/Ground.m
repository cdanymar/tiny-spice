classdef (Sealed) Ground < handle
    properties (Constant, Access = private)
        GridSize = 20;
    end

    properties (Access = public)
        Position (1,2) double
    end

    methods (Access = public)
        function handles = draw(gnd, axes, x, y, rotation)
            g = gnd.GridSize;

            xLead = [0,    0  ];  yLead = [0,      -g    ];
            xBar1 = [-g/2, g/2];  yBar1 = [-g,     -g    ];
            xBar2 = [-g/3, g/3];  yBar2 = [-g*1.4, -g*1.4];
            xBar3 = [-g/6, g/6];  yBar3 = [-g*1.8, -g*1.8];

            [xLead, yLead] = gnd.rotatePoints(xLead, yLead, rotation);
            [xBar1, yBar1] = gnd.rotatePoints(xBar1, yBar1, rotation);
            [xBar2, yBar2] = gnd.rotatePoints(xBar2, yBar2, rotation);
            [xBar3, yBar3] = gnd.rotatePoints(xBar3, yBar3, rotation);

            color = [1, 1, 1];
            h1 = plot(axes, xLead + x, yLead + y, Color = color, LineWidth = 1.5);
            h2 = plot(axes, xBar1 + x, yBar1 + y, Color = color, LineWidth = 1.5);
            h3 = plot(axes, xBar2 + x, yBar2 + y, Color = color, LineWidth = 1.5);
            h4 = plot(axes, xBar3 + x, yBar3 + y, Color = color, LineWidth = 1.5);

            handles = [h1, h2, h3, h4];
        end
    end

    methods (Access = private)
        function [X, Y] = rotatePoints(~, x, y, angle)
            rad = deg2rad(angle);
            pts = [cos(rad), -sin(rad); sin(rad), cos(rad)] * [x; y];
            X   = pts(1, :);
            Y   = pts(2, :);
        end
    end
end