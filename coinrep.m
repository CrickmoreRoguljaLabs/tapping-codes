nitr = 100000;
R2_mat = zeros(size(C,1), nitr);
CP_mat = zeros(size(C,1), nitr);

tic

hwait = waitbar(0, 'Calculating');

for ii = 1 : size(C,1)
 
waitbar(ii/size(C,1))



parfor i = 1 : nitr
    
    ntotal = C(ii,1);
    

    B = rand(ntotal,4) <= (C(ii,2)/100);
    A = sum(double(cumsum(B,2)>0));

    B2 = -log(1-A/C(ii,1));

    X_f = find(~(A==ntotal));
    B_f = B2(~(A==ntotal));

    slope = X_f'\B_f';
    Bcalc = X_f * slope;

    R2_mat(ii, i) = 1 - sum((B_f - Bcalc).^2)/sum((B_f - mean(B_f)).^2);
    CP_mat(ii, i) = 1 - exp(-slope);
end



end
toc
close(hwait)
%%
R2_mat_sorted = R2_mat;
CP_mat_sorted = CP_mat;
pvec = zeros(size(C,1),1);

for ii = 1 : size(C,1)
    R2_mat_sorted(ii,:) = sort(R2_mat(ii,:));
    CP_mat_sorted(ii,:) = sort(CP_mat(ii,:));
    
%     pvec(ii) = sum(R2_mat_sorted(ii,:) >= C(ii,3))...
%         /(nitr - sum(isnan(R2_mat_sorted(ii,:))) ...
%         - sum(R2_mat_sorted(ii,:) == -Inf));
    
%     if isnan(C(ii,3))
%         pvec(ii) = NaN;
%     end
end

