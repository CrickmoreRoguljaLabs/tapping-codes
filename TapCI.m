function CI_mat = TapCI(input_matrix)
% TapCI uses the bootstrap method to calculates the 95% confidence interval
% of courtship probabilities given the innitiation data in input_matrix.
%
% The input matrix is a n-by-5 array where n is the number of genotypes to 
% be simulated. The first column is the total number of flies, while the 
% next 4 are the cumulative number of courtship initiations after 1-4 taps. 
%
% The output matrix has three column: actual_CI, lower_bound, upper_bound.
%
% CI_mat = TapCI(input_matrix)

% Number of genotypes
ngenos = size(input_matrix,1);

% Initiatlize X
taps = 1 : 4;

% Turn input data into fractions
IM_f = input_matrix(:,2:end)./repmat(input_matrix(:,1),[1 4]);

% Linearlize input matrix
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
% Initiate confidence interval matrix
CI_mat = zeros(ngenos, 3);

% First column stores the actual courtship probabilities
CI_mat(:,1) = CPs;

% Number of iterations
nitr = 100000;

tic


% Initiate waitbar
hbar = waitbar(0,'Processing');

for i = 1 : ngenos
    % Update waitbar
    waitbar(i/ngenos)
    
    % Reconstruct binary courtship initiation matrix for this genotype
    flies_n = input_matrix(i,1);
    initiation_mat = zeros(flies_n, 4);
    initiation_mat( 1 : (input_matrix(i,2)), 1) = 1;
    initiation_mat( 1 : (input_matrix(i,3)), 2) = 1;
    initiation_mat( 1 : (input_matrix(i,4)), 3) = 1;
    initiation_mat( 1 : (input_matrix(i,5)), 4) = 1;
    
    % Initiate a vector for courtship probabilities
    CPvec = zeros(nitr, 1);

    for itr = 1 : nitr % Can use parfor here if needed
        % Resample data and liearize (bootstrap)
        ind_1  = randi(flies_n,[input_matrix(i,1),1]);
        data_1 = -log(1 - mean(initiation_mat(ind_1,:)));
        
        % Find non-infinite points (if any) and remove them from the fit
        pts2use = ~isinf(data_1);
        
        % Caculate and store the bootstrapped courtship probabilies.
        CP1 = 1 - exp(-taps(pts2use)' \ data_1(pts2use)');
        CPvec(itr) = CP1;
    end
    
    % Find the top and bottom 2.5% of bootstrapped courtship probabilities
    CPvec_s = sort(CPvec,'descend');
    CI_mat(i, 2) = CPvec_s(round(nitr * 0.975));
    CI_mat(i, 3) = CPvec_s(round(nitr * 0.025));

end

close(hbar)
toc
end


