classdef (Abstract) Device < handle
                           % ^^^^^^ Matlab's retarded way to pass by reference

    properties (Access = public)
        Name      (1, 1) string
        EntryNode (1, 1) int32 {mustBeInteger, mustBeNonnegative}
        ExitNode  (1, 1) int32 {mustBeInteger, mustBeNonnegative}
    end

    methods (Access = public)
        function device = Device(name, entryNode, exitNode)
            arguments
                name      (1, 1) string
                entryNode (1, 1) int32 {mustBeInteger, mustBeNonnegative}
                exitNode  (1, 1) int32 {mustBeInteger, mustBeNonnegative}
            end

            device.Name      = name;
            device.EntryNode = entryNode;
            device.ExitNode  = exitNode;
        end
    end

    methods (Abstract, Access = {?Device, ?Circuit})
        [matA, matZ] = applyStamp(device, matA, matZ);
        [U, I, Z]    = getStates(device, result);
    end
end
