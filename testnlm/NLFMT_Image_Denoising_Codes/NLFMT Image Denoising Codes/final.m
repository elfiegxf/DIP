

%%% NL-means Filter Parameters.
ksize=7;    %%% Neighbor Window Size (should be odd).7
ssize=21;   %%% Search Window Size (should be odd).21
sigmas=5;   %%% Sigma for Gaussian Kernel Generation.5
x = rgb2gray(baboon);
figure,imshow(x),colormap gray;
%%% Gaussian Noise addition.
mean_val=0;
noise_std=10; %% 10,20,30,40,50.
sizeA = size(x);
randn('seed',212096); %%% Results depend on 'seed' of the random noise.
xn = double(x) + (noise_std*randn(sizeA)) + mean_val;
xn = max(0,min(xn,255));

%%% PSNR Computation of Noisy Image.
xn_mse=sum(sum((double(x)-double(xn)).^2))/(M*N)
xn_psnr=10*log10(255^2./xn_mse)
B1 = medfilt2(xn);
B2 = imgaussfilt(xn ,sigmas);
B3 = bilateral(xn,7,10,13);
xn_mse1=sum(sum((double(x)-double(B2)).^2))/(M*N)

xn_mse2=sum(sum((double(x)-double(B1)).^2))/(M*N)
xn_mse3=sum(sum((double(x)-double(B3)).^2))/(M*N)

xn_psnr=10*log10(255^2./xn_mse)

%figure,imagesc(B),colormap gray;
%title('Gaussian Filtering');
%title('Bilateral Filtering');
%title('Median Filtering');



