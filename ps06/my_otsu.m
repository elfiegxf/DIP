function [S, sigw] = my_otsu(I)

% Otsu thrteshold determination
% Input
%   I = input image
% Output
%   S = output segmentation.

% First find image histogram
[nr nc] = size(I);
I = I(:);
imin = min(I);
imax = max(I);
numgray = imax-imin;
N = hist(I,numgray);
N = N(:);


sigw = Inf*ones(length(N),1);
% Loop over all possible threshold values
for idx = 2:length(N)-1
  % Split histogram into two parts at this threshold
  p1 = N(1:idx); p2 = N(idx+1:end);
  % Graylevel values over the two pieces
  i1 = (1:idx)'; i2 = (idx+1:length(N))';
  % Compute individual means and variances
  q1 = sum(p1);  q2 = sum(p2);
  mu1 = sum(i1.*p1)/q1; mu2 = sum(i2.*p2)/q2;
  sig1 = sum((i1-mu1).^2.*p1/q1);
  sig2 = sum((i2-mu2).^2.*p2/q2);
  % Compute weighted variance
  sigw(idx) = q1*sig1 + q2*sig2;
end

[mins minsi] = min(sigw);
% Segment 0 = pixels below threshold
% Segment 1 = pixels exceeding threshold
S = zeros(size(I));
S(I>minsi) = 1;
S = reshape(S,nr,nc);