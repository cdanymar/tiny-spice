classdef (Abstract) Device < handle
    properties (Constant, Access = protected)
        GridSize = 20;
    end


    properties (Access = public)
        Name  = '';
        Value = 0;

        EntryNode;
        ExitNode;
    end


    methods (Abstract, Access = public)
        handles = draw(device, axes, x, y, angle);
        [A, z]  = stamp(device, A, z, in, out, nodeCount, frequency);
    end


    methods (Access = public)
        function [in, out] = getTerminals(device, x, y, angle)
            g = device.GridSize;

            [ix, iy] = device.rotatePoints(-2 * g, 0, angle);
            [ox, oy] = device.rotatePoints( 2 * g, 0, angle);

            in  = [ix + x, iy + y];
            out = [ox + x, oy + y];
        end

        function [X, Y] = rotatePoints(device, x, y, angle)
            rad = deg2rad(angle);
            pts = [cos(rad), -sin(rad); sin(rad), cos(rad)] * [x; y];

            X = pts(1, :);
            Y = pts(2, :);
        end
    end


    methods (Access = protected)
        function R = rotate(device, angle)
            R = [cosd(angle), -sind(angle); sind(angle),  cosd(angle)];
        end
    end
end