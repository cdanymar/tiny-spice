classdef (Sealed) TinySpice < UI.TinySpiceUI
    properties
        MainWindow  matlab.ui.Figure
        MainMenuBar UI.MenuBar
        MainCanvas  UI.CircuitCanvas

        % strong sizing breaks ctor
        % I don't give enough fucks to investigate
    end

    methods (Access = public)
        function app = TinySpice()
            x = 300;
            y = 300;

            width  = 800;
            height = 600;

            app.MainWindow = uifigure(...
                Name        = 'tinySPICE', ...
                Position    = [x, y, width, height], ...
                NumberTitle = false, ...
                Resize      = false ...
            );

            app.MainMenuBar = UI.MenuBar(app.MainWindow);
            % todo assign callbacks
            % R2017b: Callback property is not recommended
            % Starting in R2017b, using the Callback property to assign a menu selected
            % callback is not recommended. Use the MenuSelectedFcn property instead. The
            % property values are the same.
        end
    end
end
