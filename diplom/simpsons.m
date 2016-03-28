function I = simpsons(f,a,b,n)
% Подсчет определенного интеграла методом Симпсона
    h=(b-a)/n; 
    xi=a:h:b;
    f_1 = f(xi(1));
    f_odd = 2.*sum(cell2mat(arrayfun(f, xi(3:2:end-2), 'UniformOutput', false)),2);
    f_even = 4.*sum(cell2mat(arrayfun(f, xi(2:2:end), 'UniformOutput', false)),2);
    f_end = f(xi(end));
    I = (f_1+f_odd+f_even+f_end).*(h/3);
end