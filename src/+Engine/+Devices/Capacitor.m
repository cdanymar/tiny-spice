classdef (Sealed) Capacitor < Engine.Devices.Device
    properties (Access = public)
        Capacitance (1, 1) double {mustBePositive, mustBeFinite} = 1
    end

    methods (Access = public)
        function capacitor = Capacitor(name, entryNode, exitNode, options)
            arguments
                name      (1, 1) string
                entryNode (1, 1) int32 {mustBeInteger, mustBeNonnegative}
                exitNode  (1, 1) int32 {mustBeInteger, mustBeNonnegative}

                options.Capacitance (1, 1) double {mustBePositive, mustBeFinite}
            end

            capacitor@Engine.Devices.Device(name, entryNode, exitNode);
            capacitor.Capacitance = options.Capacitance;
        end
    end

    methods (Access = {?Engine.Devices.Device, ?Engine.Circuit})
        function applyStamp(capacitor, simulation, circuit)
            arguments
                capacitor  (1, 1) Engine.Devices.Capacitor
                simulation (1, 1) Engine.SimulationContext
                circuit    (1, 1) Engine.CircuitContext
            end

            Y = 2i * pi * circuit.Frequency * capacitor.Capacitance;

            in  = capacitor.EntryNode;
            out = capacitor.ExitNode;

            if (in ~= 0)
                simulation.LHS(in, in) = simulation.LHS(in, in) + Y;
            end

            if (out ~= 0)
                simulation.LHS(out, out) = simulation.LHS(out, out) + Y;
            end

            if (in ~= 0) && (out ~= 0)
                simulation.LHS(in, out) = simulation.LHS(in, out) - Y;
                simulation.LHS(out, in) = simulation.LHS(out, in) - Y;
            end
        end

        function [U, I, Z] = getStates(capacitor, result, circuit)
            arguments
                capacitor (1, 1) Engine.Devices.Capacitor
                result    (:, 1) double {mustBeNumeric, mustBeFinite}
                circuit   (1, 1) Engine.CircuitContext
            end

            values = [0; result];

            vIn  = values(capacitor.EntryNode + 1);
            vOut = values(capacitor.ExitNode + 1);

            Y = 2i * pi * circuit.Frequency * capacitor.Capacitance;

            U = vIn - vOut;
            I = U * Y;

            % explicitly assign infinity to avoid warnings
            if (Y == 0)
                Z = inf;
            else
                Z = 1 / Y;
            end
        end
    end
end
