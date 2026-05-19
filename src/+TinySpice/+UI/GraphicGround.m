classdef (Sealed) GraphicGround < handle
    properties (Access = public)
        Ground;
        Rotation = 0;
    end

    properties (Access = private)
        Handles;
    end

    methods (Access = public)
        function gg = GraphicGround(ground, angle, handles)
            gg.Ground   = ground;
            gg.Rotation = angle;
            gg.Handles  = handles;
        end

        function undo(gg)
            delete(gg.Handles);
        end
    end
end