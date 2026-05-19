classdef (Sealed) Wire < handle
    methods (Access = public)
        function handles = draw(wire, axes, x1, y1, x2, y2)
            handles = [
                plot(axes, [x1, x2], [y1, y1]),
                plot(axes, [x2, x2], [y1, y2])
            ];
        end
    end
end