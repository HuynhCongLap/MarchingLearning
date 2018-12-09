RGB = imread('lena.jpg');
RGB = double(RGB);
I1 = RGB(:,:,1);
I2 = RGB(:,:,2);
I3 = RGB(:,:,3);

[w,d] = size(I1);

K = 10;

mean_R = EM(K,I1);
mean_G = EM(K,I2);
mean_B = EM(K,I3);

colors = [];
for e=1:K
    colors = [colors 256*rand(3,1)];
end

mean = [mean_R; mean_G; mean_B];
fprintf("Done Algo - Assign image step\n")
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


