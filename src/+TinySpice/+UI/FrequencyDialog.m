classdef (Sealed) FrequencyDialog < handle
    properties (Constant, Access = private)
        Width  = 240;
        Height = 120;
    end

    properties (Access = private)
        Window;
        FreqField;
        Confirmed = false;
        Frequency = 0;
    end

    methods (Access = public)
        function dialog = FrequencyDialog()
            dialog.createWindow();
            dialog.createFields();
            dialog.createButtons();
            uiwait(dialog.Window);
        end

        function freq = getFrequency(dialog)
            if dialog.Confirmed
                freq = dialog.Frequency;
            else
                freq = [];
            end
        end
    end

    methods (Access = private)
        function createWindow(dialog)
            dialog.Window = uifigure(                                       ...
                Name        = 'AC Analysis',                                ...
                Position    = [500, 400, dialog.Width, dialog.Height],      ...
                Resize      = false,                                        ...
                WindowStyle = 'modal'                                       ...
            );
        end

        function createFields(dialog)
            uilabel(dialog.Window,              ...
                Text     = 'Frequency (Hz)',    ...
                Position = [16, 70, 100, 22]    ...
            );
            dialog.FreqField = uieditfield(dialog.Window, 'numeric',    ...
                Value    = 50  ,                                        ...
                Limits   = [0, Inf],                                    ...
                Position = [124, 70, 100, 22]                           ...
            );
        end

        function createButtons(dialog)
            uibutton(dialog.Window,                         ...
                Text            = 'Cancel',                 ...
                Position        = [24, 24, 80, 28],         ...
                ButtonPushedFcn = @(~,~) dialog.onCancel()  ...
            );
            uibutton(dialog.Window,                         ...
                Text            = 'Run',                    ...
                Position        = [136, 24, 80, 28],        ...
                ButtonPushedFcn = @(~,~) dialog.onConfirm() ...
            );
        end

        function onConfirm(dialog)
            dialog.Frequency  = dialog.FreqField.Value;
            dialog.Confirmed = true;
            uiresume(dialog.Window);
            delete(dialog.Window);
        end

        function onCancel(dialog)
            uiresume(dialog.Window);
            delete(dialog.Window);
        end
    end
end