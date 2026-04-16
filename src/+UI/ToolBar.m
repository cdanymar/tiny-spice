classdef (Sealed) ToolBar < UI.TinySpiceUI
    properties (Access = public)
        ToolGroup matlab.ui.container.ButtonGroup
        Buttons   (1, :) cell

        SelectedTool (1, 1) UI.ToolType = UI.ToolType.PlaceResistor
    end

    properties (Constant, Access = private)
        Margin  = 2
        Padding = 2

        ButtonSize = 32;
        ButtonGap  = 2;
    end

    methods (Access = public)
        function toolBar = ToolBar(window)
            arguments
                window matlab.ui.Figure
            end

            toolBar.renderGroup(window);

            toolBar.renderToggle(window, 0, UI.ToolType.PlaceResistor);
            toolBar.renderToggle(window, 1, UI.ToolType.PlaceCapacitor);
            toolBar.renderToggle(window, 2, UI.ToolType.PlaceInductor);
            %toolBar.renderToggle(window, 3, UI.ToolType.PlaceGround);
            %toolBar.renderToggle(window, 4, UI.ToolType.PlaceBreaker);
            toolBar.renderToggle(window, 5, UI.ToolType.PlaceVoltageSource);
            toolBar.renderToggle(window, 6, UI.ToolType.PlaceCurrentSource);
            toolBar.renderToggle(window, 7, UI.ToolType.PlaceWire);
            toolBar.renderToggle(window, 8, UI.ToolType.FreeRoam);
        end
    end

    methods (Access = private)
        function renderGroup(toolBar, parent)
            arguments
                toolBar UI.ToolBar
                parent  matlab.ui.Figure
            end

            width  = parent.Position(3) - 2 * toolBar.Margin;
            height = toolBar.ButtonSize + 2 * toolBar.Padding;

            x = toolBar.Margin;
            y = parent.Position(4) - height - toolBar.Margin;

            toolBar.ToolGroup = uibuttongroup(parent, ...
                Position = [x, y, width, height], ...
                SelectionChangedFcn = @toolBar.onToolSelected ...
            );
        end

        % todo use icons instead of text
        % todo use resource manager
        function renderToggle(toolBar, parent, offset, toolType)
            arguments
                toolBar  UI.ToolBar
                parent   matlab.ui.Figure
                offset   int32
                toolType UI.ToolType
            end

            x = toolBar.Padding + (toolBar.ButtonGap + toolBar.ButtonSize) * offset;
            y = toolBar.Padding;

            button = uitogglebutton(toolBar.ToolGroup, ...
                Text     = toolType.getIcon(), ...
                Tooltip  = toolType.getTooltip(), ...
                UserData = toolType, ...
                Position = [x, y, toolBar.ButtonSize, toolBar.ButtonSize] ...
            );

            toolBar.Buttons{end + 1} = button;
        end
    end

    methods (Access = {?UI.TinySpiceUI})
        function onToolSelected(toolBar, source, event)
            toolBar.SelectedTool = event.NewValue.UserData;
        end
    end
end