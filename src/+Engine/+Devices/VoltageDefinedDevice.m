classdef (Abstract) VoltageDefinedDevice < Engine.Devices.Device
    properties (Access = public)
        DeviceBranch (1, 1) int32 {mustBeInteger, mustBeNonnegative} = 0
    end

    methods (Access = public)
        function device = VoltageDefinedDevice(name, entryNode, exitNode)
            arguments
                name      (1, 1) string
                entryNode (1, 1) int32 {mustBeInteger, mustBeNonnegative}
                exitNode  (1, 1) int32 {mustBeInteger, mustBeNonnegative}
            end

            device@Engine.Devices.Device(name, entryNode, exitNode);
        end
    end
end
