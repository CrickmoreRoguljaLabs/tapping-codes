nIt = 100000;

TimeIt = zeros(nIt, 3);

for i = 1 : nIt

    nA = length(A);
    nB = length(B);
    nC = length(C);

    X = randi(nA);
    t_A = A(X);
    Bmin = find(B>t_A,1, 'first');
    X = randi([Bmin,nB]);
    t_B = B(X);
    Cmin = find(C>t_B,1, 'first');
    X = randi([Cmin,nC]);
    t_C = C(X);

    TimeIt(i,:) = [t_A, t_B, t_C];
end

courtInt = rand(nIt,3) <= 0.44;
courtInt2 = cumsum(courtInt,2) > 0;
courtInt3 = [courtInt2(:,1),diff(courtInt2,1,2)==1];


TimeIt_line = TimeIt(:);
courtInt_line = courtInt3(:);

[TimeIt_line_sort, rank] = sort(TimeIt_line,1,'ascend');
courtInt_line_sort = courtInt_line(rank);

courtInt_line_sort_cumul = cumsum(courtInt_line_sort)/nIt*100;

plot(TimeIt_line_sort,courtInt_line_sort_cumul, realdata(:,1), realdata(:,2))