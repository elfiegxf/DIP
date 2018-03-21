%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PS06 MEAN SHIFT SEGMENTATION %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%prob1. 

OUT1= meanshiftseg(f,3,20);
figure; imagesc(OUT1);colormap gray;title('hs = 3, hr = 20');
OUT2= meanshiftseg(f,3,30);
figure; imagesc(OUT2);colormap gray;title('hs = 3, hr = 30');
OUT3= meanshiftseg(f,5,40);
figure; imagesc(OUT3);colormap gray;title('hs = 5, hr = 30');
OUT4= meanshiftseg(f,7,30);
figure; imagesc(OUT4);colormap gray;title('hs = 7, hr = 30');

%from a bunch of pictures obtained from the algorithm, we can see:
%when hs is small, the method will produce small clusters. When hs is big, the method will
%produce larger clusters where the gray values are similiar. When hr is small, 
%this method will produce compact clusters with a small range of appearance.
%when hr is large, the clusters will be larger with a big range.


%problem2.
%picture1
fig1gray = rgb2gray(fig1);
[Mean1,Mask1]=kmeans(fig1gray,3);
figure; imagesc(Mask1);title('pic1 when k = 3');

[Mean2,Mask2]=kmeans(fig1gray,4);
figure; imagesc(Mask2);title('pic1 when k = 4');

[Mean3,Mask3]=kmeans(fig1gray,5);
figure; imagesc(Mask3);title('pic1 when k = 5');

fig2gray = rgb2gray(fig2);

[Mean3,Mask3]=kmeans(fig2gray,5);
figure; imagesc(Mask3);title('pic2 when k = 5');

[Mean4,Mask4]=kmeans(fig2gray,6);
figure; imagesc(Mask4);title('pic2 when k = 6');

[Mean5,Mask5]=kmeans(fig2gray,7);
figure; imagesc(Mask5);title('pic2 when k = 7');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%As k increases, there are more clusters and more details.
%the textures and the structures are appearant compared to less k. 
%for natural scenes, where the diameters of lens are comparately longer,
%the colors and the shades are separate, this method will give the whole
%picture a fair result where mountains and sky are contoured well.
%However when it comes to the man-made scene, where the diameters of lens
%are shorter, items share similar colors and always follow shades, this
%method seems not function as well as before.

%problem3
[Edge1,thresh1] = edge(fig1gray,'Sobel',0.02);
figure; imagesc(Edge1);title('sobel edge of fig1');
[Edge2,thresh2] = edge(fig1gray,'Prewitt',0.02);
figure; imagesc(Edge2);title('Prewitt edge of fig1');
[Edge3,thresh3] = edge(fig1gray,'Canny',[0.04 0.08],2);
figure; imagesc(Edge3);title('Canny edge of fig1');

[Edge4,thresh4] = edge(fig2gray,'Sobel',0.025);
figure; imagesc(Edge4);title('sobel edge of fig1');
[Edge5,thresh5] = edge(fig2gray,'Prewitt',0.04);
figure; imagesc(Edge5);title('Prewitt edge of fig1');
[Edge6,thresh6] = edge(fig2gray,'Canny');
figure; imagesc(Edge6);title('Canny edge of fig1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I return the thresholds for each edge-finding process, and adjust the
% parameter manually.
% for sober, the edge seems not very continual. The picture lost some flat
% edges. Prewitt can not eliminate noisy edges but contours are more continual.
% Canny works pretty well compared to previous two. it can not only
% eliminte the noise but also find most part of the picture contour.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%prob4.
img = imresize(fig3,[256,500]);
t = [0:0.5:2*pi]';
x = 250 + 10*cos(t);y =  80 + 10*sin(t);
%x = 325 + 10*cos(t);y =  145 + 10*sin(t);

figure(1) ;
imagesc(img);  colormap(gray);  axis image;  axis off;  hold on;
plot( [x;x(1,1)], [y;y(1,1)], 'r', 'LineWidth',2 );  hold off;
%exportfig(gcf,'output_images/snake_input1.eps') ;




h = fspecial( 'gaussian', 20, 1 );
f = imfilter( double(img), h, 'symmetric' );
f = f-min(f(:));  f = f/max(f(:));

figure(2) ;
imagesc(f) ; colormap(jet) ; colorbar ;
axis image ; axis off ;
%exportfig(gcf,'output_images/snake_energy1.eps') ;


% The final position of the snake is shown
% We can see that the boundary is well
% recovered. It is instructive to run the snake evolution for different
% values of the parameters and note how the evolution speed and the final
% shape changes. Start with small changes first; big changes make the
% snake behave in unpredictable ways.

if 1,
  [px,py] = gradient(-f);
  figure(2);
  imagesc(px.^2+py.^2)
  kappa=1/max(abs( [px(:) ; py(:)])) ;
  [x,y]=snake(x,y,1.1,1.1,1*kappa,0.15,px,py,0.1,1,img);
  
  figure(3) ;
  clf ; imagesc(img) ; colormap(gray) ; hold on ;
  axis image ; axis off ;
  plot([x;x(1)],[y;y(1)],'r','LineWidth',2) ; hold off ;
  pause(1)
  %exportfig(gcf,'output_images/snake_output1.eps') ;
  
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The initial position depends on what contour we need to find.
% The external energy is a smoothed version of the image, normalized for
% convenience
% The external force is a negative gradient of the energy.
% We start the snake evolution with alpha=0.1, beta=0.01,
% kappa=0.2, lambda=0.05. and alpha and beta tend to smooth the contour