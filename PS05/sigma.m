function sig = sigma(S,f)
%SIGMA Summary of this function goes here
%INPUT DESIRED SNR AND IMAGE f
%COMPUTE THE CORRESBONDING SIGMA.

[fx,fy] = size(f);
fnorm = sum(f(1:end).^2);
sig2 = fnorm/fx/fy/10^(S/10);
sig = sig2^0.5;

end

