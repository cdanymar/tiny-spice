classdef (Sealed) TinySpice < TinySpiceUI
    properties
        MainWindow  matlab.ui.Figure
        MainMenuBar MenuBar

        % strong sizing breaks ctor
        % I don't give enough fucks to investivate
    end

    methods (Access = public)
        function app = TinySpice()
            app.MainWindow = uifigure(...
                'Name',        'tinySPICE', ...
                'Position',    [200, 200, 400, 300], ...
                'NumberTitle', 'off' ...
            );

            app.MainMenuBar = MenuBar(app.MainWindow);
            % todo assign callbacks
            % R2017b: Callback property is not recommended
            % Starting in R2017b, using the Callback property to assign a menu selected
            % callback is not recommended. Use the MenuSelectedFcn property instead. The
            % property values are the same.
        end
    end
end
