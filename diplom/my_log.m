function [result] = my_log(x)
    if x == 0
        result = 0;
    else
        result = log(x);
    end
end