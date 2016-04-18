function [isradon_result] = isradon(Mf,r_ind,p_ind,x,N_r,N_phi,N,R0)
% ISRADON
%   f(i) = (BIDF)(i)

    epsilon = 0.00001;

    %h_phi = 2*pi / (N_phi + 1);
    h_r = 2*R0/N_r;
    a = zeros(N_r+1, N_r+1);
    b = zeros(N_r+1, N_r+1);
    % ���������� ������������� a(m, m') � b(m, m')
    for m = 1:N_r+1
        a(m,:) = a_koef(r_ind+1, r_ind(m)) - a_koef(r_ind, r_ind(m));
        b(m,:) = -r_ind.*a(m,:)+0.5*(b_koef(r_ind+1, r_ind(m)) - b_koef(r_ind, r_ind(m)));
    end
    a = abs(a);
    b = abs(b);
    a(isnan(a))=0;
    b(isnan(b))=0;
    
    % �������� D
    F = zeros(N_phi+1, N_r+1);
    for m = 1:N_r+1
        if m == 1
            F(:, m) = (m+0.5).*Mf(:, m+1) - 2*m.*Mf(:, m);
        elseif m == N_r+1
            F(:, m) = (m-0.5).*Mf(:, m-1) - 2*m.*Mf(:, m);
        else
            F(:, m) = (m+0.5).*Mf(:, m+1) + (m-0.5).*Mf(:, m-1) - 2*m.*Mf(:, m);
        end
    end
    %F = F ./ h_r; %??????????????
    
    % �������� I
    F_dub = zeros(N_phi+1, N_r+1);
    for m1 = 1:N_r+1
        summ = 0;
        for m2 = 1:N_r
            summ = a(m1, m2).*F(:, m2) + b(m1, m2).*(F(:, m2+1)-F(:, m2))./h_r;
        end
        F_dub(:, m1) = summ;
    end
    % FBP with linear interpolation
    f = zeros(N+1, N+1, 'double');
    f(:,:) = 255;
    
    % ��� �����
    for i1 = 1:N+1
        i1
        for i2 = 1:N+1
            if (x(i1, i2, 1)^2 + x(i1, i2, 2)^2 > R0^2)
                continue;
            end
            % x(i) inside the disk
            for k = 1:N_phi+1
                value = sqrt((p_ind(1,k)-x(i1,i2,1))^2+(p_ind(2,k)-x(i1,i2,2))^2);
                value = value+epsilon;
                temp = r_ind - value;
                %temp = cell2mat(transpose(arrayfun(@(x)(x-value_epsilon(:,index)),r_ind,'UniformOutput',0)));
                findms = find(diff(sign(temp))~=0);
                if (isempty(findms)) 
                    continue;
                else
                    findm = findms(1);
                end
                arg = value;
                T = interpolationT1(F_dub(k,findm), r_ind(findm), F_dub(k,findm+1), h_r, arg);
                f(i1,i2) = f(i1,i2)+T/(N_phi+1);
            end % end for k
        end % end for i2
    end % end for i1

    % ����� � ����
%     fileID = fopen(strcat('result_files\',num2str(N_r),'x',num2str(N_phi),'.txt'),'w');
%     fprintf(fileID,'%6s %6s %12s\n','x1','x2', 'f(x1, x2)');
%     for i1 = 1:N+1
%         for i2 = 1:N+1
%             fprintf(fileID,'%6.2f %6.2f %12.8f\n\n', x(i1, i2, 1), x(i1, i2, 2), f(i1, i2));        
%         end
%     end
%     fclose(fileID);
    
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

% for i1 = 1:N+1
%         i1
%         indices(i1,:);
%         indices_temp = find(indices(i1,:)<=R0^2);
%         value = calvalmat(p_ind(1,:), x(i1, :, 1),p_ind(2,:), x(i1, :, 2));
%         value_epsilon = value + epsilon;
%         %for i2 = 1:N+1
%             % x(i) inside the disk
%             %value = sqrt((p_ind(1,:)-x(i1, i2, 1)).^2+(p_ind(2,:)-x(i1, i2, 2)).^2);
%             %value_epsilon = value + epsilon;
%             for k = 1:length(indices_temp)
%                 index = indices_temp(k);
%                 %temp = r_ind - value_epsilon(i2, index);
%                 temp = cell2mat(transpose(arrayfun(@(x)(x-value_epsilon(:,index)),r_ind,'UniformOutput',0)));
%                 [row, col] = find(diff(sign(temp(:,:)))~=0, length(temp(:,1)));
%                 if (isempty(row)) 
%                     continue;
%                 else
%                     findm = col;
%                 end
%                 
%                 arg = value(:, index);
%                 T = interpolationT(findm, F_dub(index,:), r_ind, F_dub(index,:), h_r, arg);
%                 f(i1, :) = f(i1, :) + T./(N_phi+1);
%             end % end for k
%         %end % end for i2
%     end % end for i1

% ������� (�� ��� �����, �����, ������������) ������ � ����� �������
% for i1 = 1:N+1
%         i1
%         for i2 = 1:N+1
%             if (x(i1, i2, 1)^2 + x(i1, i2, 2)^2 > R0^2)
%                 continue;
%             end
%             % x(i) inside the disk
%             for k = 1:N_phi+1
%                 value = sqrt((p_ind(1,k)-x(i1,i2,1))^2+(p_ind(2,k)-x(i1,i2,2))^2);
%                 value = value+epsilon;
%                 temp = r_ind - value;
%                 %temp = cell2mat(transpose(arrayfun(@(x)(x-value_epsilon(:,index)),r_ind,'UniformOutput',0)));
%                 findms = find(diff(sign(temp))~=0);
%                 if (isempty(findms)) 
%                     continue;
%                 else
%                     findm = findms(1);
%                 end
%                 arg = value;
%                 T = interpolationT1(F_dub(k,findm), r_ind(findm), F_dub(k,findm+1), h_r, arg);
%                 f(i1,i2) = f(i1,i2)+T/(N_phi+1);
%             end % end for k
%         end % end for i2
%     end % end for i1

% % ��� �����
%     for i1 = 1:N+1
%         i1
%         for i2 = 1:N+1
%             if (x(i1, i2, 1)^2 + x(i1, i2, 2)^2 > R0^2)
%                 continue;
%             end
%             % x(i) inside the disk
%             for k = 1:N_phi+1
%                 value = sqrt((p_ind(1,k)-x(i1,i2,1))^2+(p_ind(2,k)-x(i1,i2,2))^2);
%                 value = value+epsilon;
%                 temp = r_ind - value;
%                 %temp = cell2mat(transpose(arrayfun(@(x)(x-value_epsilon(:,index)),r_ind,'UniformOutput',0)));
%                 findms = find(diff(sign(temp))~=0);
%                 if (isempty(findms)) 
%                     continue;
%                 else
%                     findm = findms(1);
%                 end
%                 arg = value;
%                 T = interpolationT1(F_dub(k,findm), r_ind(findm), F_dub(k,findm+1), h_r, arg);
%                 f(i1,i2) = f(i1,i2)+T/(N_phi+1);
%             end % end for k
%         end % end for i2
%     end % end for i1