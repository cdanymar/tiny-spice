classdef (Sealed) Inductor < VoltageDefinedDevice
    properties (Access = public)
        Inductance (1, 1) double {mustBePositive, mustBeFinite} = 1
    end

    methods (Access = public)
        function inductor = Inductor(name, entryNode, exitNode, inductance)
            arguments
                name       (1, 1) string
                entryNode  (1, 1) int32  {mustBeInteger,  mustBeNonnegative}
                exitNode   (1, 1) int32  {mustBeInteger,  mustBeNonnegative}
                inductance (1, 1) double {mustBePositive, mustBeFinite}
            end

            inductor@VoltageDefinedDevice(name, entryNode, exitNode);
            inductor.Inductance = inductance;
        end
    end

    methods (Access = {?Device, ?Circuit})
        function applyStamp(inductor, simulation, circuit)
            arguments
                inductor   (1, 1) Inductor
                simulation (1, 1) SimulationContext
                circuit    (1, 1) CircuitContext
            end

            in  = inductor.EntryNode;
            out = inductor.ExitNode;
            k   = inductor.DeviceBranch;

            simulation.LHS(k, k) = -2i * pi * circuit.Frequency * inductor.Inductance;
            simulation.RHS(k, 1) = 0;

            if (in ~= 0)
                simulation.LHS(in, k) = simulation.LHS(in, k) + 1;
                simulation.LHS(k, in) = simulation.LHS(k, in) + 1;
            end

            if (out ~= 0)
                simulation.LHS(out, k) = simulation.LHS(out, k) - 1;
                simulation.LHS(k, out) = simulation.LHS(k, out) - 1;
            end
        end

        function [U, I, Z] = getStates(inductor, result, circuit)
            arguments
                inductor (1, 1) Inductor
                result   (:, 1) double {mustBeNumeric, mustBeFinite}
                circuit  (1, 1) CircuitContext
            end

            values = [0; result];

            vIn  = values(inductor.EntryNode + 1);
            vOut = values(inductor.ExitNode + 1);

            U = vIn - vOut;
            I = result(inductor.DeviceBranch);
            Z = 2i * pi * circuit.Frequency * inductor.Inductance;
        end
    end
end
