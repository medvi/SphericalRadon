function [isradon_result] = isradon(Mf,r_ind,p_ind,x,N_r,N_phi,N,R0)
% ISRADON
%   f(i) = (BIDF)(i)

    epsilon = 0.00001;

    %h_phi = 2*pi / (N_phi + 1);
    h_r = 2*R0/N_r;
    a = zeros(N_r+1, N_r+1);
    b = zeros(N_r+1, N_r+1);
    % ���������� ������������� a(m, m') � b(m, m')
    for m1 = 1:N_r+1 % m1 ~ m
    for m2 = 1:N_r % m2 ~ m'
        a(m1,m2) = (r_ind(m2+1)-r_ind(m1))*log(abs(r_ind(m2+1)-r_ind(m1)))...
            +(r_ind(m2+1)+r_ind(m1))*log(abs(r_ind(m2+1)+r_ind(m1)))-2*r_ind(m2+1)-...
            (r_ind(m2)-r_ind(m1))*log(abs(r_ind(m2)-r_ind(m1)))...
            -(r_ind(m2)+r_ind(m1))*log(abs(r_ind(m2)+r_ind(m1)))+2*r_ind(m2);
        b(m1,m2) = -r_ind(m2)*a(m1,m2)+...
            0.5*((r_ind(m2+1)^2-r_ind(m1)^2)*log(abs(r_ind(m2+1)^2-r_ind(m1)^2))-r_ind(m2+1)^2-...
            (r_ind(m2)^2-r_ind(m1)^2)*log(abs(r_ind(m2)^2-r_ind(m1)^2))+r_ind(m2)^2);
    end
    end

    a = abs(a);
    b = abs(b);
    a(isnan(a)) = 0;
    b(isnan(b)) = 0;
    % �������� D
    F = zeros(N_phi+1, N_r+1);
    for m = 1:N_r+1
        if m == 1
            F(:,m) = (m+0.5).*Mf(:,m+1)-2*m.*Mf(:,m);
        elseif m == N_r+1
            F(:,m) = (m-0.5).*Mf(:,m-1)-2*m.*Mf(:,m);
        else
            F(:,m) = (m+0.5).*Mf(:,m+1)+(m-0.5).*Mf(:,m-1)-2*m.*Mf(:,m);
        end
    end
    %F = F ./ h_r; %??????????????
    
    % �������� I
    F_dub = zeros(N_phi+1,N_r+1);
    for k = 1:N_phi+1
        for m = 1:N_r+1
            summ = 0;
            for m1 = 1:N_r
                summ = summ+a(m,m1)*F(k,m1)+b(m,m1)*(F(k,m1+1)-F(k,m1))/h_r;
            end
            F_dub(k,m) = summ;
        end
    end
    
    % FBP with linear interpolation
    f = zeros(N+1, N+1, 'double');
    % ��� �����
    for i1 = 1:N+1
        disp(strcat(num2str(i1),'/',num2str(N+1)));
        for i2 = 1:N+1
            if (x(i1, i2, 1)^2 + x(i1, i2, 2)^2 > R0^2)
                continue;
            end
            % x(i) inside the disk
            value = sqrt((p_ind(1,:)-x(i1,i2,1)).^2+(p_ind(2,:)-x(i1,i2,2)).^2);
            valueE = value+epsilon;
            T = zeros(1,N_phi+1);
            for k = 1:N_phi+1
                temp = r_ind - valueE(k);
                findms = find(diff(sign(temp))~=0);
                if (isempty(findms)) 
                    continue;
                else
                    findm = findms(1);
                end
                T(k) = F_dub(k,findm)+(value(k)-r_ind(findm))*(F_dub(k,findm+1)-F_dub(k,findm))/h_r;
            end % end for k
            f(i1,i2) = sum(T./(N_phi+2));
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

    f = abs(f);
    f = f./max(max(f)).*255;
    isradon_result = f;
end
