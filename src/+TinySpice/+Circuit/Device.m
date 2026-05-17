classdef (Abstract) Device < handle
    properties (Constant, Access = protected)
        GridSize = 20;
    end


    properties (Access = public)
        Name = "";
        Value = 0;
        EntryNode;
        ExitNode;
    end


    methods (Abstract, Access = public)
        handles = draw(device, axes, x, y, angle);
        [in, out] = getTerminals(device, x, y, angle);
    end


    methods (Access = protected)
        function [X, Y] = rotatePoints(device, x, y, angle)
            rad = deg2rad(angle);
            pts = [cos(rad), -sin(rad); sin(rad), cos(rad)] * [x; y];

            X = pts(1, :);
            Y = pts(2, :);
        end
    end
end