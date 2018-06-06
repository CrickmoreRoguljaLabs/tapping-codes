function P_mat = TapHyp(input_matrix)
% TapHyp uses the bootstrap method to calculates the p-values between pairs
% of courtship initiation data, with the null-hypothesis that the two
% samples have exactly the same courtship probability. When comparing more
% than 1 pair of samples, the code uses the Bonferroni correction to adjust
% for multiple comparisons.
%
% The input matrix is a n-by-5 array where n is the number of genotypes to 
% be simulated. The first column is the total number of flies, while the 
% next 4 are the cumulative number of courtship initiations after 1-4 taps.
% 
% The output matrix has three column: index of the first sample, index of 
% the second sample, p-value.
%
% P_mat = TapHyp(input_matrix)

% The number of genotypes
ngenos = size(A,1);

% Caculate the number of comparisons
ncomps = sum(1:(ngenos-1));

% Generate taps
taps = 1 : 4;

% Convert input data into fractions
IM_f = input_matrix(:,2:end)./repmat(input_matrix(:,1),[1 4]);

% Linearize the data
IM_3 = -log(1-IM_f);

% Initiate a vector to store experimental courtship probabilities
CPs = zeros(ngenos,1);

for i = 1 : ngenos
    % Find points where not all flies have started courtship (i.e. points
    % with no infinities).
    pts2use = sum(IM_3(i,:) ~= 1);
    
    % Calculate courtship probabilities
    CPs(i) = 1 - exp(-taps(1:pts2use)' \ IM_3(i, 1 : pts2use)');
end

%% Simulation
% Initiate a matrix to store the p values
P_mat = zeros(ncomps, 3);

% Initiate the counter
counter = 1;

% Number of iterations
nitr = 100000;

tic

% Initiate the waitbar
hbar = waitbar(0);
for i = 1 : ngenos
    for j =  (i+1) : ngenos
        % Update the waitbar
        waitbar((counter-1)/ncomps)
        
        % Store the indices of the genotypes that are compared
        P_mat(counter, 1) = i;
        P_mat(counter, 2) = j;
        
        % Pool the initiation data together, so they can be boostrapped
        pooled_n = A(i,1) + A(j,1);
        
        % Generate a pooled, binary initiation matrix
        pooleddata = zeros(pooled_n, 4);
        pooleddata( 1 : (A(i,2) + A(j,2)), 1) = 1;
        pooleddata( 1 : (A(i,3) + A(j,3)), 2) = 1;
        pooleddata( 1 : (A(i,4) + A(j,4)), 3) = 1;
        pooleddata( 1 : (A(i,5) + A(j,5)), 4) = 1;
        
        % Initiate a vector to store the difference in courtship
        % probabilities
        diffvec = zeros(nitr, 1);
        
        for itr = 1 : nitr % Can use parfor here
            % Resample two datasets (bootstrap)
            ind_1  = randi(pooled_n,[A(i,1),1]);
            ind_2  = randi(pooled_n,[A(j,1),1]);
            
            % Linearize the bootstrapped datasets
            data_1 = -log(1 - mean(pooleddata(ind_1,:)));
            data_2 = -log(1 - mean(pooleddata(ind_2,:)));
            
            % Remove infinities (where all flies have started courtship)
            % and calculate courtship probabilities
            pts2use = ~isinf(data_1);
            CP1 = 1 - exp(-taps(pts2use)' \ data_1(pts2use)');
            
            % Remove infinities (where all flies have started courtship)
            % and calculate courtship probabilities
            pts2use = ~isinf(data_2);
            CP2 = 1 - exp(-taps(pts2use)' \ data_2(pts2use)');
            
            % Calculate and store the difference in courtship probabilities
            diffvec(itr) = CP1 - CP2;
        end
        
        % Calculate two-tailed p-values, which is defined as the fraction
        % of iterations where the bootstrapped CP differences are at least
        % as large as the experimental ones
        P_mat(counter, 3) = sum(abs(diffvec) >= abs(CPs(i) - CPs(j)))/nitr;
        
        % Update counter
        counter = counter  + 1;
    end
end

% Adjust for multiple comparisons (Bonferroni)
P_mat(:,3) = P_mat(:,3) * ncomps;

close(hbar)
toc

end
