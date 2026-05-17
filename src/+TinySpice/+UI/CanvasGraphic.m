classdef (Abstract) CanvasGraphic < handle
    properties (Access = public)
        Handles;
    end

    methods (Access = public)
        function undo(graphic)
            delete(graphic.Handles);
        end
    end
end