if ~exist('A','var')
    Y = input('fractions = ');
elseif size(A,1) == 1 
    Y = A;
else
    fracmat = mean(A);

    Y = fracmat(1:4);
end

X = 1:4;

Y2 = -log(1-Y);


fitOptions = fitoptions('poly1','Lower',[-Inf 0],'Upper',[Inf 0]);

linefit = fit(X(~(Y2==Inf))',Y2(~(Y2==Inf))','poly1',fitOptions);


CP = 1 - exp(-linefit.p1);

CI = -confint(linefit);

CI(:,2)=[];

CP_CI = 1- exp(CI);

% disp('Fit results: ')
% CP
% CP_CI

plot(linefit, X, Y2)

Ycalc = X * linefit.p1;
Rsquared = 1 - sum((Y2 - Ycalc).^2)/sum((Y2 - mean(Y2)).^2);