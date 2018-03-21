function F = MSE( f_hat, f)
%MSE Summary of this function goes here
% INPUT: f_hat IS THE DENOISING PROCEDURE OF f. 
%        f IS THE ORIGINAL IMAGE WITHOUT NOISE.
% OUTPUT: F IS THE 
[fx,fy] = size(f);
diff = (f_hat-f);
F = sum(diff(1:end).^2)/fx/fy;

end

