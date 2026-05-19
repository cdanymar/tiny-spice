classdef (Sealed) Serializer
    methods (Static)
        function json = serialize(items)
            data.devices = {};
            data.wires   = {};
            data.grounds = {};

            for i = 1:numel(items)
                item = items{i};

                if isa(item, 'TinySpice.UI.GraphicDevice')
                    dev   = item.Device;
                    entry = struct(...
                        'type',     class(dev),     ...
                        'x',        item.X,         ...
                        'y',        item.Y,         ...
                        'angle',    item.Rotation,  ...
                        'name',     char(dev.Name), ...
                        'value',    dev.Value       ...
                    );
                    data.devices{end + 1} = entry;
                elseif isa(item, 'TinySpice.UI.GraphicWire')
                    entry = struct('x1', item.X1, 'y1', item.Y1, 'x2', item.X2, 'y2', item.Y2);
                    data.wires{end + 1} = entry;
                elseif isa(item, 'TinySpice.UI.GraphicGround')
                    entry = struct(                             ...
                        'x',        item.Ground.Position(1),    ...
                        'y',        item.Ground.Position(2),    ...
                        'angle',    item.Rotation               ...
                    );

                    data.grounds{end + 1} = entry;
                end
            end

            json = jsonencode(data, PrettyPrint = true);
        end

        function data = deserialize(json)
            data = jsondecode(json);
        end
    end
end