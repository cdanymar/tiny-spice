classdef (Sealed) Circuit < handle
    properties (Access = public)
        Devices   (1, :) cell
        NodeCount (1, 1) int32
    end

    methods (Access = public)
        function circuit = Circuit()
        end

        function insert(circuit, device)
            arguments
                circuit (1, 1) Circuit
                device  (1, 1) Device
            end

            circuit.Devices{end + 1} = device;
            circuit.NodeCount = max([circuit.NodeCount, device.EntryNode, device.ExitNode]);
        end

        function remove(circuit, deviceName)
            arguments
                circuit    (1, 1) Circuit
                deviceName (1, 1) string
            end

            % todo implement
        end

        function states = solveMNA(circuit)
                             % ^^^ Modified Nodal Analysis

            arguments
                circuit (1, 1) Circuit
            end

            n = circuit.NodeCount;
            m = 0;

            matA = zeros(n);
            matZ = zeros(n, 1);

            for i = 1:length(circuit.Devices)
                device = circuit.Devices{i};

                if isa(device, 'VoltageDefinedDevice')
                    m = m + 1;
                    device.DeviceIndex = n + m;
                end

                [matA, matZ] = device.applyStamp(matA, matZ);
            end

            states = calculateStates(circuit, matA \ matZ);
        end
    end

    methods (Access = private)
        function states = calculateStates(circuit, result)
            arguments
                circuit (1, 1) Circuit
                result  (:, 1) double {mustBeNumeric, mustBeFinite}
            end

            states = {};

            % todo: optmize, preallocate
            for k = 1:length(circuit.Devices)
                device = circuit.Devices{k};

                [U, I, Z] = device.getStates(result);
                states = [states; {device.Name, U, I, Z}];
            end
        end
    end
end