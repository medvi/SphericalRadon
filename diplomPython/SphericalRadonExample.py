import Image
I = Image.open('image.png').convert('LA')
N_phi = 49;
N_r = 49;
N = size(I,1)-1;
    R0 = 10;
    h_phi = 2*pi / (N_phi + 1);
    h_r = 2*R0 / N_r;
    h_x = 2*R0 / (N+1);

    r = (0:N_r).*h_r;

    p = zeros(2, N_phi+1, 'double');
    p(1,:) = R0*cos((0:N_phi).*h_phi);
    p(2,:) = R0*sin((0:N_phi).*h_phi);

    x = zeros(N+1, N+1, 2, 'double');
    x(:, :, 1) = transpose(-R0+ones(N+1,1)*(0:N).*h_x);
    x(:, :, 2) = -R0+ones(N+1,1)*(0:N).*h_x;
    n = 100;
    I = double(rgb2gray(I));
    f = csapi({x(:,1,1),x(1,:,2)},I);

    Mf = zeros(N_phi+1, N_r+1, 'double');
    Mf = sradon1(f,p,r,N+1,N_phi,N_r);
    imshow(Mf)
end

function [sradon_result] = sradon1(f,point_coords,radius,N,M1,M2)

    sradon_result = zeros(M1+1,M2+1,'double');
    n = ceil(2*pi*radius*N);
    for k = 1:M2+1
        k
        if (radius(k)==0)
            sradon_result(:,k) = double(fnval(f,[point_coords(1,:);point_coords(2,:)]));
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
            s = sum(fnval(f,[x_(1,:);x_(2,:)]));
            sradon_result(j,k) = s/n(k);
        end
    end

end