clc;
clearvars;
close all;

addpath('Devices\');
addpath('Engine\');
addpath('UI\');

%%
app = TinySpice();
waitfor(app.MainWindow);
