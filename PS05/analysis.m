
function [F1,F2,F3,F4] = analysis(f, h0, h1, N)

%THIS FUNCTION BUILDS CODE FOR A 2D WAVELET TRANSFORM.
%CREATED BY XIAOFEI GUO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT: AN IMAGE, TWO FILTERS(A LOW PASS, h0 AND A HIGH PASS h1), AND N,  
%       THE NUMBER OF SCALES TO PROCESS.
%NOTE:h0 IS A VECTOR, SO IS h1.
%OUTPUT:N HORIZONTAL, N VERTICAL AND N DETAILED IMAGES, N COARSE SCALE
%       APPROXIMATION OF THE ORIGINAL IMAGE.


% Initialization.
% input the sizes of sub-cells.
[fx,fy] = size(f);
f = imresize(f,2^ceil(log2(max(fx,fy)))/max(fx,fy));

sx = zeros(N+1,2);
for k = 1:N+1
   sx(k,:) = size(f)/2^(k-1);
end

[x,y] = size(h0);
[x1,y1] = size(h1);

if(y == 1)
    h0 = h0';
end

if(y1 == 1)
    h1 = h1';
end

%create cells to save the results.
%F1 will be the coarse-scale approximation images.
%F2 will be the horizontal ones
%F3 will be the vertical ones
%F4 will be the detail ones.

F1 = cell(1,N+1);
F2 = cell(1,N);
F3 = cell(1,N);
F4 = cell(1,N);

F1{1,1} = double(f);

%processing loop
for i = 1:N
    % input is F{1,i} and the result will goes to F1 F2 F3 F4
    
    imagerow = num2cell(F1{1,i},2);
    
    % creates a cell array where the elements are the rows of A
    temph01 = cellfun(@(x) real(ifft(fft(x).*fft(h0,sx(i,2)))),imagerow, 'UniformOutput', false);
    temph02 = cellfun(@(x) real(ifft(fft(x).*fft(h1,sx(i,2)))),imagerow, 'UniformOutput', false);
    
    % desample
    temph01 = cellfun(@(x) x(1:2:end), temph01,'UniformOutput', false);
    temph02 = cellfun(@(x) x(1:2:end), temph02,'UniformOutput', false);
     
    %transeform row cells into col cells
    temph01 = num2cell(cell2mat(temph01),1);
    temph02 = num2cell(cell2mat(temph02),1);
    
     %again process cols. 
     F1{1,i+1} =cellfun(@(x) real(ifft(fft(x).*fft(h0',sx(i,1)))),temph01, 'UniformOutput', false);
     F1{1,i+1} = cellfun(@(x) x(1:2:end), F1{1,i+1},'UniformOutput', false);
     F1{1,i+1} = cell2mat(F1{1,i+1});
     
     F2{1,i} = cellfun(@(x) real(ifft(fft(x).*fft(h1',sx(i,1)))),temph01, 'UniformOutput', false);
     F2{1,i} = cellfun(@(x) x(1:2:end), F2{1,i},'UniformOutput', false);
     F2{1,i} = cell2mat(F2{1,i});
     
     F3{1,i} = cellfun(@(x) real(ifft(fft(x).*fft(h0',sx(i,1)))),temph02, 'UniformOutput', false);
     F3{1,i} = cellfun(@(x) x(1:2:end), F3{1,i},'UniformOutput', false);
     F3{1,i} = cell2mat(F3{1,i});
     
     F4{1,i} = cellfun(@(x) real(ifft(fft(x).*fft(h1',sx(i,1)))),temph02, 'UniformOutput', false);
     F4{1,i} = cellfun(@(x) x(1:2:end), F4{1,i},'UniformOutput', false);
     F4{1,i} = cell2mat(F4{1,i});
end


F5 = cell(1,N);
for i = 1:N
    F5{1,i} = F1{1,i+1};
end

F1 = F5;
end



