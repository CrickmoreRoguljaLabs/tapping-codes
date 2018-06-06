# tapping-codes
Code used to analyze tap-to-courtship transitions in the fly
by Stephen Zhang

A tutorial code is provided to test the functions/scripts.

CPline performs a simple linear fit of the courtship initiation data.

coinsim_batch performs coin-flip simulations and calculates the chance (p value) that the experimenta R square is at least as high as simulated coins.

TapPermute permutes all possibilities of courtship initiations and calculates the chance (p value) that the experimenta R square is at least as high as the permutated ones.

TapCI uses bootstrap to calculate the 95% confidence intervals of courtship probabilities.

TapHyp uses bootstrap to calculate the p values between pairs of samples, with the null hypothesis that they have the same courtship probability.
