function [ sradon_result ] = sradon(f, point_coords, radius, n, N_r)
%SRADON Сферическое преобразование Радона
%   Функция sradon возвращает значение сферического преобразования Радона
%   функции f по окружности с центром в точке point_coords и радиусом
%   radius.
    
    integrand = @(t) transpose(f(point_coords(1)+radius.*cos(t), point_coords(2)+radius.*sin(t)));
    %integrand
    
%     radius
%     radius .* radius
%     pi .* radius .* radius
    
    sradon_result = double(transpose(simpsons(integrand, 0, 2*pi, n))) ./ (pi .* radius .* radius);
    for i = 1:N_r+1
        if (radius(i) == 0)
            sradon_result(i) = double(f(point_coords(1), point_coords(2)));
        end
    end
end

