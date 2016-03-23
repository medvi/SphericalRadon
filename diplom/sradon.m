function [ sradon_result ] = sradon(f, point_coords, radius)
%SRADON ����������� �������������� ������
%   ������� sradon ���������� �������� ������������ �������������� ������
%   ������� f �� ���������� � ������� � ����� point_coords � ��������
%   radius.
% 
    syms t % ���������� ���������� ���������� t
%    x = sym('x', [1 2]); % ���������� ������� ���������� ���������� x1 � x2
%     
    % �������������� ��������� ����������
    r(t) = [cos(t), sin(t)];
%     
    % ������� f �� ������� ���������
    %subs_f = subs(f, x, point_coords + radius * r);
    integrand(t) = f(point_coords(1)+radius*cos(t), point_coords(2)+radius*sin(t));
    % ��������������� �������; ����� ������������� ��������� 
    % �� ������ �� ����� ��������� x'(t) � y'(t)
    %integrand_f = sum((subs_f.*transpose(sqrt(sum(diff(r).^2)))));
    %integrand_f
    
    % �������� �� ��������������� ������� �� t �� 0 �� 2*pi
    if radius == 0
        sradon_result = double(f(point_coords(1), point_coords(2)));
    else
        %sradon_result = int(integrand_f, t, 0, 2*pi) / (pi * radius * radius);
        n = 100;
        sradon_result = double(simpsons(integrand, 0, 2*pi, n));
    end
end

