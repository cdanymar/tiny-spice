classdef (Sealed) VoltageSource < Device
    properties (Access = public)
        Voltage (1, 1) double {mustBePositive, mustBeFinite} = 1
    end

    methods (Access = public)
        function voltageSource = VoltageSource(name, entryNode, exitNode, voltage)
            arguments
                name      (1, 1) string
                entryNode (1, 1) int32  {mustBeInteger,  mustBeNonnegative}
                exitNode  (1, 1) int32  {mustBeInteger,  mustBeNonnegative}
                voltage   (1, 1) double {mustBePositive, mustBeFinite}
            end

            voltageSource@Device(name, entryNode, exitNode);
            voltageSource.Voltage = voltage;
        end
    end

    methods (Access = {?Device, ?Circuit})
        function [matA, matZ] = applyStamp(device, matA, matZ)
            in  = device.EntryNode;
            out = device.ExitNode;

            idx = size(matA, 1) + 1;

            matA(idx, idx) = 0;
            matZ(idx, 1)   = device.Voltage;

            if (in ~= 0)
                matA(in, idx) = matA(in, idx) + 1;
                matA(idx, in) = matA(idx, in) + 1;
            end

            if (out ~= 0)
                matA(out, idx) = matA(out, idx) - 1;
                matA(idx, out) = matA(idx, out) - 1;
            end
        end
    end
end
