function [ sradon_result ] = sradon(f, point_coords, radius)
%SRADON ����������� �������������� ������
%   ������� sradon ���������� �������� ������������ �������������� ������
%   ������� f �� ���������� � ������� � ����� point_coords � ��������
%   radius.

    syms t % ���������� ���������� ���������� t
    x = sym('x', [1 2]); % ���������� ������� ���������� ���������� x1 � x2
    
    % �������������� ��������� ����������
    r(t) = [cos(t), sin(t)];
    
    % ������� f �� ������� ���������
    subs_f = subs(f, x, point_coords + radius * r);
    
    % ��������������� �������; ����� ������������� ��������� 
    % �� ������ �� ����� ��������� x'(t) � y'(t)
    integrand_f = sum((subs_f.*transpose(sqrt(sum(diff(r).^2)))));
    %integrand_f
    
    % �������� �� ��������������� ������� �� t �� 0 �� 2*pi
    if radius == 0
        sradon_result = subs(f, x, point_coords);
    else
        sradon_result = int(integrand_f, t, 0, 2*pi) / (pi * radius * radius);
    end
end

