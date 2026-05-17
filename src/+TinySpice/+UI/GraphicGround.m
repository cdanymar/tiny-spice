classdef (Sealed) GraphicGround < handle
    properties (Access = public)
        Ground
    end

    properties (Access = private)
        Handles
    end

    methods (Access = public)
        function gg = GraphicGround(ground, handles)
            gg.Ground  = ground;
            gg.Handles = handles;
        end

        function undo(gg)
            delete(gg.Handles);
        end
    end
end