n_samples = size(A,1);

n_comps = (n_samples-1)*n_samples/2;
Pval = zeros(n_comps,3);
counter = 1;

for i = 1:n_samples
    for j = i+1 : n_samples
        Pval(counter,1) = i;
        Pval(counter,2) = j;
        
        [~,Pval(counter,3)] = fishertest(A([i,j],:));
        
        Pval(counter,3) = Pval(counter,3) * n_comps;
        
        counter = counter + 1;
    end
end