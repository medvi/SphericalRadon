function [result] = interpolationT1(a, b, c, h_r, arg)
    result = a+(arg-b)*(c-a)/h_r;
end