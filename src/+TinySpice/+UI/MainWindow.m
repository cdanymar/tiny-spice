classdef (Sealed) MainWindow < handle
    properties (Constant, Access = private)
        WindowX         = 100;
        WindowY         = 100;
        WindowWidth     = 900;
        WindowHeight    = 600;
    end


    properties (Access = public)
        Window;
        MenuBar;
        ToolBar;
        StatusBar;
        Canvas;
    end


    methods (Access = public)
        function mainWindow = MainWindow()
            mainWindow.createWindow();
            mainWindow.createMenubar();
            mainWindow.createStatusBar();
            mainWindow.createToolbar();
            mainWindow.createCanvas();
        end
    end


    methods (Access = private)
        function createWindow(mainWindow)
            mainWindow.Window = uifigure(   ...
                Name     = 'tinySPICE',     ...
                Resize   = false,           ...
                Position = [                ...
                    mainWindow.WindowX,     ...
                    mainWindow.WindowY,     ...
                    mainWindow.WindowWidth, ...
                    mainWindow.WindowHeight ...
                ]                           ...
            );
        end

        function createMenubar(mainWindow)
            callbacks.new  = @(~,~) mainWindow.onFileNew();
            callbacks.open = @(~,~) mainWindow.onFileOpen();
            callbacks.save = @(~,~) mainWindow.onFileSave();
            callbacks.run  = @(~,~) mainWindow.onRunAC();

            mainWindow.MenuBar = TinySpice.UI.MenuBar(mainWindow.Window, callbacks);
        end

        function createToolbar(mainWindow)
            mainWindow.ToolBar = TinySpice.UI.ToolBar(mainWindow.Window, mainWindow.StatusBar);
        end

        function createStatusBar(mainWindow)
            mainWindow.StatusBar = TinySpice.UI.StatusBar(mainWindow.Window);
        end

        function createCanvas(mainWindow)
            mainWindow.Canvas = TinySpice.UI.Canvas(...
                mainWindow.Window,                  ...
                mainWindow.ToolBar,                 ...
                mainWindow.StatusBar                ...
            );
        end


        function onRunDC(mainWindow, source, event)
            try
                res = TinySpice.Circuit.CircuitSolver.solve(mainWindow.Canvas.getItems(), eps);
                TinySpice.UI.ResultsWindow(res);
            catch err
                uialert(mainWindow.Window, err.message, 'Simulation Error');
            end
        end

        function onRunAC(mainWindow, ~, ~)
            dialog = TinySpice.UI.FrequencyDialog();
            freq   = dialog.getFrequency();

            try
                if isempty(freq);
                    error("For AC analysis frequency must a positve real number.");
                end

                res = TinySpice.Circuit.CircuitSolver.solve(mainWindow.Canvas.getItems(), freq);
                TinySpice.UI.ResultsWindow(res);
            catch err
                uialert(mainWindow.Window, err.message, 'Simulation Error');
            end
        end

        function onFileNew(mainWindow)
            mainWindow.Canvas.clearCanvas();
        end

        function onFileOpen(mainWindow)
            [file, path] = uigetfile('*.json', 'Open Circuit');
            if isequal(file, 0); return; end

            try
                raw  = fileread(fullfile(path, file));
                data = TinySpice.IO.Serializer.deserialize(raw);
                mainWindow.Canvas.loadCircuit(data);
            catch err
                uialert(mainWindow.Window, err.message, 'Load Error');
            end
        end

        function onFileSave(mainWindow)
            [file, path] = uiputfile('*.json', 'Save Circuit');
            if isequal(file, 0); return; end

            mainWindow.saveToFile(fullfile(path, file));
        end

        function onFileSaveAs(mainWindow)
            mainWindow.onFileSave();
        end

        function saveToFile(mainWindow, filepath)
            try
                json = TinySpice.IO.Serializer.serialize(mainWindow.Canvas.getItems());
                fid  = fopen(filepath, 'w');
                fprintf(fid, '%s', json);
                fclose(fid);
            catch err
                uialert(mainWindow.Window, err.message, 'Save Error');
            end
        end
    end
end