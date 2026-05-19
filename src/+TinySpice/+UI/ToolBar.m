classdef (Sealed) ToolBar < handle
    properties (Constant, Access = private)
        Margin      = 2;
        Padding     = 2;
        ButtonSize  = 24;
        ButtonGap   = 2;
    end


    properties (Access = public)
        ToolGroup;
        Buttons = {};

        SelectedTool = TinySpice.UI.Tool.Resistor;
        StatusBar;
    end


    methods (Access = public)
        function toolBar = ToolBar(window, statusBar)
            toolBar.createToolGroup(window);
            toolBar.StatusBar = statusBar;

            % todo: use loop
            toolBar.createToolToggle(TinySpice.UI.Tool.Resistor);
            toolBar.createToolToggle(TinySpice.UI.Tool.Capacitor);
            toolBar.createToolToggle(TinySpice.UI.Tool.Inductor);
            toolBar.createToolToggle(TinySpice.UI.Tool.VoltageSource);
            toolBar.createToolToggle(TinySpice.UI.Tool.CurrentSource);
            toolBar.createToolToggle(TinySpice.UI.Tool.Wire);
            toolBar.createToolToggle(TinySpice.UI.Tool.Ground);
            toolBar.createToolToggle(TinySpice.UI.Tool.FreeRoam);
        end
    end


    methods (Access = private)
        function createToolGroup(toolBar, parent)
            width   = parent.Position(3) / 2 - 2 * toolBar.Margin;
            height  = toolBar.ButtonSize + 2 * toolBar.Padding;
            x       = toolBar.Margin;
            y       = parent.Position(4) - height - toolBar.Margin;

            toolBar.ToolGroup = uibuttongroup(parent,           ...
                Position            = [x, y, width, height],    ...
                BorderType          = 'none',                   ...
                SelectionChangedFcn = @toolBar.onToolSelected   ...
            );
        end

        function createToolToggle(toolBar, tool)
            x = toolBar.Padding + (toolBar.ButtonGap + toolBar.ButtonSize) * numel(toolBar.Buttons);
            y = toolBar.Padding;

            toolBar.Buttons{end + 1} = uitogglebutton(toolBar.ToolGroup,    ...
                Text     = tool.Icon,                                       ...
                Tooltip  = tool.Label,                                      ...
                UserData = tool,                                            ...
                Position = [x, y, toolBar.ButtonSize, toolBar.ButtonSize]   ...
            );
        end

        function onToolSelected(toolBar, source, event)
            toolBar.SelectedTool = event.NewValue.UserData;
            toolBar.StatusBar.setTool(toolBar.SelectedTool);
        end
    end
end