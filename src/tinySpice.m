clc;
clearvars;
close all;

import Engine.*;
import Engine.Devices.*;

%%
circuit = Circuit();

circuit.insert(VoltageSource('V1', 1, 0,     Voltage = 10));
circuit.insert(CurrentSource('I1', 0, 2,     Current = 0.05, Phase = 45));
circuit.insert(     Resistor('R1', 1, 2,  Resistance = 1000));
circuit.insert(     Inductor('L1', 2, 3,  Inductance = 0.01));
circuit.insert(      Breaker('B1', 3, 4,    IsClosed = true));
circuit.insert(    Capacitor('C1', 4, 0, Capacitance = 1e-6));

states = circuit.solveMNA(CircuitContext(Frequency=50));

%%
if isstruct(states)
    stateTable = struct2table(states);
    disp(stateTable);
else
    disp(states);
end

%%
%app = TinySpice();
%waitfor(app.MainWindow);
