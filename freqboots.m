function [ pval, sim_dif ] = freqboots( n_A, pos_A, n_B, pos_B , n_itr)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


% Default reiterating 5000 times
if nargin < 5
    n_itr = 5000;
end

% Pool the data together
pooled_data = zeros(n_A + n_B, 1);
pooled_data(1:(pos_A+pos_B)) = 1;

% Prime simulated differences
sim_dif = zeros(n_itr, 1);

% Redrawing indices
re_ind = randi((n_A + n_B), [n_itr, n_A + n_B]);

for i = 1 : n_itr
    % Redraw data
    re_data = pooled_data(re_ind(i,:));
    
    % Calculate difference
    sim_dif(i) = mean(re_data(1:n_A)) - mean(re_data(n_A+1 : end));
end

% Real difference
real_dif = abs(pos_A/n_A - pos_B/n_B);

% Calculate p value (two-tailed)
pval = mean(sim_dif > real_dif) + mean(sim_dif < -real_dif);

% Make a plot
figure
hist(sim_dif, 200);

end

