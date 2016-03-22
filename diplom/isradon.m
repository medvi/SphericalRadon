function [isradon_result] = isradon(Mf, r_ind, p_ind)
% ISRADON
%   f(i) = (BIDF)(i)

    N_phi = 10;
    N_r = 10;
    R0 = 1;
    %h_phi = 2*pi / (N_phi + 1);
    h_r = 2 * R0 / N_r;
    a = zeros(N_r+1, N_r+1);
    b = zeros(N_r+1, N_r+1);
    
    % ���������� ������������� a(m, m') � b(m, m')
    for m1 = 1:N_r+1
        for m2 = 1:N_r+1
            a(m1, m2) = a_koef(r_ind(m2)+1, r_ind(m1)) - a_koef(r_ind(m2), r_ind(m1));
            b(m1, m2) = -r_ind(m2)*a(m1, m2)+0.5*(b_koef(r_ind(m2)+1, r_ind(m1)) - b_koef(r_ind(m2), r_ind(m1)));
        end
    end
    
    % ���������� ��������� D � ��������� I
    F = zeros(N_phi+1, N_r+1);
    F_dub = zeros(N_phi+1, N_r+1);
    for k = 1:N_phi+1
        % �������� D
        for m = 1:N_r+1
            if m == 1
                F(k, m) = (m+0.5)*Mf(k, m+1) - 2*m*Mf(k, m);
            elseif m == N_r+1
                F(k, m) = (m-0.5)*Mf(k, m-1) - 2*m*Mf(k, m);
            else
                F(k, m) = (m+0.5)*Mf(k, m+1) + (m-0.5)*Mf(k, m-1) - 2*m*Mf(k, m);
            end
        end
        % �������� I
        for m1 = 1:N_r+1
            summ = 0;
            for m2 = 1:N_r
                summ = a(m1, m2)*F(k, m2) + b(m1, m2)*(F(k, m2+1)-F(k, m2))/h_r;
            end
            F_dub(k, m1) = summ;
        end
    end
    
    % FBP with linear interpolation
    N = 10;
    x = zeros(N+1, N+1, 2, 'double');
    f = zeros(N+1, N+1, 'double');
    h_x = 2*R0 / (N+1);
    for i1 = 1:N+1
        i1
        for i2 = 1:N+1
            x(i1, i2, 1) = -R0+(i1-1)*h_x;
            x(i1, i2, 2) = -R0+(i2-1)*h_x;
            f(i1, i2) = 0;
            for k = 1:N_phi+1
                findm = -1;
                for m = 1:N_r
                    value = sqrt((p_ind(1, k)-x(i1, i2, 1))^2+(p_ind(2, k)-x(i1, i2, 2))^2);
                    if ((value>=r_ind(m)) && (value<r_ind(m+1)))
                        findm = m;
                        break;
                    end % end if
                end % end for m
                if (findm == -1) 
                    %findm = N_r;
                    continue;
                end
                syms arg
                arg = sqrt((p_ind(1, k)-x(i1, i2, 1))^2+(p_ind(2, k)-x(i1, i2, 2))^2)
                T = F_dub(k,findm)+(arg-r_ind(findm))*(F_dub(k,findm+1)-F_dub(k,findm))/h_r
                f(i1, i2)
                T/(N+phi+1)
                f(i1, i2) = f(i1, i2) + T/(N_phi+1)
            end % end for k
        end % end for i2
    end % end for i1
    
    % ����� � ����
    fileID = fopen('result_files\recovering_f.txt','w');
    fprintf(fileID,'%6s %6s %12s\n','x1','x2', 'f(x1, x2)');
    for i1 = 1:N+1
        for i2 = 1:N+1
            fprintf(fileID,'%6.2f %6.2f %12.8f\n\n', x(i1, i2, 1), x(i1, i2, 2), f(i1, i2));        
        end
    end
    fclose(fileID);
    
    isradon_result = f;
end