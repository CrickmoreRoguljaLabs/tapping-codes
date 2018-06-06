%% Use CPline to get a courtship-probability fit from tapping data
% Data here is collected from naive, canton S flies

Fraction_naive = [24 37 45 50]/55;
[CP, R2, YLine] = CPline(Fraction_naive);

%% Use coinsim_batch to see how experimental R squares compare to ideal coins
% Data are contained in the script
% Results are expressed in p values, with the null hypothesis that flies
% behave like perfect coins

coinsim_batch

%% Use TapPermute to see how an experimental R square compares to the permutated R_squares
% Data are contained in the script
% This script may take ~1 min to run
% Results are expressed in p values, with the null hypothesis that we get
% the experimental R square by chance

TapPermute

%% Use TapCI to calculate the 95% confidence intervals of the courtship probabilities
% This code uses bootstrap to calculate the CI
% This script may take ~1 min to run

% Sample data from Canton S flies: [N 1st_tap 2nd_tap 3rd_tap 4th_tap]
Data_all = [55	24	37	45	50; 47	6	10	15	19; 57	2	5	10	15];
CI_mat = TapCI(Data_all);

array2table(CI_mat, 'VariableNames', {'CP','Lower_bound','Upper_bound'})

%% Use TapHyp to calculate the p values between samples
% This code uses bootstrap to calculate the CI, with the null hypothesis
% that two samples have the same courtship probability
% This script may take ~1 min to run

% Sample data from Canton S flies: [N 1st_tap 2nd_tap 3rd_tap 4th_tap]
Data_all = [55	24	37	45	50; 47	6	10	15	19; 57	2	5	10	15];
P_mat = TapHyp(Data_all);

array2table(P_mat, 'VariableNames', {'Index_1','Index_2','p_value'})