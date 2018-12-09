function [means, labels] = kmean(K, I)
count = 0;
centroids =  zeros(1,K);

msize = numel(I);
centroids = I(randperm(msize, K));

while size(unique(centroids)) ~= size(centroids)
    centroids = I(randperm(msize, K));
end

 
[m,n] = size(I);
 maps = zeros(m,n);
 
old_mean = zeros(2,K);
new_mean = zeros(1,K);

while not(isequal(new_mean,old_mean))
    count = count + 1;
    mean_map = zeros(2,K);
    old_mean = new_mean;
    
    for r= 1:m
        for c= 1:n
 
           min_index = 1;
           min = abs(centroids(1,1) - I(r,c)); 
         
           for k= 2:K
              distance = abs(centroids(1,k) - I(r,c));
              if  distance < min 
                  min_index = k;
                  min = (abs(centroids(1,k) - I(r,c)));
              end
           end
           
           add_map = zeros(1,K);
           add_map(1,min_index) = I(r,c);
          
           mean_map(1,min_index) =  mean_map(1,min_index)+ 1;
           mean_map(2,min_index) =  mean_map(2,min_index)+I(r,c);
           maps(r,c) = min_index;
           %fprintf('%d and %d\n',r,c);
        end
    end
    new_mean = mean_map;
    for k= 1:K  
    centroids(1,k) = mean_map(2,k)*1.0/mean_map(1,k);
    end
    fprintf('Calculating...Waiting\n');
end
labels = maps;
means = centroids;
fprintf('Convergence after %d loops with %d cluster\n',count,K);
end