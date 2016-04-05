function I = vector_simpsons(f,a,b)
% Подсчет определенного интеграла методом симпсона для вектора значений f
    [row, col] = size(f);
    n=col-1;
    h=(b-a)/n;
    I = (f(:,1)+2.*sum(f(:,3:2:end-2))+4.*sum(f(:,2:2:end))+f(:,end)).*(h/3);
end