function [result] = calvalmat(X1, Y1, X2, Y2)
    first = cell2mat(transpose(arrayfun(@(x)(x-X1),Y1,'UniformOutput',0)));
    second = cell2mat(transpose(arrayfun(@(x)(x-X2),Y2,'UniformOutput',0)));
    first = first.^2;
    second = second.^2;
    result = sqrt(first + second);
end