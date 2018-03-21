function F = meanshiftseg(f,sigma1,sigma2)
%perform MeanShift Clustering of data using a flat kernel
% INPUT
% f: image to be dealt with
% sigma1: spacial kernel size
% sigma2: grayscale kernel size
% OUTPUT 
% F: segment similar clusters.
% Created by Xiaofei Guo

% initialize
hs = floor(sigma1/2);    %spacial resolution
[fv,fh] = size(f);       %size of image 

[Y,X] =  meshgrid(1:fh,1:fv);   % create coordinate matrix
visited_pic = -5 * ones(fv,fh);     % create a picture to store result
y1 = double(f);                 
%Init_R  = ceil(fv*rand);        %random choose a star point 
%Init_C  = ceil(fv*rand);   
%yloc = [Init_R,Init_C];

for i =1:fv
    for j = 1:fh
        yloc = [i,j];
        
   if visited_pic(yloc(1),yloc(2)) == -5

        %loop till converge

    while(1)
    % find neighbors 
    y_old=yloc;
    visited_pic(y_old(1),y_old(2)) = -1;
    ngbX = X - yloc(1);
    ngbY = Y - yloc(2);
    ngbX(abs(ngbX)<=hs) = -1;
    ngbX(ngbX~= -1) = 0;
    ngbX(ngbX~= 0) = 1;
    ngbY(abs(ngbY)<=hs) = -1;
    ngbY(ngbY~= -1) = 0;
    ngbY(ngbY~= 0) = 1;
    loc = ngbX.*ngbY;
    loc (loc>0) = 1;
    loc (loc~=1) = 0;
    
    %compute graylevel
    ygray = y1 - y1(yloc(1),yloc(2));
    ygray(ygray.^2<sigma2^2) = 1;
    ygray(ygray ~= 1) = 0;
    
    if sum(sum(loc.*ygray)) == 0
       break;
    end
    
    yloc(1) = round(sum(sum(X.*loc.* ygray)) / sum(sum(loc.*ygray)));
    yloc(2) = round(sum(sum(Y.*loc.* ygray)) / sum(sum(loc.*ygray)));
    ygray = round(sum(sum(y1.*loc.* ygray)) / sum(sum(loc.*ygray)));
    y1(yloc(1),yloc(2)) = ygray;
    
    visited_pic(i,j) = y1(yloc(1),yloc(2));
    
    if (y_old-yloc)*(y_old-yloc)'<2
         visited_pic(visited_pic== -1) = y1(yloc(1),yloc(2));
        break;
    end

    %if visited_pic(yloc(1),yloc(2)) == -1;
     %   visited_pic(visited_pic <0) = y1(yloc(1),yloc(2));
      %  break;
    %end
    
    end%while1
   
end%if
end
end
F = visited_pic;

    
end

