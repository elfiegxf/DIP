function  imgDenoised  =   NLEM(imgNoisy, h, P, S)
%function for denoising images using Non-Local Euclidean Medians, where top 50% of the 
% neighboring patches corresponding to the largest weights are used.
%
% imgNoisy : noisy image
% h        : Gaussian width
% P        : half-size of patch (e.g., P = 3)
% S        : half-search window (e.g., S = 10)
%
% imgDenoised : denoised image using NLEM_kNN
%
% Reference:
%
% K. N. Chaudhury and A. Singer, "Non-Local Euclidean Medians", IEEE Signal
% Processing Letters, vol. 19, no. 11, 2012.

[m, n] = size(imgNoisy);

N  = 2*P + 1;
h2 = h * h;

kNN = ceil ( (2*S + 1)^2 / 2 ); % top 50% of the neighbors used 

imgPad  = padarray(imgNoisy, [P P], 'symmetric');

imgDenoised = zeros(m,n);

fprintf('Looping over pixels....\n');
for i = 1 : m 
    ii = i + P;
    for j = 1 : n
        jj = j + P;
        
        patchRef = imgPad(ii - P : ii + P, jj - P : jj + P);  
        
        pmin = max(i - S, 1) + P;
        qmin = max(j - S, 1) + P;
        pmax = min(i + S, m) + P;
        qmax = min(j + S, n) + P;
        
        s1 = pmax - pmin + 1;
        s2 = qmax - qmin + 1;
        
        w  =  zeros(s1, s2);
        neighborPatches =  zeros(s1, s2, N^2);
        patchCurrent    =  zeros(2*P + 1, 2*P + 1);
        patch           =  zeros(N, N);  %#ok<*NASGU>
        
        u = 0;
        for p = pmin : pmax
            u = u + 1;
            v = 0;
            for q = qmin : qmax
                v = v + 1;
                patchCurrent = imgPad(p - P : p + P, q - P : q + P);
                d2 = sum(sum( (patchRef - patchCurrent) ...
                    .* (patchRef - patchCurrent) ));
                w(u, v)  =  exp(- d2 / h2);
                patch  =  imgPad(p - P : p + P, q - P : q + P);
                neighborPatches(u, v, :) = reshape(patch, [N^2  1]);
            end
        end
        
        % sort weights
        w  = reshape(w, [s1*s2  1]);
        [w , I] = sort(w, 'descend');
        
        L = min(kNN, s1*s2);  
        
        f       =  reshape(neighborPatches, [s1*s2   N^2])';
        median  =  findEuclideanMedian(f(: , I(1 : L)), w(1 : L));
        patch_est  =  reshape(median, [N  N]);
        imgDenoised(i, j) =  patch_est(P + 1, P + 1);
    end
end
