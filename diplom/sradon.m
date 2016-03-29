function [ sradon_result ] = sradon(f, point_coords, radius, n, N_r)
%SRADON ����������� �������������� ������
%   ������� sradon ���������� �������� ������������ �������������� ������
%   ������� f �� ���������� � ������� � ����� point_coords � ��������
%   radius.
    
    integrand = @(t) transpose(f(point_coords(1)+radius.*cos(t), point_coords(2)+radius.*sin(t)));
    %integrand
    
%     radius
%     radius .* radius
%     pi .* radius .* radius
    
    sradon_result = double(transpose(simpsons(integrand, 0, 2*pi, n))) ./ (pi .* radius .* radius);
    sradon_result(sradon_result == Inf) = double(f(point_coords(1), point_coords(2)));
end

