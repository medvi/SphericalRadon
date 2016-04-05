function [result] = interpolationT(findm, a, b, c, h_r, arg)
    result = cell(1, length(findm));
    for k = 1:length(findm)
        p = findm(k);
        result{k} = a(p)+(arg-b(p)).*(c(p+1)-a(p))./h_r;
    end
    result = cell2mat(transpose(result));
end