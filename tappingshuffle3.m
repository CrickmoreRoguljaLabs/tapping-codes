n = 55;
ntotal = 55;
n_entries = 455127; %0-55
% n_entries = 316252; %0-50
CCPmat = zeros(n_entries,4);
Rsq_vec = zeros(n_entries,1);
nanvec = zeros(n_entries,1);
counter = 1;
X = 1 : 4;

hwait = waitbar(0);

tic
for i1 = 0 : n
    waitbar(counter/n_entries);
    for i2 = 0 : (n - i1)
        for i3 = 0 : (n - i1 - i2)
            for i4 = 0 : (n - i1 - i2 - i3)
                tempvec = [i1 i2 i3 i4];
                CCPmat(counter,:) = cumsum(tempvec);
                B2 = -log(1-CCPmat(counter,:)/ntotal);
                
                X_f = find(~(CCPmat(counter,:) == ntotal));
                B_f = B2(~(CCPmat(counter,:) == ntotal));
                              
                slope = X_f'\B_f';
                Bcalc = X_f * slope;
                Rsq_vec(counter) = 1 - sum((B_f - Bcalc).^2)/sum((B_f - mean(B_f)).^2);

                counter = counter + 1;
            end
        end
    end
end
t_run = toc
samplepersec= 1/(t_run/counter);
Rsq_vec = Rsq_vec(1:counter);

close(hwait)
%%
threshold = 0.995





sum(Rsq_vec > threshold)/445112


%%
Rsq_vec(isinf(Rsq_vec)) = NaN;
%%
hist(Rsq_vec,10000);

%%
Rsq_vec_01 = Rsq_vec(Rsq_vec>=0);
hist(Rsq_vec_01,5000)

%%
n_entries = size(CCPmat50,1);
Rsq_vec50 = zeros(n_entries,1);
X = 1 : 4;

for i = 1: n_entries
    B2 = -log(1-CCPmat50(i,:)/ntotal);
    slope = X'\B2';
    Bcalc = X * slope;
    Rsq_vec50(i) = 1 - sum((B2 - Bcalc).^2)/sum((B2 - mean(B2)).^2);
end
%%
Rsq_vec50_01 = Rsq_vec50(Rsq_vec50>=0);
hist(Rsq_vec50_01,200)
