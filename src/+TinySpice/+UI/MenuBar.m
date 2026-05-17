classdef (Sealed) MenuBar < handle
    properties (Access = private)
    end


    properties (Access = public)
    end


    methods (Access = public)
        function menuBar = MenuBar(parentWindow)
            menuBar.createFileMenu(parentWindow);
            menuBar.createEditMenu(parentWindow);
            menuBar.createRunMenu(parentWindow);
            menuBar.createHelpMenu(parentWindow);
        end
    end


    methods (Access = private)
        function createFileMenu(menuBar, parent)
            fileMenu = uimenu(parent, Text = '&File');

            uimenu(fileMenu, Text = '&New',  Accelerator = 'N');
            uimenu(fileMenu, Text = '&Open', Accelerator = 'O');
            uimenu(fileMenu, Text = '&Save', Accelerator = 'S');
            uimenu(fileMenu, Text = 'Save &As');

            uimenu(fileMenu, Text = '&Exit', Separator = true);
        end

        function createEditMenu(menuBar, parent)
            runMenu = uimenu(parent, Text = '&Edit');

            uimenu(runMenu, Text = '&Undo');
            uimenu(runMenu, Text = '&Redo', Enable = false);
        end

        function createRunMenu(menuBar, parent)
            runMenu = uimenu(parent, Text = '&Run');

            uimenu(runMenu, Text = '&DC');
            uimenu(runMenu, Text = '&AC (HSS)');
        end

        function createHelpMenu(menuBar, parent)
            helpMenu = uimenu(parent, Text = '&Help');

            uimenu(helpMenu, Text = 'About');
        end
    end
end