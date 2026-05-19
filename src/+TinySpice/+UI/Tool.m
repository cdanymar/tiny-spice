classdef (Sealed) Tool
    properties (GetAccess = public, SetAccess = immutable)
        Icon;
        Label;
    end

    enumeration
        Resistor        ('R', 'Place Resistor')
        Capacitor       ('C', 'Place Capacitor')
        Inductor        ('L', 'Place Inductor')
        VoltageSource   ('U', 'Place Voltage Source')
        CurrentSource   ('I', 'Place Current Source')
        Wire            ('-', 'Place Wire')
        Ground          ('G', 'Place Ground')
        FreeRoam        (' ', 'Free Roam')
    end

    methods (Access = private)
        function tool = Tool(icon, label)
            tool.Icon  = icon;
            tool.Label = label;
        end
    end
end