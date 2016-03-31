function [result] = interpolationT(findm, a, b, c, h_r, arg)
    result = zeros(length(findm), 1, 'double');
    for k = 1:length(findm)
        result(k) = a(k)+(arg(k)-b(k))*(c(k+1)-a(k))/h_r;
    end
end