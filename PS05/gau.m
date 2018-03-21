function h = gau(t)
% this function implements gaussian filter 
% input is x y and t
% output will be the elements in gaussian filter
D = 1;
X=round (2.5*(2*D*t)^0.5 - 0.5);
Y = X;
for x= -X:X
   for y = -Y:Y
    h(x+X+1,y+Y+1) = (exp(-(x^2+y^2)/(2*2*D*t))/(2*pi*2*D*t));
   end
end
end

