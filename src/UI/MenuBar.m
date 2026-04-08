classdef (Sealed) MenuBar < TinySpiceUI
    properties (Access = public)
        FileMenu   matlab.ui.container.Menu
        EditMenu   matlab.ui.container.Menu
        ViewMenu   matlab.ui.container.Menu
        RunMenu    matlab.ui.container.Menu
        WindowMenu matlab.ui.container.Menu
        HelpMenu   matlab.ui.container.Menu
    end

    methods (Access = public)
        function menuBar = MenuBar(window)
            arguments
                window matlab.ui.Figure
            end

            menuBar.renderFileMenu(window);
            menuBar.renderEditMenu(window);
            menuBar.renderViewMenu(window);
            menuBar.renderRunMenu(window);
            menuBar.renderWindowMenu(window);
            menuBar.renderHelpMenu(window);
        end
    end

    methods (Access = private)
        function renderFileMenu(menuBar, parent)
            arguments
                menuBar MenuBar
                parent  matlab.ui.Figure
            end

            menuBar.FileMenu = uimenu(parent, Text = '&File');

            uimenu(menuBar.FileMenu, Text = '&New',  Accelerator = 'N');
            uimenu(menuBar.FileMenu, Text = '&Open', Accelerator = 'O');
            uimenu(menuBar.FileMenu, Text = '&Save', Accelerator = 'S');
            uimenu(menuBar.FileMenu, Text = 'Save &As');

            uimenu(menuBar.FileMenu, Text = 'E&xit', Separator = true);
        end

        function renderEditMenu(menuBar, parent)
            arguments
                menuBar MenuBar
                parent  matlab.ui.Figure
            end

            menuBar.EditMenu = uimenu(parent, Text = '&Edit');

            uimenu(menuBar.EditMenu, Text = 'Undo', Accelerator = 'Z');
            uimenu(menuBar.EditMenu, Text = 'Redo', Accelerator = 'Y');

            uimenu(menuBar.EditMenu, Text = 'Cut',   Accelerator = 'X', Separator = true);
            uimenu(menuBar.EditMenu, Text = 'Copy',  Accelerator = 'C');
            uimenu(menuBar.EditMenu, Text = 'Paste', Accelerator = 'V');
            uimenu(menuBar.EditMenu, Text = 'Delete');

            insertMenu = uimenu(menuBar.EditMenu, Text = 'Insert', Separator = true);

            uimenu(insertMenu, Text = '&Resistor');
            uimenu(insertMenu, Text = '&Capacitor');
            uimenu(insertMenu, Text = '&Inductor');
            uimenu(insertMenu, Text = '&Ground');
            uimenu(insertMenu, Text = '&Breaker');

            uimenu(insertMenu, Text = '&Voltage Source', Separator = true);
            uimenu(insertMenu, Text = 'Cu&rrent Source');

            uimenu(insertMenu, Text = 'Wire', Separator = true);
        end

        function renderViewMenu(menuBar, parent)
            arguments
                menuBar MenuBar
                parent  matlab.ui.Figure
            end

            menuBar.ViewMenu = uimenu(parent, Text = '&View');

            uimenu(menuBar.ViewMenu, Text = '&Grid',           Checked = true);
            uimenu(menuBar.ViewMenu, Text = '&European Icons', Checked = true);
        end

        function renderRunMenu(menuBar, parent)
            arguments
                menuBar MenuBar
                parent  matlab.ui.Figure
            end

            menuBar.RunMenu = uimenu(parent, Text = '&Run');

            uimenu(menuBar.RunMenu, Text = 'Run &DC');
            uimenu(menuBar.RunMenu, Text = 'Run &AC');

            uimenu(menuBar.RunMenu, Text = 'Check connections', Separator = true);
        end

        function renderWindowMenu(menuBar, parent)
            arguments
                menuBar MenuBar
                parent  matlab.ui.Figure
            end

            menuBar.WindowMenu = uimenu(parent, Text = '&Window');

            uimenu(menuBar.WindowMenu, Text = 'Refresh');
        end

        function renderHelpMenu(menuBar, parent)
            arguments
                menuBar MenuBar
                parent  matlab.ui.Figure
            end

            menuBar.HelpMenu = uimenu(parent, Text = '&Help');

            uimenu(menuBar.HelpMenu, Text = '&Help');
            uimenu(menuBar.HelpMenu, Text = 'Check for &updates...');
            uimenu(menuBar.HelpMenu, Text = '&About');
        end
    end
end
