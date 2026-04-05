clc;
clearvars;
close all;

%% paths
addpath('Devices\');
addpath('Engine\');

%% sample code
circuit = Circuit();

% grounded votlage source
U1 = VoltageSource('U1', 1, 0, 9);

% series resistors
R1 = Resistor('R1', 1, 2, 220);
R2 = Resistor('R2', 2, 0, 330);

% parallel resistor
R3 = Resistor('R3', 2, 0, 100);

circuit.insert(U1);
circuit.insert(R1);
circuit.insert(R2);
circuit.insert(R3);

solution = circuit.runMNA()
