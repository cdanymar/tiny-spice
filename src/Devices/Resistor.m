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
            conductance = 1 / device.Resistance;

            in  = device.EntryNode;
            out = device.ExitNode;

            if (in ~= 0)
                matA(in, in) = matA(in, in) + conductance;
            end

            if (out ~= 0)
                matA(out, out) = matA(out, out) + conductance;
            end

            if (in ~= 0) && (out ~= 0)
                matA(in, out) = matA(in, out) - conductance;
                matA(out, in) = matA(out, in) - conductance;
            end
        end
    end
end
