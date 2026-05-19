classdef (Sealed) StatusBar < handle
    properties (Constant, Access = private)
        Height          = 22;
        ColorBackground = [0.18 0.18 0.18];
        ColorText       = [0.70 0.70 0.70];
    end

    properties (Access = private)
        Panel;
        ToolLabel;
        RotationLabel;
    end

    methods (Access = public)
        function sb = StatusBar(window)
            sb.createPanel(window);
        end

        function setTool(sb, tool)
            sb.ToolLabel.Text = sprintf('Tool: %s', tool.Label);
        end

        function setRotation(sb, angle)
            sb.RotationLabel.Text = sprintf('Rotation: %d°', angle);
        end
    end

    methods (Access = private)
        function createPanel(sb, parent)
            width = parent.Position(3);

            sb.Panel = uipanel(parent,                          ...
                Position        = [0, 0, width, sb.Height],     ...
                BorderType      = 'none',                       ...
                BackgroundColor = sb.ColorBackground            ...
            );

            sb.ToolLabel = uilabel(sb.Panel,                    ...
                Text     = 'Tool: None',                        ...
                Position = [8, 0, 160, sb.Height],              ...
                FontColor = sb.ColorText,                       ...
                FontSize  = 11                                  ...
            );

            sb.RotationLabel = uilabel(sb.Panel,                ...
                Text     = 'Rotation: 0°',                      ...
                Position = [176, 0, 120, sb.Height],            ...
                FontColor = sb.ColorText,                       ...
                FontSize  = 11                                  ...
            );
        end
    end
end