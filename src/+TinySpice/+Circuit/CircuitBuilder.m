classdef CircuitBuilder
    methods (Static)
        function [nodeMap, nodeCount] = build(items)
            parent = containers.Map();
            CB     = TinySpice.Circuit.CircuitBuilder;

            for i = 1:numel(items)
                item = items{i};

                if isa(item, 'TinySpice.UI.GraphicDevice')
                    CB.addKey(parent, item.Device.EntryNode);
                    CB.addKey(parent, item.Device.ExitNode);
                elseif isa(item, 'TinySpice.UI.GraphicGround')
                    CB.addKey(parent, item.Ground.Position);
                elseif isa(item, 'TinySpice.UI.GraphicWire')
                    p1 = [item.X1, item.Y1];
                    p2 = [item.X2, item.Y2];

                    CB.addKey(parent, p1);
                    CB.addKey(parent, p2);
                    CB.union(parent, p1, p2);
                end
            end

            assigned  = containers.Map();
            nodeMap   = containers.Map();
            nodeCount = 0;

            for i = 1:numel(items)
                if isa(items{i}, 'TinySpice.UI.GraphicGround')
                    root           = CB.find(parent, CB.posKey(items{i}.Ground.Position));
                    assigned(root) = 0;
                end
            end

            keys = parent.keys();
            for i = 1:numel(keys)
                root = CB.find(parent, keys{i});
                if ~isKey(assigned, root)
                    nodeCount      = nodeCount + 1;
                    assigned(root) = nodeCount;
                end
                nodeMap(keys{i}) = assigned(root);
            end
        end

        function k = posKey(pos)
            k = sprintf('%d_%d', pos(1), pos(2));
        end
    end

    methods (Static, Access = private)
        function addKey(parent, pos)
            k = TinySpice.Circuit.CircuitBuilder.posKey(pos);
            if ~isKey(parent, k)
                parent(k) = k;
            end
        end

        function union(parent, pos1, pos2)
            CB = TinySpice.Circuit.CircuitBuilder;
            r1 = CB.find(parent, CB.posKey(pos1));
            r2 = CB.find(parent, CB.posKey(pos2));

            if ~strcmp(r1, r2)
                parent(r1) = r2;
            end
        end

        function root = find(parent, key)
            while ~strcmp(parent(key), key)
                parent(key) = parent(parent(key));
                key         = parent(key);
            end

            root = key;
        end
    end
end