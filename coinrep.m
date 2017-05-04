%% Input (temporary)
% N and probability
C = [55, 44.2];

% Experimental R_sqaured
R2_emp = 0.995;

%%
% Number of iterations
nitr = 100000;

% Initiate matrices to store R_squared and courtship probability values
R2_mat = zeros(size(C,1), nitr);
CP_mat = zeros(size(C,1), nitr);

% Iniaite a vector to store trials with infinite values
infvec = zeros(nitr,1);

tic

% Initiate waitbar
hwait = waitbar(0, 'Calculating');

for ii = 1 : size(C,1)

    % Update waitbar
    waitbar((ii-1)/size(C,1))

    % Read the n
    ntotal = C(ii,1);

    for i = 1 : nitr

        % Flip coins with the same probability
        B = rand(ntotal,4) <= (C(ii,2)/100);
        
        % Sum and linearize the data
        A = sum(double(cumsum(B,2)>0));
        B2 = -log(1-A/C(ii,1));
        
        % Use the non-infinite points
        X_f = find(~(A==ntotal));
        B_f = B2(~(A==ntotal));

        % Calculate the slope and the Y-values from the fit
        slope = X_f'\B_f';
        Bcalc = X_f * slope;
        
        % Calculate R_squared values and the courtship probabilities
        R2_mat(ii, i) = 1 - sum((B_f - Bcalc).^2)/sum((B_f - mean(B_f)).^2);
        CP_mat(ii, i) = 1 - exp(-slope);
        
        % Flag if infinite
        if A(4) == C(1)
            infvec(i) = 1;
        end
    end
end
toc
close(hwait)

% Calcualte pvalue given the coin flip model
pvalue = sum(R2_mat >= R2_emp)/nitr

% Say how many trials have infinite values
sum(infvec)

