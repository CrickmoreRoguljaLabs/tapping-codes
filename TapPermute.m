% number of flies
n = 55;

% Empirical R square
R2_emp = 0.995;

% Determine how many iteractions of simulation is needed (up to for 100 flies)
n_entries_vec = cumsum(cumsum(cumsum(1:100)));
n_entries = n_entries_vec(n+1);

% Initiate matrices to store permutation results
% This code uses data from 4 taps for each iteration
CCPmat = zeros(n_entries,4);
Rsq_vec = zeros(n_entries,1);

% Initiate counter
counter = 1;

% Initiate waitbar
hwait = waitbar(0, 'Permutating...');

tic
for i1 = 0 : n % First tap
    waitbar(counter/n_entries);
    for i2 = 0 : (n - i1) % Second tap
        for i3 = 0 : (n - i1 - i2) % Third tap
            for i4 = 0 : (n - i1 - i2 - i3) % Fourth (last) tap
                % Convert initiation data to cumulative initiaions
                tempvec = [i1 i2 i3 i4];
                CCPmat(counter,:) = cumsum(tempvec);
                
                % Calculate fractions and linearize
                B2 = -log(1-CCPmat(counter,:)/n);
                
                % Find taps that does not lead to infinite Y (when all
                % flies have initiated courtship). Remove the points from
                % the linear fitting.
                X_f = find(~(CCPmat(counter,:) == n));
                B_f = B2(~(CCPmat(counter,:) == n));
                           
                % Calculate the slope and courtship probability
                slope = X_f'\B_f';
                Bcalc = X_f * slope;
                
                % Calculate R square
                Rsq_vec(counter) = 1 - sum((B_f - Bcalc).^2)/sum((B_f - mean(B_f)).^2);
                
                % Progress counter
                counter = counter + 1;
            end
        end
    end
end

% Run time
t_run = toc

% Close progress bar
close(hwait)

% Show p value
sum(Rsq_vec > R2_emp)/n_entries



