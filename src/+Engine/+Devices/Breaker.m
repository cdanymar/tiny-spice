classdef (Sealed) Breaker < Engine.Devices.VoltageDefinedDevice
    properties (Access = public)
        IsClosed (1, 1) logical
    end

    methods (Access = public)
        function breaker = Breaker(name, entryNode, exitNode, options)
            arguments
                name      (1, 1) string
                entryNode (1, 1) int32 {mustBeInteger,  mustBeNonnegative}
                exitNode  (1, 1) int32 {mustBeInteger,  mustBeNonnegative}

                options.IsClosed (1, 1) logical
            end

            breaker@Engine.Devices.VoltageDefinedDevice(name, entryNode, exitNode);
            breaker.IsClosed = options.IsClosed;
        end
    end

    methods (Access = {?Engine.Devices.Device, ?Engine.Circuit})
        function applyStamp(breaker, simulation, circuit)
            arguments
                breaker    (1, 1) Engine.Devices.Breaker
                simulation (1, 1) Engine.SimulationContext
                circuit    (1, 1) Engine.CircuitContext
            end

            in  = breaker.EntryNode;
            out = breaker.ExitNode;
            k   = breaker.DeviceBranch;

            simulation.LHS(k, k) = -2i * pi * circuit.Frequency * breaker.IsClosed;
            simulation.RHS(k, 1) = 0;

            if (breaker.IsClosed)
                simulation.RHS(k, 1) = 0;

                if (in ~= 0)
                    simulation.LHS(in, k) = simulation.LHS(in, k) + 1;
                    simulation.LHS(k, in) = simulation.LHS(k, in) + 1;
                end

                if (out ~= 0)
                    simulation.LHS(out, k) = simulation.LHS(out, k) - 1;
                    simulation.LHS(k, out) = simulation.LHS(k, out) - 1;
                end
            else
                simulation.LHS(k, k) = 1;
                simulation.RHS(k, 1) = 0;
            end
        end

        function [U, I, Z] = getStates(breaker, result, circuit)
            arguments
                breaker (1, 1) Engine.Devices.Breaker
                result  (:, 1) double {mustBeNumeric, mustBeFinite}
                circuit (1, 1) Engine.CircuitContext
            end

            values = [0; result];

            vIn  = values(breaker.EntryNode + 1);
            vOut = values(breaker.ExitNode + 1);

            U = vIn - vOut;
            I = result(breaker.DeviceBranch);

            if (breaker.IsClosed)
                Z = 0;
            else
                Z = Inf;
            end
        end
    end
end
