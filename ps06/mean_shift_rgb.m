function z=mean_shift_rgb(f,hs,hr)
% In order to run this function perfectly, please do not choose a big
% neighbourhood and a big hr at the same time, because of the edge
f=double(f);
[q,w,k]=size(f); % to see how many variables in f
z=zeros(q,w,k);  % creat a zero matrix to put output value
for index=1:k    % deal with different colors
    image=f(:,:,index);
[X,Y]=size(image);
% x location (like meshgrid)
for i=1:X
    for j=1:Y
    r(i,j)=i;
    end
end
% y locaition (like meshgrid)
for i=1:X
    for j=1:Y
    c(i,j)=j;
    end
end
f1=padarray(image,[hs,hs]); % deal with edges
r1=padarray(r,[hs,hs]); % deal with edges
c1=padarray(c,[hs,hs]); % deal with edges

for idx1=1:X
    for idx2=1:Y
        x1=idx1;y1=idx2;
        while(1)
   v_p=f1(x1:x1+2*hs,y1:y1+2*hs); % pick the box centered at (x1,y1), will change each iteration
   r_p=r1(x1:x1+2*hs,y1:y1+2*hs); 
   c_p=c1(x1:x1+2*hs,y1:y1+2*hs); 
   judge=(abs(v_p-v_p(hs+1,hs+1))<hr); % to see which pixel is in range hr
   nx=sum(sum(judge));             % number of pixel that counts
   grayvalue=round(sum(sum(v_p.*judge))/nx); % average the features of pixels which are in hr
   x1=round(sum(sum(r_p.*judge))/nx);
   y1=round(sum(sum(c_p.*judge))/nx);
   f1(x1+hs,y1+hs)=grayvalue;
       if (v_p(hs+1,hs+1)==grayvalue)            % keep running until convergence
           z(idx1,idx2,index)=grayvalue;break;
       end;
         end;
    end;
end;
end;
z=uint8(z);