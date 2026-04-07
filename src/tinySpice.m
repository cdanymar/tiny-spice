clc;
clearvars;
close all;

addpath('Devices\');
addpath('Engine\');

%%
circuit = Circuit();

circuit.insert(VoltageSource('U1', 1, 0, 30 * exp(1i * deg2rad(30))));
circuit.insert(     Resistor('R1', 1, 2, 220000));
circuit.insert(     Inductor('R1', 2, 0, 100));

states = circuit.solveMNA(CircuitContext(Frequency=50));
disp(states);
