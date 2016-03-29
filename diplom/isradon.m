function [isradon_result] = isradon(Mf, r_ind, p_ind, N_r, N_phi, N, R0)
% ISRADON
%   f(i) = (BIDF)(i)

    %h_phi = 2*pi / (N_phi + 1);
    h_r = 2 * R0 / N_r;
    a = zeros(N_r+1, N_r+1);
    b = zeros(N_r+1, N_r+1);
    
    % ���������� ������������� a(m, m') � b(m, m')
    for m = 1:N_r+1
        a(m,:) = a_koef(r_ind+1, r_ind(m)) - a_koef(r_ind, r_ind(m));
        b(m,:) = -r_ind.*a(m,:)+0.5*(b_koef(r_ind+1, r_ind(m)) - b_koef(r_ind, r_ind(m)));
    end
    
    % �������� D
    F = zeros(N_phi+1, N_r+1);
    for m = 1:N_r+1
        if m == 1
            F(:, m) = (m+0.5)*Mf(:, m+1) - 2*m*Mf(:, m);
        elseif m == N_r+1
            F(:, m) = (m-0.5)*Mf(:, m-1) - 2*m*Mf(:, m);
        else
            F(:, m) = (m+0.5)*Mf(:, m+1) + (m-0.5)*Mf(:, m-1) - 2*m*Mf(:, m);
        end
    end
    F = F ./ h_r;
    
    % �������� I
    F_dub = zeros(N_phi+1, N_r+1);
    for m1 = 1:N_r+1
        summ = 0;
        for m2 = 1:N_r
            summ = a(m1, m2)*F(:, m2) + b(m1, m2)*(F(:, m2+1)-F(:, m2))/h_r;
        end
        F_dub(:, m1) = summ;
    end
    
    % FBP with linear interpolation
    x = zeros(N+1, N+1, 2, 'double');
    f = zeros(N+1, N+1, 'double');
    h_x = 2*R0 / (N+1);
    
    x(:, :, 1) = -R0+ones(N+1,1)*(0:N).*h_x;
    x(:, :, 2) = transpose(-R0+ones(N+1,1)*(0:N).*h_x);
    
    indices = x(:, :, 1).^2 + x(:, :, 2).^2;
    for i1 = 1:N+1
        i1
        indices_temp = find(indices(i1,:)<=R0^2);
        for i2 = 1:N+1
            % x(i) inside the disk
            value = sqrt((p_ind(1,:)-x(i1, i2, 1)).^2+(p_ind(2,:)-x(i1, i2, 2)).^2);
            for k = 1:length(indices_temp)
                index = indices_temp(k);
                temp = r_ind - value(index);
                temp = find(diff(sign(temp))~=0);
                if (isempty(temp)) 
                    continue;
                else
                    findm = temp(1);
                end
                arg = value(index);
                T = interpolationT(F_dub(index,findm), r_ind(findm), F_dub(index,findm+1), h_r, arg);
                f(i1, i2) = f(i1, i2) + T/(N_phi+1);
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

% for i1 = 1:N+1
%         i1
%         for i2 = 1:N+1
%             x(i1, i2, 1) = -R0+(i1-1)*h_x;
%             x(i1, i2, 2) = -R0+(i2-1)*h_x;
%             f(i1, i2) = 0;
%             for k = 1:N_phi+1
%                 % x(i) outside the disk
%                 if (x(i1, i2, 1)^2 + x(i1, i2, 2)^2 > R0^2)
%                     f(i1, i2) = 0;
%                     continue;
%                 end
%                 % x(i) inside the disk
%                 findm = -1;
%                 for m = 1:N_r
%                     value = sqrt((p_ind(1, k)-x(i1, i2, 1))^2+(p_ind(2, k)-x(i1, i2, 2))^2);
%                     if ((value>=r_ind(m)) && (value<r_ind(m+1)))
%                         findm = m;
%                         break;
%                     end % end if
%                 end % end for m
%                 if (findm == -1) 
%                     %findm = N_r;
%                     continue;
%                 end
%                 arg = sqrt((p_ind(1, k)-x(i1, i2, 1))^2+(p_ind(2, k)-x(i1, i2, 2))^2);
%                 T = interpolationT(F_dub(k,findm), r_ind(findm), F_dub(k,findm+1), h_r, arg);
%                 f(i1, i2) = f(i1, i2) + T/(N_phi+1);
%             end % end for k
%     end % end for i1