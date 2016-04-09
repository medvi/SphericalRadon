function [sradon_result] = sradon1(f,point_coords,radius,grid,N,M1,M2)

    sradon_result = zeros(M1+1,M2+1,'double');
    n = ceil(2*pi*radius*N);
    %[left,up] = meshgrid(x(:,1,1),x(1,:,2));
    for k = 1:M2+1
        k
        if (radius(k)==0)
            %sradon_result(:,k) = double(fnval(f,[point_coords(1,:);point_coords(2,:)]));
            sradon_result(:,k) = double(interp2(grid(:,:,1),grid(:,:,2),f,point_coords(1,:),point_coords(2,:)));
            continue;
        end
        x = zeros(2,n(k)-1,'double');
        x_ = zeros(2,n(k)-1,'double');
        for j = 1:M1+1
            phi = 2*pi*(1:n(k)-1)/n(k);
            x(1,:) = point_coords(1,j)+radius(k).*cos(phi);
            x(2,:) = point_coords(2,j)+radius(k).*sin(phi);
            x_(1,:) = round(N*x(1,:))/N;
            x_(2,:) = round(N*x(2,:))/N;
            %s = sum(fnval(f,[x_(1,:);x_(2,:)]));
            s = sum(interp2(grid(:,:,1),grid(:,:,2),f,x_(1,:),x_(2,:)));
            sradon_result(j,k) = s/n(k);
        end
    end

end