function [F] = synthesis(f1,f2,f3,f4,g0,g1)
%THIS FUNCTION BUILDS CODE FOR A 2D  INVERSE WAVELET TRANSFORM. 
%CREATED BY XIAOFEI GUO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT: f1: N COARSE SCALE APPROXIMATION OF THE ORIGINAL IMAGE.
%       f2: N VERTICAL
%       f3: N HORIZONTAL 
%       f4: N DETAILED IMAGES,. 
%       g0 IS A LOW PASS SYNTHESIS FILTER, g1 IS A HIGH PASS SYNTHESIS
%       FILTER.
%NOTE THAT g0 AND g1 BOTH ARE VECTORS.f1~f4 ARE CELL ARRAY WITH FIRST 
%     DIMENSION 1.
%OUTPUT: RECONSTRUCTED FINE SCALE IMAGE

% whether inputs are cells
if (~iscell(f1))
    fc1 = cell(1,1);
    fc1{1,1} = f1;
    f1 = fc1;
end

if (~iscell(f2))
    fc2 = cell(1,1);
    fc2{1,1} = f2;
    f2 = fc2;
end

if (~iscell(f3))
    fc3 = cell(1,1);
    fc3{1,1} = f3;
    f3 = fc3;
end

if (~iscell(f4))
    fc4 = cell(1,1);
    fc4{1,1} = f4;
    f4 = fc4;
end

% Initialization.
[Nx,Ny] = size(f1);
N = max(Nx,Ny);

% store the sizes of each layer 
sx = zeros(N+1,2);
    for k = 1:N
     sx(k+1,:) = size(f1{1,k});
    end
    
sx(1,:) = sx(2,:)*2;

%ensure the filter format
[x,y] = size(g0);
[x1,y1] = size(g1);
L = max(x,y);

if(x == 1)
    g0 = g0';
end

if(x1 == 1)
    g1 = g1';
end

% create a cell array to store result.
F = cell(1,N+1);
F{1,N+1} = f1{1,N};

% create loop to synthesis pics
for i = N:-1:1

    % input is F{1,i+1} and the result will go to F{1,i}
    % creates cell arrays where the elements are the cols of pics
    F{1,i+1} = num2cell(F{1,i+1},1);
    f2{1,i} = num2cell(f2{1,i},1);
    f3{1,i} = num2cell(f3{1,i},1);
    f4{1,i} = num2cell(f4{1,i},1);
    
    % upsample
    F{1,i+1} = cellfun(@(x) upsample(x,2), F{1,i+1},'UniformOutput', false);
    f2{1,i} = cellfun(@(x) upsample(x,2), f2{1,i},'UniformOutput', false);
    f3{1,i} = cellfun(@(x) upsample(x,2), f3{1,i},'UniformOutput', false);
    f4{1,i} = cellfun(@(x) upsample(x,2), f4{1,i},'UniformOutput', false);
      
    % filter them
    F{1,i+1} = cellfun(@(x) real(ifft(fft(x).*fft(g0,sx(i,1)))),F{1,i+1}, 'UniformOutput', false);
    f2{1,i} = cellfun(@(x) real(ifft(fft(x).*fft(g1,sx(i,1)))),f2{1,i}, 'UniformOutput', false);
    f3{1,i} = cellfun(@(x) real(ifft(fft(x).*fft(g0,sx(i,1)))),f3{1,i}, 'UniformOutput', false);
    f4{1,i} = cellfun(@(x) real(ifft(fft(x).*fft(g1,sx(i,1)))),f4{1,i}, 'UniformOutput', false);
    
    %add two
    temph01 =cell2mat(F{1,i+1}) + cell2mat(f2{1,i});
    temph02 = cell2mat(f3{1,i}) + cell2mat(f4{1,i});
    
    %transeform col cells into row cells
    temph01 = num2cell(temph01,2);
    temph02 = num2cell(temph02,2);
    
    %upsample
    temph01 = cellfun(@(x) upsample(x,2), temph01,'UniformOutput', false);
    temph02 = cellfun(@(x) upsample(x,2), temph02,'UniformOutput', false);
     %again process rows. 
    temph01 = cellfun(@(x) real(ifft(fft(x).*fft(g0',sx(i,2)))),temph01, 'UniformOutput', false);
    temph02 = cellfun(@(x) real(ifft(fft(x).*fft(g1',sx(i,2)))),temph02, 'UniformOutput', false);
    F{1,i} = cell2mat(temph01) + cell2mat(temph02);
    %shift
    F{1,i} = circshift(F{1,i},[-L+1,-L+1]);
end
F = F{1,1};

end

