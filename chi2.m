n_samples = size(A,1);

n_comps = (n_samples-1)*n_samples/2;
chisquared = zeros(n_comps,3);
counter = 1;


for i = 1 : (n_samples - 1)
    for j = (i+1) : n_samples
        
        A_sub = [A(i,:);A(j,:)];
        
        B = repmat(sum(A_sub,1),[2,1]);
        C = repmat(sum(A_sub,2),[1,2]);
        total = sum(A_sub(:));

        A_sub2 = B.* C /total;
        
        obs = A_sub(:);
        exp = A_sub2(:);
        
        chisquared(counter,1) = i;
        chisquared(counter,2) = j;
        chisquared(counter,3) = sum((obs-exp).^2./exp);
        
        counter = counter + 1;
    end
end

P = chisquared;
P(:,3)  = (1 - chi2cdf(chisquared(:,3),1)) * n_comps;