classdef (Sealed) GraphicGround < handle
    properties (Access = public)
        Ground;
        Rotation = 0;
    end

    properties (Access = private)
        Handles;
    end

    methods (Access = public)
        function gg = GraphicGround(ground, rotation, handles)
            gg.Ground   = ground;
            gg.Rotation = rotation;
            gg.Handles  = handles;
        end

        function undo(gg)
            delete(gg.Handles);
        end
    end
end