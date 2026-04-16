classdef (Sealed) CircuitCanvas < UI.TinySpiceUI
    properties (Access = public)
        Canvas matlab.ui.control.UIAxes
        ToolBar UI.ToolBar
    end

    properties (Constant, Access = private)
        Margin  = 2
        Padding = 2
    end

    methods (Access = public)
        function canvas = CircuitCanvas(window, toolBar)
            arguments
                window  matlab.ui.Figure
                toolBar UI.ToolBar
            end

            canvas.renderCanvas(window);
            canvas.ToolBar = toolBar;
        end
    end

    methods (Access = private)
        function renderCanvas(canvas, parent)
            arguments
                canvas UI.CircuitCanvas
                parent matlab.ui.Figure
            end

            % make statically responsive
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

            % todo use meta strings?
            switch canvas.ToolBar.SelectedTool
                case UI.ToolType.PlaceResistor
                    device = UI.Resistor(canvas.Canvas, gridX, gridY);
                case UI.ToolType.PlaceCapacitor
                    device = UI.Capacitor(canvas.Canvas, gridX, gridY);
                case UI.ToolType.PlaceInductor
                    device = UI.Inductor(canvas.Canvas, gridX, gridY);
                %case UI.ToolType.PlaceGround
                    %device = UI.Ground(canvas.Canvas, gridX, gridY);
                %case UI.ToolType.PlaceBreaker
                %    device = UI.Breaker(canvas.Canvas, gridX, gridY);
                case UI.ToolType.PlaceVoltageSource
                    device = UI.VoltageSource(canvas.Canvas, gridX, gridY);
                case UI.ToolType.PlaceCurrentSource
                    device = UI.CurrentSource(canvas.Canvas, gridX, gridY);
                case UI.ToolType.PlaceWire
                    % todo
            end
        end
    end
end