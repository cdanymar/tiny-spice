classdef (Sealed) TinySpice < UI.TinySpiceUI
    properties (Access = public)
        MainWindow  matlab.ui.Figure
        MainMenuBar UI.MenuBar
        MainToolBar UI.ToolBar
        MainCanvas  UI.CircuitCanvas

        % strong sizing breaks ctor
        % I don't give enough fucks to investigate
    end

    methods (Access = public)
        function app = TinySpice()
            app.renderWindow();
            app.renderMenuBar();
            app.renderToolBar();
            app.renderCircuitCanvas();
        end
    end

    methods (Access = private)
        function renderWindow(app)
            arguments
                app UI.TinySpice
            end

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
        end

        function renderMenuBar(app)
            arguments
                app UI.TinySpice
            end

            app.MainMenuBar = UI.MenuBar(app.MainWindow);

            % todo assign callbacks
            % R2017b: Callback property is not recommended
            % Starting in R2017b, using the Callback property to assign a menu selected
            % callback is not recommended. Use the MenuSelectedFcn property instead. The
            % property values are the same.
        end

        function renderToolBar(app)
            arguments
                app UI.TinySpice
            end

            app.MainToolBar = UI.ToolBar(app.MainWindow);

            p = uipanel(app.MainWindow);
        end

        function renderCircuitCanvas(app)
            arguments
                app UI.TinySpice
            end

            app.MainCanvas = UI.CircuitCanvas(app.MainWindow);
        end
    end
end
