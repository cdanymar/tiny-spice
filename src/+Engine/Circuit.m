classdef (Sealed) Circuit < handle
    properties (Access = public)
        Devices     (1, :) cell
        NodeCount   (1, 1) int32 {mustBePositive}    = 1
        BranchCount (1, 1) int32 {mustBeNonnegative} = 0
    end

    methods (Access = public)
        function circuit = Circuit()
        end

        function insert(circuit, device)
            arguments
                circuit (1, 1) Engine.Circuit
                device  (1, 1) Engine.Devices.Device
            end

            circuit.Devices{end + 1} = device;
            circuit.NodeCount = max([circuit.NodeCount, device.EntryNode, device.ExitNode]);

            if isa(device, 'Engine.Devices.VoltageDefinedDevice')
                circuit.BranchCount = circuit.BranchCount + 1;
            end
        end

        function remove(circuit, deviceName)
            arguments
                circuit    (1, 1) Engine.Circuit
                deviceName (1, 1) string
            end

            % todo implement
        end

        % todo use sparse
        function states = solveMNA(circuit, context)
                             % ^^^ Modified Nodal Analysis

            arguments
                circuit (1, 1) Engine.Circuit
                context (1, 1) Engine.CircuitContext
            end

            equation = Engine.SimulationContext(circuit.NodeCount + circuit.BranchCount);

            m = 0;
            for i = 1:length(circuit.Devices)
                device = circuit.Devices{i};

                if isa(device, 'Engine.Devices.VoltageDefinedDevice')
                    m = m + 1;
                    device.DeviceBranch = circuit.NodeCount + m;
                end

                device.applyStamp(equation, context);
            end

            states = calculateStates(circuit, equation.LHS \ equation.RHS, context);
        end
    end

    methods (Access = private)
        function states = calculateStates(circuit, result, context)
            arguments
                circuit (1, 1) Engine.Circuit
                result  (:, 1) double {mustBeNumeric, mustBeFinite}
                context (1, 1) Engine.CircuitContext
            end

            states = {};

            % todo: benchmark with repmat/table
            for k = 1:length(circuit.Devices)
                device = circuit.Devices{k};

                [U, I, Z] = device.getStates(result, context);
                states = [states; {device.Name, U, I, Z}];
            end
        end
    end
end