function [result] = my_log(x)
    result = zeros(1, length(x));
    for i = 1:length(x)
        if x(i) == 0
            result(1, i) = 0;
        else
            result(1, i) = log(x(i));
        end
    end
end