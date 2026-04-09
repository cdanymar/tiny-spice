classdef (Sealed) ToolBar < UI.TinySpiceUI
    properties (Access = public)
        ToolPanel matlab.ui.container.Panel
    end

    methods (Access = public)
        function toolBar = ToolBar(window)
            arguments
                window matlab.ui.Figure
            end
        end
    end
end
