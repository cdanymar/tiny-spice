classdef CircuitSolver
    methods (Static, Access = public)
        function results = solve(items, freq)
            CB = TinySpice.Circuit.CircuitBuilder;

            [nodeMap, nodeCount] = CB.build(items);

            devices = {};
            for i = 1:numel(items)
                if isa(items{i}, 'TinySpice.UI.GraphicDevice')
                    devices{end + 1} = items{i}.Device;
                end
            end

            varCount = 0;
            for i = 1:numel(devices)
                if isa(devices{i}, 'TinySpice.Circuit.VoltageDefinedDevice')
                    varCount        = varCount + 1;
                    devices{i}.Index = varCount;
                end
            end

            n = nodeCount + varCount;
            A = zeros(n);
            z = zeros(n, 1);

            for i = 1:numel(devices)
                dev = devices{i};
                n1  = nodeMap(CB.posKey(dev.EntryNode));
                n2  = nodeMap(CB.posKey(dev.ExitNode));

                [A, z] = dev.stamp(A, z, n1, n2, nodeCount, freq);
            end

            x              = A \ z;
            nodeVoltages   = x(1:nodeCount);
            branchCurrents = x(nodeCount + 1:end);

            results = struct('Name', {}, 'Voltage', {}, 'Current', {});

            for i = 1:numel(devices)
                dev = devices{i};
                n1  = nodeMap(CB.posKey(dev.EntryNode));
                n2  = nodeMap(CB.posKey(dev.ExitNode));

                v1 = 0; if n1 > 0; v1 = nodeVoltages(n1); end
                v2 = 0; if n2 > 0; v2 = nodeVoltages(n2); end

                vAcross  = v1 - v2;
                iThrough = computeCurrent(dev, vAcross, branchCurrents, freq);

                results(end + 1).Name = char(dev.Name);
                results(end).Voltage  = vAcross;
                results(end).Current  = iThrough;
            end


            function I = computeCurrent(dev, vAcross, branchCurrents, freq)
                if isa(dev, 'TinySpice.Circuit.VoltageDefinedDevice')
                    I = branchCurrents(dev.Index);
                elseif isa(dev, 'TinySpice.Circuit.Resistor')
                    I = vAcross / dev.Value;
                elseif isa(dev, 'TinySpice.Circuit.Capacitor')
                    I = 1j * 2 * pi * freq * dev.Value * vAcross;
                elseif isa(dev, 'TinySpice.Circuit.CurrentSource')
                    I = dev.Value;
                else
                    I = 0;
                end
            end
        end
    end
end