function F  = SNR(f,sigma)
%SNR Summary of this function goes here
% f IS THE NOISY IMAGE.
% SIGMA IS THE STANDARD DEVIATION OF THE NOISE.
% F IS THE STANDARD DEVIATION OF THE NOISE.
[fx,fy] = size(f);
fnorm = sum(f(1:end).^2);
F = 10*log10(fnorm/fx/fy/sigma^2);
end