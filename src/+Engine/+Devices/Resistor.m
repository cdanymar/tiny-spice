classdef (Sealed) Resistor < Engine.Devices.Device
    properties (Access = public)
        Resistance (1, 1) double {mustBePositive, mustBeFinite} = 1
    end

    methods (Access = public)
        function resistor = Resistor(name, entryNode, exitNode, options)
            arguments
                name      (1, 1) string
                entryNode (1, 1) int32 {mustBeInteger,  mustBeNonnegative}
                exitNode  (1, 1) int32 {mustBeInteger,  mustBeNonnegative}

                options.Resistance (1, 1) double {mustBePositive, mustBeFinite}
            end

            resistor@Engine.Devices.Device(name, entryNode, exitNode);
            resistor.Resistance = options.Resistance;
        end
    end

    methods (Access = {?Engine.Devices.Device, ?Engine.Circuit})
        function applyStamp(resistor, simulation, circuit)
            arguments
                resistor   (1, 1) Engine.Devices.Resistor
                simulation (1, 1) Engine.SimulationContext
                circuit    (1, 1) Engine.CircuitContext
            end

            g = 1 / resistor.Resistance;

            in  = resistor.EntryNode;
            out = resistor.ExitNode;

            if (in ~= 0)
                simulation.LHS(in, in) = simulation.LHS(in, in) + g;
            end

            if (out ~= 0)
                simulation.LHS(out, out) = simulation.LHS(out, out) + g;
            end

            if (in ~= 0) && (out ~= 0)
                simulation.LHS(in, out) = simulation.LHS(in, out) - g;
                simulation.LHS(out, in) = simulation.LHS(out, in) - g;
            end
        end

        function [U, I, Z] = getStates(resistor, result, circuit)
            arguments
                resistor (1, 1) Engine.Devices.Resistor
                result   (:, 1) double {mustBeNumeric, mustBeFinite}
                circuit  (1, 1) Engine.CircuitContext
            end

            values = [0; result];

            vIn  = values(resistor.EntryNode + 1);
            vOut = values(resistor.ExitNode + 1);

            U = vIn - vOut;
            I = U / resistor.Resistance;
            Z = resistor.Resistance;
        end
    end
end
