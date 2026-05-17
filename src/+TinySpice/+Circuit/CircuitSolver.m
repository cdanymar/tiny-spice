classdef CircuitSolver
    methods (Static)
        function [voltages, currents] = solve(items, freq)
            CB = TinySpice.Circuit.CircuitBuilder;

            fprintf("pre BUILD\n");
            [nodeMap, nodeCount] = CB.build(items);
            fprintf("post BUILD\n");

            devices = {};
            for i = 1:numel(items)
                if isa(items{i}, 'TinySpice.UI.GraphicDevice')
                    devices{end + 1} = items{i}.Device;
                end
            end

            varCount = 0;
            for i = 1:numel(devices)
                if isa(devices{i}, 'TinySpice.Circuit.VoltageDefinedDevice')
                    varCount = varCount + 1;
                    devices{i}.Index = varCount;
                end
            end

            n = nodeCount + varCount;
            A = zeros(n);
            z = zeros(n, 1);

            for i = 1:numel(devices)
                dev    = devices{i};
                n1     = nodeMap(CB.posKey(dev.EntryNode));
                n2     = nodeMap(CB.posKey(dev.ExitNode));
                [A, z] = dev.stamp(A, z, n1, n2, nodeCount, freq);
            end

            disp(A);
            disp(z);

            x        = A \ z;
            voltages = x(1:nodeCount);
            currents = x(nodeCount + 1:end);
        end
    end
end