ngenos = size(A,1);
ncomps = sum(1:(ngenos-1));
taps = 1 : 4;


A2 = A(:,2:end)./repmat(A(:,1),[1 4]);
A3 = -log(1-A2);
CPs = zeros(ngenos,1);

for i = 1 : ngenos
    pts2use = sum(A3(i,:) ~= 1);
    CPs(i) = 1 - exp(-taps(1:pts2use)' \ A3(i, 1 : pts2use)');
end

%%
Pmat = zeros(ncomps, 3);
counter = 1;
nitr = 100000;

tic
hbar = waitbar(0);
for i = 1 : ngenos
    for j =  (i+1) : ngenos
        waitbar((counter-1)/ncomps)
        
        Pmat(counter, 1) = i;
        Pmat(counter, 2) = j;
        
        pooled_n = A(i,1) + A(j,1);
        
        
        pooleddata = zeros(pooled_n, 4);
        pooleddata( 1 : (A(i,2) + A(j,2)), 1) = 1;
        pooleddata( 1 : (A(i,3) + A(j,3)), 2) = 1;
        pooleddata( 1 : (A(i,4) + A(j,4)), 3) = 1;
        pooleddata( 1 : (A(i,5) + A(j,5)), 4) = 1;
        
        diffvec = zeros(nitr, 1);
        
        parfor itr = 1 : nitr
            ind_1  = randi(pooled_n,[A(i,1),i]);
            ind_2  = randi(pooled_n,[A(j,1),i]);

            data_1 = -log(1 - mean(pooleddata(ind_1,:)));
            data_2 = -log(1 - mean(pooleddata(ind_2,:)));
            
            pts2use = sum(data_1 ~= 1);
            CP1 = 1 - exp(-taps(1:pts2use)' \ data_1(1 : pts2use)');
            
            pts2use = sum(data_2 ~= 1);
            CP2 = 1 - exp(-taps(1:pts2use)' \ data_2(1 : pts2use)');
            
            diffvec(itr) = CP1 - CP2;
        end
        
        Pmat(counter, 3) = sum(abs(diffvec) >= abs(CPs(i) - CPs(j)))/nitr;
        
        counter = counter  + 1;
    end
end

% Adjust for multiple comparisons
Pmat(:,3) = Pmat(:,3) * ncomps;

close(hbar)
toc


Pmat
