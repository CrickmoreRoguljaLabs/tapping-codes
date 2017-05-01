ngroups = round(size(B,2)/5);
multiCPs = zeros(ngroups,5);

for ii = 1 : ngroups
    A = B(:,((ii-1)*5+1):((ii-1)*5+5));
    N = find(sum(A,2)>0,1,'last');
    A = A(1:N, :);
    CPanalysis
    multiCPs(ii,:) = [N, Rsquared, CP*100, CP_CI(1)*100, CP_CI(2)*100];
end

close all

multiCPs(:,2)