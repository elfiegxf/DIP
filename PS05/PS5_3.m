% prob5.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           %
%                H*(u,v)G(u,v)              %
% F  = -----------------------------        %
%        H*(u,v)H(u,v) + theta*sum(Di^2)    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = 256; N = 256;
[M1 N1] = meshgrid(1:M, 1:N);
f = 2*exp(-( (M1-50).^2 + (N1-50).^2/40^2));
h = ones(19); h = h/sum(h(:));
w = 0.3*randn(M,N);
d1 = 0.5*[1 -1];
d2 = d1';

H = fft2(h,M,N);
H_ = conj(fft2(h,M,N));
g = real(ifft2(fft2(f).*H)) + w;
G = fft2(g);

F222 = real(ifft2(fft2(g)./H));
figure;subplot(2,1,1);imagesc(f);colormap gray; title('original picture');
subplot(2,1,2);imagesc(F222);colormap gray; title('IFFT(G) without theta');



%5.3.1
% do not use d.
k=0;
for i = 1e-1:1e-1:2
    k = k+1;
    theta = i;
    F = (H_.*G)./ (abs(H).^2 + theta);
    f_ = ifft2(F);
    error = abs(f_ - f).^2;
    diff(k)=sum(error(1:end));
end
index = min(find(diff == min(diff)));
%%%%%%%%%%%%%%%
%here when theta = 0.9 , the error will be minimum, I will choose theta =2.2
%%%%%%%%%%%%%%%
f2 = real(ifft2((H_.*G)./ (abs(H).^2 + 0.9)));
%shift the result;
figure;subplot(2,1,1);imagesc(g);colormap gray; title('blurred picture');
subplot(2,1,2);imagesc(f2);colormap gray; title(' deblurred picture');


% use d.

D1 = fft2(d1,M,N);
D1_ = conj(fft2(d1,M,N));
D2 = fft2(d2,M,N);
D2_ = conj(fft2(d2,M,N));
k=0;
for i = 110:0.1:116
    k = k+1;
    F = (H_.*G)./ (abs(H).^2 + i*(abs(D1).^2+abs(D2).^2));
    f_ = ifft2(F);
    error = abs(f_ - f).^2;
    dif(k)=sum(sum(error));
end
index = min(find(dif == min(dif)));
%%%%%%%%%%%%%%%
%here after a lot of tries, I got when theta = 115, the error will be minimum.
%%%%%%%%%%%%%%%
f3 = ifft2((H_.*G)./ (abs(H).^2 + 114*(abs(D1).^2+abs(D2).^2)));

figure;subplot(2,1,1);imagesc(g);colormap gray; title('blurred picture');
subplot(2,1,2);imagesc(f3);colormap gray; title(' deblurred picture');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d smoothes the impulse and edge noise of the whole picture 
% while without d averages the whole of the picture;
% I use minimum square error as indication to choose the theta.
