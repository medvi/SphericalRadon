function ISRadonExample

    I = double(rgb2gray(imread('images\Ellipse256.png','png')));
    N = size(I,1);
    M1 = N;
    M2 = N;
     
    % вычисление r_m
    r = (0:N-1)/N;
    
    % вычисление p_k
    p = zeros(2, N, 'double');
    p(1,:) = 0.5*cos(2*pi*(0:N-1)/N);
    p(2,:) = 0.5*sin(2*pi*(0:N-1)/N);
    
    x = zeros(N, N, 2, 'double');
    x1 = meshgrid((-1:2/(N-1):1),(-1:2/(N-1):1));
    x2 = transpose(meshgrid((-1:2/(N-1):1),(-1:2/(N-1):1)));
    x(:,:,1) = x1;
    x(:,:,2) = x2;
    
%   вычисление Mf(p_k, r_m)
    Mf = sradon1(I,p,r,x,N,M1,M2)
    imshow(Mf)
    im = image(Mf);
    imsave(im);
    
    %result = isradon(Mf, r, p, x, N_r, N_phi, N, R0);
    %imshow(result)
end