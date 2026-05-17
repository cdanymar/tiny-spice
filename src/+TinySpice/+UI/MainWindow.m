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
            mainWindow.Window = uifigure(       ...
                Name        = 'tinySPICE',      ...
                Resize      = false,            ...
                Position    = [                 ...
                    mainWindow.WindowX,         ...
                    mainWindow.WindowY,         ...
                    mainWindow.WindowWidth,     ...
                    mainWindow.WindowHeight     ...
                ]                               ...
            );
        end

        function createMenubar(mainWindow)
            mainWindow.MenuBar = TinySpice.UI.MenuBar(mainWindow.Window);
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
    end
end