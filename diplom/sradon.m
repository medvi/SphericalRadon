function [ sradon_result ] = sradon(f, point_coords, radius)
%SRADON Сферическое преобразование Радона
%   Функция sradon возвращает значение сферического преобразования Радона
%   функции f по окружности с центром в точке point_coords и радиусом
%   radius.
% 
    syms t % объявление символьной переменной t
%    x = sym('x', [1 2]); % объявление вектора символьных переменных x1 и x2
%     
    % параметризация единичной окружности
    r(t) = [cos(t), sin(t)];
%     
    % функция f от нужного аргумента
    %subs_f = subs(f, x, point_coords + radius * r);
    integrand(t) = f(point_coords(1)+radius*cos(t), point_coords(2)+radius*sin(t));
    % подынтегральная функция; нужно дополнительно домножить 
    % на корень из суммы квадратов x'(t) и y'(t)
    %integrand_f = sum((subs_f.*transpose(sqrt(sum(diff(r).^2)))));
    %integrand_f
    
    % интеграл от подынтегральной функции по t от 0 до 2*pi
    if radius == 0
        sradon_result = double(f(point_coords(1), point_coords(2)));
    else
        %sradon_result = int(integrand_f, t, 0, 2*pi) / (pi * radius * radius);
        n = 100;
        sradon_result = double(simpsons(integrand, 0, 2*pi, n));
    end
end

