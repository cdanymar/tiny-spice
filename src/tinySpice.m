clc;
clearvars;
close all;

addpath('Devices\');
addpath('Engine\');

circuit = Circuit();

circuit.insert(VoltageSource('U1', 1, 0,   9));
circuit.insert(     Resistor('R1', 1, 2, 220));
circuit.insert(     Resistor('R2', 2, 0, 100));

states = circuit.solveMNA();
prettyPrint(states);
