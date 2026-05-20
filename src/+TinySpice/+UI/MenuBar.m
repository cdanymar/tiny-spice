classdef (Sealed) MenuBar < handle
    methods (Access = public)
        function menuBar = MenuBar(parentWindow, callbacks)
            menuBar.createFileMenu(parentWindow, callbacks);
            menuBar.createEditMenu(parentWindow, callbacks);
            menuBar.createRunMenu(parentWindow, callbacks);
            menuBar.createHelpMenu(parentWindow);
        end
    end


    methods (Access = private)
        function createFileMenu(menuBar, parent, callbacks)
            fileMenu = uimenu(parent, Text = '&File');

            uimenu(fileMenu, Text = '&New',  Accelerator = 'N', MenuSelectedFcn = callbacks.new);
            uimenu(fileMenu, Text = '&Open', Accelerator = 'O', MenuSelectedFcn = callbacks.open);
            uimenu(fileMenu, Text = '&Save', Accelerator = 'S', MenuSelectedFcn = callbacks.save);
            uimenu(fileMenu, Text = 'Save &As', Enable = false);

            uimenu(fileMenu, Text = '&Exit', Separator = true, MenuSelectedFcn = @(~, ~) delete(parent));
        end

        function createEditMenu(menuBar, parent, callbacks)
            runMenu = uimenu(parent, Text = '&Edit');

            uimenu(runMenu, Text = '&Undo', MenuSelectedFcn = callbacks.undo);
            uimenu(runMenu, Text = '&Redo', MenuSelectedFcn = callbacks.redo, Enable = false);
        end

        function createRunMenu(menuBar, parent, callbacks)
            runMenu = uimenu(parent, Text = '&Run');

            uimenu(runMenu, Text = '&DC Analysis', MenuSelectedFcn = callbacks.runDC);
            uimenu(runMenu, Text = '&AC (HSS) Analysis', MenuSelectedFcn = callbacks.runAC);
        end

        function createHelpMenu(menuBar, parent)
            helpMenu = uimenu(parent, Text = '&Help');

            uimenu(helpMenu, Text = '&About', MenuSelectedFcn = @(~, ~) msgbox('This is a minimal linear sinusoidal harmonic steady state analyzer for aletrnating currnet circuits. Treat it as a prototype and do not expect much.', 'About tinySPICE'));
        end
    end
end