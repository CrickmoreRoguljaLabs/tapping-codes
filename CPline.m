function [CP, R2, YLine] = CPline(initiation_data)
% CPline calculates the courtship probability and shows linearized courtship
% initiation data based on input data. This code assumes that the iniation
% data are a 1-by-m vector showing the cumulative fractions of 
% courtship initiations after 1 to m taps.
%
% [CP, R2, YLine] = CPline(initiation_data)

% Plot or not (default no)
Plot_or_not = 1;

% Make X
X = 1 : length(initiation_data);

% Log-transform Y
YLine = -log(1-initiation_data);

% Remove infinities
X = X(~(YLine==Inf));
YLine = YLine(~(YLine==Inf));

% Calculate slope
slope = X'\YLine';

% Calculate courtship probability
CP = 1 - exp(-slope);

% Calculate R_square
Ycalc = X * slope;
R2 = 1 - sum((YLine - Ycalc).^2)/sum((YLine - mean(YLine)).^2);

% Plot
if Plot_or_not == 1
    plot(X,YLine,'o',X,Ycalc,'-')
    xlim([1 max(X)])
    ylim([0 4])
    xlabel('Tap number')
    ylabel('- Ln(1 - Fraction initiation)')
    legend({'Data';'Fit'})
end

disp('Fitting result:')
disp(['Courtship probability = ', num2str(CP)])
disp(['R square = ', num2str(R2)])
disp(['Linearized Y = ', num2str(YLine)])


end