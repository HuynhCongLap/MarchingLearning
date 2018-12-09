RGB = imread('flower1.jpg');
I = rgb2gray(RGB);
I = double(I);
RGB = double(RGB);

K = 7; % K clusters

colors = [];

for e=1:K
    colors = [colors 256*rand(3,1)];
end

[centroids, maps] = kmean(K,I);

[mm, nn] = size(maps);
 for r= 1:mm
  for c= 1:nn
    RGB(r,c,:) = colors(:,maps(r,c));
  end
 end
 
figure;
imshow(uint8(RGB));




 

 
    
