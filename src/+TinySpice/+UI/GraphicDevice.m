classdef (Sealed) GraphicDevice < TinySpice.UI.CanvasGraphic
    properties (Access = public)
        Device;
        X;
        Y;
        Rotation;
    end


    properties (Access = private)
        NameLabel;
        ValueLabel;
    end


    methods (Access = public)
        function graphicDevice = GraphicDevice(device, x, y, rotation, handles, nameLabel, valueLabel)
            graphicDevice.Device     = device;
            graphicDevice.X          = x;
            graphicDevice.Y          = y;
            graphicDevice.Rotation   = rotation;
            graphicDevice.Handles    = handles;
            graphicDevice.NameLabel  = nameLabel;
            graphicDevice.ValueLabel = valueLabel;
        end

        function updateLabels(device)
            device.NameLabel.String = device.Device.Name;
            device.ValueLabel.String = num2str(device.Device.Value);
        end

        function undo(device)
            delete(device.Handles);
            delete(device.NameLabel);
            delete(device.ValueLabel);
        end
    end
end