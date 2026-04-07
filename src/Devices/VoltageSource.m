classdef (Sealed) VoltageSource < VoltageDefinedDevice
    properties (Access = public)
        Voltage (1, 1) double {mustBeNumeric, mustBeFinite} = 1
    end

    methods (Access = public)
        function voltageSource = VoltageSource(name, entryNode, exitNode, voltage)
            arguments
                name      (1, 1) string
                entryNode (1, 1) int32  {mustBeInteger,  mustBeNonnegative}
                exitNode  (1, 1) int32  {mustBeInteger,  mustBeNonnegative}
                voltage   (1, 1) double {mustBeNumeric, mustBeFinite}
            end

            voltageSource@VoltageDefinedDevice(name, entryNode, exitNode);
            voltageSource.Voltage = voltage;
        end
    end

    methods (Access = {?Device, ?Circuit})
        function applyStamp(voltageSource, simulation, circuit)
            arguments
                voltageSource (1, 1) VoltageSource
                simulation    (1, 1) SimulationContext
                circuit       (1, 1) CircuitContext
            end

            in  = voltageSource.EntryNode;
            out = voltageSource.ExitNode;
            k   = voltageSource.DeviceBranch;

            simulation.LHS(k, k) = 0;
            simulation.RHS(k, 1) = voltageSource.Voltage;

            if (in ~= 0)
                simulation.LHS(in, k) = simulation.LHS(in, k) + 1;
                simulation.LHS(k, in) = simulation.LHS(k, in) + 1;
            end

            if (out ~= 0)
                simulation.LHS(out, k) = simulation.LHS(out, k) - 1;
                simulation.LHS(k, out) = simulation.LHS(k, out) - 1;
            end
        end

        function [U, I, Z] = getStates(voltageSource, result, circuit)
            arguments
                voltageSource (1, 1) VoltageSource
                result        (:, 1) double {mustBeNumeric, mustBeFinite}
                circuit       (1, 1) CircuitContext
            end

            values = [0; result];

            vIn  = values(voltageSource.EntryNode + 1);
            vOut = values(voltageSource.ExitNode + 1);

            U = vIn - vOut;
            I = -result(voltageSource.DeviceBranch);
            Z = 0;
        end
    end
end
