function ISRadonExample

    %I = transpose(double(rgb2gray(imread('images\QuateredHat256.png','png'))));
    %I = transpose(double(rgb2gray(imread('images\WhiteEllipse256.png','png'))));
    %I = transpose(double(rgb2gray(imread('images\Test300.png','png'))));
    I = transpose(double(rgb2gray(imread('images\MyTest300.png','png'))));
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
    x1 = meshgrid((-0.5:1/(N-1):0.5),(-0.5:1/(N-1):0.5));
    x2 = transpose(meshgrid((-0.5:1/(N-1):0.5),(-0.5:1/(N-1):0.5)));
    x(:,:,1) = x1;
    x(:,:,2) = x2;
    
%   вычисление Mf(p_k, r_m) 
    Mf = sradon1(I,p,r,x,N,M1,M2);
    imshow(Mf)
    im = image(Mf);
    imsave(im);
    %Mf = double(rgb2gray(imread('images\QuateredHatResult128.png','png')));
    %Mf = double(rgb2gray(imread('images\result1.png','png')));
    
    result = isradon(Mf,r,p,x,M1-1,M2-1,N-1,0.5)
    imshow(result)
    im = image(result);
    imsave(im);
end
