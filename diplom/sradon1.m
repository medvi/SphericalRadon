function [sradon_result] = sradon1(f,point_coords,radius,grid,N,M1,M2)

    sradon_result = zeros(M1,M2,'double');
    n = ceil(2*pi*radius*N);
    %[left,up] = meshgrid(grid(:,1,1),grid(1,:,2));
    for k = 1:M2
        disp(strcat(num2str(k),'/',num2str(N)));
        if (radius(k)==0)
            %sradon_result(:,k) = double(interp2(grid(:,:,1),grid(:,:,2),f,point_coords(1,:),point_coords(2,:),'spline'));
            
            x1 = round((point_coords(1,:)+0.5).*N);
            x1(x1<1) = 1;
            x1(x1>N) = N;
            x2 = round((point_coords(2,:)+0.5).*N);
            x2(x2<1) = 1;
            x2(x2>N) = N;
            for m = 1:M1
                sradon_result(m,k) = f(x1(m),x2(m));
            end
            continue;
        end
        x = zeros(2,n(k)-1,'double');
        x_ = zeros(2,n(k)-1,'double');
        phi = 2*pi*(1:(n(k)-1))/n(k);
        for j = 1:M1
            x(1,:) = point_coords(1,j)+radius(k).*cos(phi);
            x(2,:) = point_coords(2,j)+radius(k).*sin(phi);
            x_(1,:) = round(N*x(1,:))/N;
            x_(2,:) = round(N*x(2,:))/N;
            %s = sum(interp2(grid(:,:,1),grid(:,:,2),f,x_(1,:),x_(2,:),'spline'));
            
            x1 = round((x_(1,:)+0.5)*N);
            x1(x1>N) = N;
            x1(x1<=0) = 1;
            x2 = round((x_(2,:)+0.5)*N);
            x2(x2>N) = N;
            x2(x2<=0) = 1;
            s = 0;
            for m = 1:n(k)-1
                s = s + f(x1(m), x2(m));
            end
            sradon_result(j,k) = s/n(k);
        end
    end

%    minim = min(min(sradon_result));
%    sradon_result(:,:) = (sradon_result(:,:)-minim).*255./(255-minim);
    
end