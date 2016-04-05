function [sradon_result] = sradon1(f,point_coords,radius,N,M1,M2)

    sradon_result = zeros(M1+1,M2+1,'double');
    for k = 1:M2+1
        k
        n = ceil(2*pi*radius(k)*N);
        for j = 1:M1+1
            if (radius(k)==0)
                sradon_result(j,k) = double(fnval(f,[point_coords(1,j);point_coords(2,j)]));
                continue;
            end
            s = 0;
            phi = zeros(1,n-1,'double');
            x = zeros(2,n-1,'double');
            x_ = zeros(2,n-1,'double');
            %for l = 1:n-1
                phi = 2*pi*(1:n-1)/n;
                x(1,:) = point_coords(1,j)+radius(k).*cos(phi);
                x(2,:) = point_coords(2,j)+radius(k).*sin(phi);
                x_(1,:) = (fix(N*x(1,:)-0.5)+0.5)/N;
                x_(2,:) = (fix(N*x(2,:)-0.5)+0.5)/N;
                s = s+sum(fnval(f,[x_(1,:);x_(2,:)]));
            %end
            sradon_result(j,k) = s/n;
        end
    end

end