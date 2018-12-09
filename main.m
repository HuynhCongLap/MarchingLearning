RGB = imread('flower1.jpg');
I = rgb2gray(RGB);
I = double(I);
RGB = double(RGB);


fid = fopen('gmm3d.asc', 'r');
if fid == -1, error('Cannot open file: %s', 'gmm3d.asc'); end
data3d = fscanf(fid, '%g', [3, Inf]).';
fclose(fid);

fid = fopen('gmm2d.asc', 'r');
if fid == -1, error('Cannot open file: %s', 'gmm2d.asc'); end
data2d = fscanf(fid, '%g', [2, Inf]).';
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% K mean - segment color image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = 7; % K clusters
colors = []; 

for e=1:K
    colors = [colors 256*rand(3,1)];
end % random colors to affect the image after label.

[centroids, maps] = kmean(K,I); % using K means, maps will contain matrix label of cluster

[mm, nn] = size(maps); % using the matrix label, segment the image by affecting colors, this
 for r= 1:mm % step can be take time, if the image is so big resolution
  for c= 1:nn
    RGB(r,c,:) = colors(:,maps(r,c));
  end
 end
 
figure;
imshow(uint8(RGB)); % show segmented image by k means

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EM algo - Segment colors iamge%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I1 = RGB(:,:,1); % EM with Red channel
I2 = RGB(:,:,2); % EM with Green channel
I3 = RGB(:,:,3); % EM with Blue channel

[w,d] = size(I1);

K = 3; % K cluster
epshiron = 0.5; % using epshiron to stop algo instead of condition: old data = new data
% because the precision floating point of matlab is bad. ex: 26.679 = 26.679 doesn't
% work here. they are not equal, comparing in matlab

mean_R = EM(K,I1,epshiron); % optimal values after do EM - red channel
mean_G = EM(K,I2,epshiron); % ... - green channel
mean_B = EM(K,I3,epshiron); % ... - blue channel

colors = [];
for e=1:K
    colors = [colors 256*rand(3,1)];
end

mean = [mean_R; mean_G; mean_B];
fprintf("Done Algo - Assign image step - Please wait to affect colors to image\n")
for r=1:w
    for c=1:d
        pixel = [RGB(r,c,1) RGB(r,c,2) RGB(r,c,3)];
        X = [mean(:,1).' ; pixel];
        min = pdist(X,'euclidean');
        index = 1;
        for e=2:K
            X = [mean(:,e).' ; pixel];
            distance = pdist(X,'euclidean');
            if min > distance
                min = distance;
                index = e;
            end
        end
        
        RGB(r,c,:) = colors(:,index);
     end
end

figure;
imshow(uint8(RGB));



 

 
    
