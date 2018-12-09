function [vars] = EM(K,I,epshiron)
[m n] = size(I);
likelihood = zeros(m,n,K);

mean = 50;
sigma1 = 10;

total = zeros(m,n);
weight = zeros(m,n,K);

for i=1:K
    likelihood(:,:,i) = normpdf(I,mean + i*5, sigma1 + i*2);
    total = total + likelihood(:,:,i);
end

for i=1:K
    weight(:,:,i) = likelihood(:,:,i) ./ total;
end

old_means = ~zeros(1,K);
new_means = zeros(1,K);
new_vars = zeros(1,K);
old_vars = ~zeros(1,K);

count = 0;
while 1
    e = 0;
    for t=1:K
        e = e + abs(new_means(1,t) - old_means(1,t));
        e = e + abs(new_vars(1,t) - old_vars(1,t));
    end
    if(e < epshiron)
        break;
    end
    
    
    old_means = new_means;
    old_vars = new_vars;
    
    sum_mean_k = zeros(1,K);
    sum_var_k = zeros(1,K);
 
    fprintf("numbers of loop: %d\n", count);
    if (new_means ~= zeros(1,K))
        total = zeros(m,n);
        for  e=1:K
          likelihood(:,:,e) = normpdf(I,new_means(1,e), new_vars(1,e));
          total = total + likelihood(:,:,e);
        end
        
        for e=1:K
            weight(:,:,e) = likelihood(:,:,e) ./ total;
        end
    end
    
    for r= 1:m
        for c= 1:n
            for e=1:K
                sum_mean_k(1,e) = sum_mean_k(1,e) + I(r,c)*weight(r,c,e);
            end
        end
    end

    for e=1:K
        w = weight(:,:,e);
        new_means(1,e) = sum_mean_k(1,e) / sum(w(:));
    end
    for r= 1:m
        for c= 1:n
            
            for e=1:K
                var = (I(r,c)- new_means(1,e))*(I(r,c)- new_means(1,e));
                sum_var_k(1,e) = sum_var_k(1,e)  + var*weight(r,c,e);
            end
        end
    end

     for e=1:K
         w = weight(:,:,e);
         new_vars(1,e) = sqrt(sum_var_k(1,e) / sum(w(:)));
     end
    
     for e=1:K
        %fprintf("%f %f\n",new_means(1,e),old_means(1,e));
     end
     count = count +1;
    fprintf("-------------------------------------\n");
end

    vars = new_means;
end

