classdef (Sealed) Canvas < handle
    properties (Constant, Access = private)
        Margin   = 2;
        GridSize = 20;

        % todo: refactor
        ColorBackground = [0.13 0.13 0.13];
        ColorGrid       = [0.22 0.22 0.22];
        ColorComponent  = [0.92 0.92 0.92];
    end

    properties (Access = private)
        Axes;

        Toolbar;
        StatusBar;

        Rotation  = 0;
        Items     = {};
        WireBegin = [];
        WireDot   = [];
    end

    methods (Access = public)
        function canvas = Canvas(window, toolbar, statusBar)
            canvas.Toolbar = toolbar;
            canvas.StatusBar = statusBar;
            canvas.createAxes(window);
        end

        function items = getItems(canvas)
            items = canvas.Items;
        end
    end

    methods (Access = private)
        function createAxes(canvas, parent)
            statusBarHeight = 22;
            toolbarHeight = 24 + 2 * 2 + 2 * canvas.Margin;

            x      = -50;
            y      = canvas.Margin - 10;
            width  = parent.Position(3) + 100;
            height = parent.Position(4) - 30;

            canvas.Axes = uiaxes(parent,                    ...
                Position        = [x, y, width, height],    ...
                XLim            = [0, width],               ...
                YLim            = [0, height],              ...
                XTick           = 0:canvas.GridSize:width,  ...
                YTick           = 0:canvas.GridSize:height, ...
                Color           = canvas.ColorBackground,   ...
                BackgroundColor = canvas.ColorBackground,   ...
                XColor          = canvas.ColorBackground,   ...
                YColor          = canvas.ColorBackground,   ...
                GridColor       = canvas.ColorGrid,         ...
                GridAlpha       = 1,                        ...
                ButtonDownFcn   = @canvas.onMouseClick      ...
            );

            grid(canvas.Axes, 'on');
            hold(canvas.Axes, true);

            parent.KeyPressFcn = @canvas.onKeyPress;
        end


        function onKeyPress(canvas, ~, event)
            if strcmpi(event.Key, 'z') && any(strcmpi(event.Modifier, 'control'));
                canvas.undo();
            elseif strcmpi(event.Key, 'r')
                canvas.Rotation = mod(canvas.Rotation + 90, 360);
                canvas.StatusBar.setRotation(canvas.Rotation);
            end
        end

        function onMouseClick(canvas, ~, event)
            raw = event.IntersectionPoint(1:2);
            x   = round(raw(1) / canvas.GridSize) * canvas.GridSize;
            y   = round(raw(2) / canvas.GridSize) * canvas.GridSize;

            switch canvas.Axes.Parent.SelectionType
                case 'normal'
                    canvas.onLeftClick(x, y);
                case 'alt'
                    canvas.onRightClick(x, y);
            end
        end

        function onLeftClick(canvas, x, y)
            switch canvas.Toolbar.SelectedTool
                case TinySpice.UI.Tool.Wire
                    canvas.onWireClick(x, y);
                case TinySpice.UI.Tool.Ground
                    canvas.onGroundClick(x, y);
                otherwise
                    canvas.onDeviceClick(x, y);
            end
        end

        function onRightClick(canvas, x, y)
            device = canvas.findDeviceAt(x, y);
            if isempty(device); return; end

            TinySpice.UI.PropertiesWindow(device);
        end


        function onWireClick(canvas, x, y)
            if isempty(canvas.WireBegin)
                canvas.WireBegin = [x, y];
                canvas.WireDot   = plot(canvas.Axes, x, y, '.', Color = [1 1 1], MarkerSize = 12);
            else
                x1 = canvas.WireBegin(1);
                y1 = canvas.WireBegin(2);

                delete(canvas.WireDot);
                canvas.WireBegin = [];
                canvas.WireDot   = [];

                wire    = TinySpice.Circuit.Wire();
                handles = wire.draw(canvas.Axes, x1, y1, x, y);
                canvas.Items{end + 1} = TinySpice.UI.GraphicWire(x1, y1, x, y, handles);
            end
        end

        function onDeviceClick(canvas, x, y)
            device = canvas.createDevice(canvas.Toolbar.SelectedTool);
            if isempty(device);
                return;
            end

            handles = device.draw(canvas.Axes, x, y, canvas.Rotation);
            [entry, exit] = device.getTerminals(x, y, canvas.Rotation);
            device.EntryNode = entry;
            device.ExitNode = exit;

            labelY = y - canvas.GridSize;
            nameLabel = text(canvas.Axes, x + 15, labelY, device.Name, Color = canvas.ColorComponent, FontSize=12, HorizontalAlignment='center');
            valueLabel = text(canvas.Axes, x + 15, labelY - 8, num2str(device.Value), Color = canvas.ColorComponent, FontSize=12, HorizontalAlignment='center');


            canvas.Items{end + 1} = TinySpice.UI.GraphicDevice(device, x, y, canvas.Rotation, handles, nameLabel, valueLabel);
        end

        function onGroundClick(canvas, x, y)
            ground = TinySpice.Circuit.Ground();
            ground.Position = [x, y];
            handles = ground.draw(canvas.Axes, x, y, canvas.Rotation);

            canvas.Items{end + 1} = TinySpice.UI.GraphicGround(ground, handles);
        end


        function undo(canvas)
            if ~isempty(canvas.WireBegin)
                delete(canvas.WireDot);
                canvas.WireBegin = [];
                canvas.WireDot   = [];
                return;
            end

            if isempty(canvas.Items); return; end

            canvas.Items{end}.undo();
            canvas.Items(end) = [];
        end

        function redo(canvas)
            % todo
        end


        function device = createDevice(canvas, tool)
            switch tool
                case TinySpice.UI.Tool.Resistor
                    device = TinySpice.Circuit.Resistor();
                case TinySpice.UI.Tool.Capacitor
                    device = TinySpice.Circuit.Capacitor();
                case TinySpice.UI.Tool.Inductor
                    device = TinySpice.Circuit.Inductor();
                case TinySpice.UI.Tool.VoltageSource
                    device = TinySpice.Circuit.VoltageSource();
                case TinySpice.UI.Tool.CurrentSource
                    device = TinySpice.Circuit.CurrentSource();
                otherwise
                    device = [];
            end
        end

        function device = findDeviceAt(canvas, x, y)
            device    = [];
            threshold = canvas.GridSize * 1.5;
            closest   = inf;

            for (i = 1:numel(canvas.Items))
                item = canvas.Items{i};

                if ~isa(item, 'TinySpice.UI.GraphicDevice')
                    continue;
                end

                dist = norm([item.X - x, item.Y - y]);
                if dist < threshold && dist < closest
                    closest = dist;
                    device  = item;
                end
            end
        end
    end
end