classdef (Sealed) Canvas < handle
    properties (Constant, Access = private)
        Margin   = 2;
        GridSize = 20;

        % todo: refactor
        ColorForeground = [1, 1, 1];
        ColorBackground = [0.13, 0.13, 0.13];
        ColorGrid       = [0.22, 0.22, 0.22];
        ColorComponent  = [0.92, 0.92, 0.92];
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

        function clearCanvas(canvas)
            for (i = 1:numel(canvas.Items))
                canvas.Items{i}.undo();
            end

            canvas.Items = {};
        end

        function loadCircuit(canvas, data)
            canvas.clearCanvas();

            if isstruct(data.devices)
                for i = 1:numel(data.devices)
                    d      = data.devices(i);
                    device = feval(d.type);
                    device.Name  = d.name;
                    device.Value = d.value;
                    canvas.placeDevice(device, d.x, d.y, d.angle);
                end
            end

            if isstruct(data.wires)
                for i = 1:numel(data.wires)
                    w = data.wires(i);
                    canvas.placeWire(w.x1, w.y1, w.x2, w.y2);
                end
            end

            if isstruct(data.grounds)
                for i = 1:numel(data.grounds)
                    g = data.grounds(i);
                    canvas.placeGround(g.x, g.y, g.angle);
                end
            end
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
                ColorOrder      = canvas.ColorForeground,   ...
                GridColor       = canvas.ColorGrid,         ...
                GridAlpha       = 0.5,                      ...
                ButtonDownFcn   = @canvas.onMouseClick      ...
            );

            % todo refactor defautls for drawing
            set(canvas.Axes, 'defaultLineLineWidth', 1.5);
            set(canvas.Axes, 'defaultTextFontSize', 15);
            set(canvas.Axes, 'defaultTextHorizontalAlignment', 'left');
            set(canvas.Axes, 'defaultTextVerticalAlignment', 'middle');

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

            if isempty(device)
                return;
             end

            TinySpice.UI.PropertiesWindow(device);
        end


        function onDeviceClick(canvas, x, y)
            device = canvas.createDevice(canvas.Toolbar.SelectedTool);

            if isempty(device)
                return;
             end

            canvas.placeDevice(device, x, y, canvas.Rotation);
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

                canvas.placeWire(x1, y1, x, y);
            end
        end

        function onGroundClick(canvas, x, y)
            canvas.placeGround(x, y, canvas.Rotation);
        end


        function placeDevice(canvas, device, x, y, angle)
            handles          = device.draw(canvas.Axes, x, y, angle);
            [entry, exit]    = device.getTerminals(x, y, angle);
            device.EntryNode = entry;
            device.ExitNode  = exit;

            labelY     = y - canvas.GridSize;
            nameLabel  = text(canvas.Axes, x + 8, labelY,      '');
            valueLabel = text(canvas.Axes, x + 8, labelY - 16, '');

            item = TinySpice.UI.GraphicDevice(device, x, y, angle, handles, nameLabel, valueLabel);
            item.updateLabels();
            canvas.Items{end + 1} = item;
        end

        function placeWire(canvas, x1, y1, x2, y2)
            wire    = TinySpice.Circuit.Wire();
            handles = wire.draw(canvas.Axes, x1, y1, x2, y2);
            canvas.Items{end + 1} = TinySpice.UI.GraphicWire(x1, y1, x2, y2, handles);
        end

        function placeGround(canvas, x, y, angle)
            gnd          = TinySpice.Circuit.Ground();
            gnd.Position = [x, y];
            handles      = gnd.draw(canvas.Axes, x, y, angle);
            canvas.Items{end + 1} = TinySpice.UI.GraphicGround(gnd, angle, handles);
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
            % todo: meta -> str -> meta ?
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