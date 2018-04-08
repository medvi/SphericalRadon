function ISRadonExample

    [filename,pathname] = uigetfile('*.png','Select the image');
    I = transpose(double(rgb2gray(imread(fullfile(pathname,filename),'png'))));
    N = size(I,1);
    M1 = N;
    M2 = N;
    R0 = 0.5;
    
    r = (0:N-1)/N;
    
    p = zeros(2, N, 'double');
    p(1,:) = R0*cos(2*pi*(0:N-1)/N);
    p(2,:) = R0*sin(2*pi*(0:N-1)/N);
    
    x = zeros(N, N, 2, 'double');
    x1 = meshgrid((-R0:1/(N-1):R0),(-R0:1/(N-1):R0));
    x2 = transpose(meshgrid((-R0:1/(N-1):R0),(-R0:1/(N-1):R0)));
    x(:,:,1) = x1;
    x(:,:,2) = x2;
    
    colormap gray
    
%   spherical radon transform
    Mf = sradon1(I,p,r,x,N,M1,M2);
    
    im = mat2gray(Mf);
    imshow(im);
%    imsave(im);
    
%   adding noise to spherical projection
    mean = 0.05;
    variance = 0.5;
%     noise_im = imnoise(im,'gaussian',mean,variance);
%     disp(im(150,150));
%     disp(noise_im(length(noise_im),length(noise_im)));
%     return;
    
%   inversion spherical radon transform
    result = isradon(Mf,r,p,x,M1-1,M2-1,N-1,R0);
    figure
    imshow(mat2gray(result));
%    im = image(result);
%    imsave(im);
end
