classdef (Sealed) GraphicWire < TinySpice.UI.CanvasGraphic
    properties (Access = public)
        X1, Y1;
        X2, Y2;
    end


    methods (Access = public)
        function wire = GraphicWire(x1, y1, x2, y2, handles)
            wire.X1 = x1;
            wire.Y1 = y1;
            wire.X2 = x2;
            wire.Y2 = y2;
            wire.Handles = handles;
        end
    end
end