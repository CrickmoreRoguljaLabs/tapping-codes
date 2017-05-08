%% Input (temporary)
% N and probability
C = [47, 12.2];

% Experimental R_sqaured
R2_emp = 0.996;

%%
% Number of iterations
nitr = 100000;

% Initiate matrices to store R_squared and courtship probability values
R2_mat = zeros(nitr, 1);
CP_mat = zeros(nitr, 1);

% Iniaite a vector to store trials with infinite values
infvec = zeros(nitr,1);

tic

for i = 1 : nitr

    % Flip coins with the same probability
    B = rand(C(1),4) <= (C(2)/100);

    % Sum and linearize the data
    A = sum(double(cumsum(B,2)>0));
    B2 = -log(1-A/C(1));

    % Use the non-infinite points
    X_f = find(~(A==C(1)));
    B_f = B2(~(A==C(1)));

    % Calculate the slope and the Y-values from the fit
    slope = X_f'\B_f';
    Bcalc = X_f * slope;

    % Calculate R_squared values and the courtship probabilities
    R2_mat(i) = 1 - sum((B_f - Bcalc).^2)/sum((B_f - mean(B_f)).^2);
    CP_mat(i) = 1 - exp(-slope);

    % Flag if infinite
    if A(4) == C(1)
        infvec(i) = 1;
    end
end

toc


% Calcualte pvalue given the coin flip model
pvalue = sum(R2_mat >= R2_emp)/nitr

% Say how many trials have infinite values
sum(infvec)

