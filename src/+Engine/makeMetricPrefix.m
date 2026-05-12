function str = makeMetricPrefix(value)
    if (value == 0)
        str = "0";
        return;
    elseif isinf(value)
        str = "inf ";
        return;
    end

    prefixes = ["p", "n", "u", "m", "", "k", "M", "G", "T"];
    exponent = -12:3:12;

    exp = max(min(floor(log10(abs(value)) / 3) * 3, 12), -12);
    str = sprintf('%.4g %s', value / (10^exp), prefixes(find(exponent == exp)));
end