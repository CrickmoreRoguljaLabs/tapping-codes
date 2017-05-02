ngenos = size(A,1);
taps = 1 : 4;


A2 = A(:,2:end)./repmat(A(:,1),[1 4]);
A3 = -log(1-A2);
CPs = zeros(ngenos,1);

for i = 1 : ngenos
    pts2use = sum(A3(i,:) ~= 1);
    CPs(i) = 1 - exp(-taps(1:pts2use)' \ A3(i, 1 : pts2use)');
end

%%
CImat = zeros(ngenos, 3);
CImat(:,1) = CPs;

nitr = 100000;

tic
hbar = waitbar(0,'Processing');
for i = 1 : ngenos
    
    waitbar(i/ngenos)
    
    flies_n = A(i,1);

    actualdata = zeros(flies_n, 4);
    actualdata( 1 : (A(i,2)), 1) = 1;
    actualdata( 1 : (A(i,3)), 2) = 1;
    actualdata( 1 : (A(i,4)), 3) = 1;
    actualdata( 1 : (A(i,5)), 4) = 1;

    CPvec = zeros(nitr, 1);

    parfor itr = 1 : nitr
        ind_1  = randi(flies_n,[A(i,1),1]);
        data_1 = -log(1 - mean(actualdata(ind_1,:)));

        pts2use = ~isinf(data_1);
        CP1 = 1 - exp(-taps(pts2use)' \ data_1(pts2use)');
        CPvec(itr) = CP1;
    end

    CPvec_s = sort(CPvec,'descend');
    CImat(i, 2) = CPvec_s(round(nitr * 0.975));
    CImat(i, 3) = CPvec_s(round(nitr * 0.025));

end


close(hbar)
toc


