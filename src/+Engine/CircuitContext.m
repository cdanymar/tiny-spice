classdef (Sealed) CircuitContext < handle
    properties (Access = public)
        % todo contain result within context
        % todo refactor to optimze space around calculated results
        Type      (1, 1) Engine.AnalysisType
        Frequency (1, 1) double {mustBeNonnegative}
    end

    methods (Access = public)
        function ctx = CircuitContext(options)
            arguments
                options.Type      (1, 1) Engine.AnalysisType        = Engine.AnalysisType.DC
                options.Frequency (1, 1) double {mustBeNonnegative} = 0
            end

            if (options.Type == Engine.AnalysisType.DC) || (options.Frequency == 0)
                ctx.Type      = Engine.AnalysisType.DC;
                ctx.Frequency = 0;
            else
                ctx.Type      = options.Type;
                ctx.Frequency = options.Frequency;
            end
        end
    end
end
