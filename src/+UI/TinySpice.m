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
            % app.renderCircuitCanvas();
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

            addlistener(app.MainMenuBar, 'FileExit',      @app.onExit);
            addlistener(app.MainMenuBar, 'WindowRefresh', @app.onRefresh);
            addlistener(app.MainMenuBar, 'HelpHelp',      @app.onHelp);
            addlistener(app.MainMenuBar, 'HelpAbout',     @app.onAbout);
        end

        function renderToolBar(app)
            arguments
                app UI.TinySpice
            end

            app.MainToolBar = UI.ToolBar(app.MainWindow);
            % todo callbacks
        end

        function renderCircuitCanvas(app)
            arguments
                app UI.TinySpice
            end

            app.MainCanvas = UI.CircuitCanvas(app.MainWindow);
            % todo callbacks
            % todo interaction
        end
    end

    methods (Access = {?UI.TinySpiceUI})
        function onExit(app, source, event)
            arguments
                app     UI.TinySpice
                source
                event   event.EventData
            end

            selection = uiconfirm(app.MainWindow, ...
                "Are you sure you want to exit tinySPICE?", ...
                "Exit tinySPICE", ...
                Icon          = "question", ...
                Options       = ["Yes", "No"], ...
                DefaultOption = 2, ...
                CancelOption  = 2 ...
            );

            if (selection == "Yes")
                delete(app.MainWindow);
            end

            % todo prompt to save
        end

        function onRefresh(app, source, event)
            arguments
                app     UI.TinySpice
                source
                event   event.EventData
            end

            drawnow;
        end

        function onHelp(app, source, event)
            arguments
                app     UI.TinySpice
                source
                event   event.EventData
            end
        end

        function onAbout(app, source, event)
            arguments
                app     UI.TinySpice
                source
                event   event.EventData
            end

            uialert(app.MainWindow, ...
                "tinySPICE is a simple ideal linear circuit simulator and solver.", ...
                "About tinySPICE" ...
            );
        end
    end
end
