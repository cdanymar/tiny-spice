classdef (Sealed) VoltageSource < VoltageDefinedDevice
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

            voltageSource@VoltageDefinedDevice(name, entryNode, exitNode);
            voltageSource.Voltage = voltage;
        end
    end

    methods (Access = {?Device, ?Circuit})
        function [matA, matZ] = applyStamp(device, matA, matZ)
            arguments
                device (1, 1) VoltageSource
                matA   (:, :) double {mustBeNumeric, mustBeFinite}
                matZ   (:, :) double {mustBeNumeric, mustBeFinite}
            end

            in  = device.EntryNode;
            out = device.ExitNode;
            k   = size(matA, 1) + 1;

            matA(k, k) = 0;
            matZ(k, 1) = device.Voltage;

            if (in ~= 0)
                matA(in, k) = matA(in, k) + 1;
                matA(k, in) = matA(k, in) + 1;
            end

            if (out ~= 0)
                matA(out, k) = matA(out, k) - 1;
                matA(k, out) = matA(k, out) - 1;
            end
        end

        function [U, I, Z] = getStates(voltageSource, result)
            arguments
                voltageSource (1, 1) VoltageSource
                result        (:, 1) double {mustBeNumeric, mustBeFinite}
            end

            values = [0; result];

            vIn  = values(voltageSource.EntryNode + 1);
            vOut = values(voltageSource.ExitNode + 1);

            U = vIn - vOut;
            I = -result(voltageSource.DeviceIndex);
            Z = 0;
        end
    end
end
