function app = runApp()
    app = UI.TinySpice();
    waitfor(app.MainWindow);
    exit;
end
