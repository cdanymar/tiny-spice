classdef (Sealed) SimulationContext < handle
    properties (Access = public)
        LHS (:, :) double {mustBeNumeric, mustBeFinite}
        RHS (:, 1) double {mustBeNumeric, mustBeFinite}
    end

    methods (Access = public)
        function equation = SimulationContext(totalSize)
            arguments
                totalSize (1, 1) int32 {mustBePositive}
            end

            equation.LHS = zeros(totalSize);
            equation.RHS = zeros(totalSize, 1);
        end
    end
end
