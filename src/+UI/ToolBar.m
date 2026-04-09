classdef (Sealed) ToolBar < UI.TinySpiceUI
    properties (Access = public)
        ToolGroup matlab.ui.container.ButtonGroup
        Buttons   (1, :) cell
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

            toolBar.renderButton(window, 0, 'R');
            toolBar.renderButton(window, 1, 'C');
            toolBar.renderButton(window, 2, 'L');
            toolBar.renderButton(window, 3, 'gnd');
            toolBar.renderButton(window, 4, 'brk');
            toolBar.renderButton(window, 5, 'U');
            toolBar.renderButton(window, 6, 'I');
            toolBar.renderButton(window, 7, '-+-');
            toolBar.renderButton(window, 8, '');
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
                Position = [x, y, width, height] ...
            );
        end

        % todo use icons instead of text
        % todo use resource manager
        function renderButton(toolBar, parent, offset, text)
            arguments
                toolBar UI.ToolBar
                parent  matlab.ui.Figure
                offset  int32
                text    string
            end

            x = toolBar.Padding + (toolBar.ButtonGap + toolBar.ButtonSize) * offset;
            y = toolBar.Padding;

            button = uitogglebutton(toolBar.ToolGroup, ...
                Text     = text, ...
                Position = [x, y, toolBar.ButtonSize, toolBar.ButtonSize] ...
            );

            toolBar.Buttons{end + 1} = button;
        end
    end
end