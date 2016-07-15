fma = fm1;
fmb = fm2;

start = datenum(2013,9,18,13,42,00);
stop =  datenum(2013,9,18,13,52,00);

conditiona = fm1(:,1) >= stop;
conditionb = fm2(:,1) >= stop;

fma(conditiona,:)=[];
fmb(conditionb,:)=[];

conditiona = fm1(:,1) <= start;
conditionb = fm2(:,1) <= start;
fma(conditiona,:)=[];
fmb(conditionb,:)=[];

integrateTotalFlow(fma,'gpm')
integrateTotalFlow(fmb,'gpm')
