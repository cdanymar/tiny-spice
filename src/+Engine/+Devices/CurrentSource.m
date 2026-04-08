classdef (Sealed) CurrentSource < Engine.Devices.Device
    properties (Access = public)
        Current (1, 1) double {mustBeNumeric, mustBeFinite} = 1
    end

    methods (Access = public)
        function currentSource = CurrentSource(name, entryNode, exitNode, options)
            arguments
                name      (1, 1) string
                entryNode (1, 1) int32 {mustBeInteger,  mustBeNonnegative}
                exitNode  (1, 1) int32 {mustBeInteger,  mustBeNonnegative}

                options.Current (1, 1) double {mustBeReal, mustBeFinite}
                options.Phase   (1, 1) double {mustBeReal, mustBeFinite} = 0
            end

            currentSource@Engine.Devices.Device(name, entryNode, exitNode);
            currentSource.Current = options.Current * exp(1i * deg2rad(options.Phase));
        end
    end

    methods (Access = {?Engine.Devices.Device, ?Engine.Circuit})
        function applyStamp(currentSource, simulation, circuit)
            arguments
                currentSource (1, 1) Engine.Devices.CurrentSource
                simulation    (1, 1) Engine.SimulationContext
                circuit       (1, 1) Engine.CircuitContext
            end

            I = currentSource.Current;

            in  = currentSource.EntryNode;
            out = currentSource.ExitNode;

            if (in ~= 0)
                simulation.RHS(in, 1) = simulation.RHS(in, 1) - I;
            end

            if (out ~= 0)
                simulation.RHS(out, 1) = simulation.RHS(out, 1) + I;
            end
        end

        function [U, I, Z] = getStates(currentSource, result, circuit)
            arguments
                currentSource (1, 1) Engine.Devices.CurrentSource
                result        (:, 1) double {mustBeNumeric, mustBeFinite}
                circuit       (1, 1) Engine.CircuitContext
            end

            values = [0; result];

            vIn  = values(currentSource.EntryNode + 1);
            vOut = values(currentSource.ExitNode + 1);

            U = vIn - vOut;
            I = currentSource.Current;
            Z = inf;
        end
    end
end
