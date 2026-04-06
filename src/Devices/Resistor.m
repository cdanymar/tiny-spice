classdef (Sealed) Resistor < Device
    properties (Access = public)
        Resistance (1, 1) double {mustBePositive, mustBeFinite} = 1
    end

    methods (Access = public)
        function resistor = Resistor(name, entryNode, exitNode, resistance)
            arguments
                name       (1, 1) string
                entryNode  (1, 1) int32  {mustBeInteger,  mustBeNonnegative}
                exitNode   (1, 1) int32  {mustBeInteger,  mustBeNonnegative}
                resistance (1, 1) double {mustBePositive, mustBeFinite}
            end

            resistor@Device(name, entryNode, exitNode);
            resistor.Resistance = resistance;
        end
    end

    methods (Access = {?Device, ?Circuit})
        function [matA, matZ] = applyStamp(device, matA, matZ)
            arguments
                device (1, 1) Resistor
                matA   (:, :) double {mustBeNumeric, mustBeFinite}
                matZ   (:, :) double {mustBeNumeric, mustBeFinite}
            end

            g = 1 / device.Resistance;

            in  = device.EntryNode;
            out = device.ExitNode;

            if (in ~= 0)
                matA(in, in) = matA(in, in) + g;
            end

            if (out ~= 0)
                matA(out, out) = matA(out, out) + g;
            end

            if (in ~= 0) && (out ~= 0)
                matA(in, out) = matA(in, out) - g;
                matA(out, in) = matA(out, in) - g;
            end
        end

        function [U, I, Z] = getStates(resistor, result)
            arguments
                resistor (1, 1) Resistor
                result   (:, 1) double {mustBeNumeric, mustBeFinite}
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
