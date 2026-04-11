classdef (Sealed) CircuitCanvas < UI.TinySpiceUI
    properties (Access = public)
        Canvas matlab.ui.control.UIAxes
    end

    properties (Constant, Access = private)
        Margin  = 2
        Padding = 2
    end

    methods (Access = public)
        function canvas = CircuitCanvas(window)
            arguments
                window matlab.ui.Figure
            end

            canvas.renderCanvas(window);
        end
    end

    methods (Access = private)
        function renderCanvas(canvas, parent)
            arguments
                canvas UI.CircuitCanvas
                parent matlab.ui.Figure
            end

            x = 0;
            y = 4;
            width = 800;
            height = 600 - 4-2 - 32;

            % todo rework position
            canvas.Canvas = uiaxes(parent, ...
                Position      = [0, 0, width, height], ...
                XTick         = [], ...
                YTick         = [], ...
                XColor        = 'none', ...
                YColor        = 'none', ...
                XLim          = [0, width], ...
                YLim          = [0, height], ...
                ButtonDownFcn = @canvas.onCanvasClick ...
            );

            canvas.Canvas.Toolbar.Visible = 'off';
        end
    end

    methods (Access = {?UI.TinySpiceUI})
        function onCanvasClick(canvas, source, event)
            % todo arguments

            gridSize = 10;

            rawX = event.IntersectionPoint(1);
            rawY = event.IntersectionPoint(2);

            gridX = round(rawX / gridSize) * gridSize;
            gridY = round(rawY / gridSize) * gridSize;

            r = UI.Resistor(canvas.Canvas, gridX, gridY);
        end
    end
end