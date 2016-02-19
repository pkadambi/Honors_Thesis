clear all
load('n200_uniform_size_1000.mat')

dp_m=fulldpdata(:,2);

dp_sdev = std(dp_m);%/sqrt(length(dp_m));
test_distr=mean(dp_m)+dp_sdev*randn(1,10000);
[f xi]=ksdensity(dp_m);
[f1 xi1]=ksdensity(test_distr);
[h,p,ksstat]=kstest2(test_distr,dp_m);
h
p
if(h==1)
    disp('ERROR: Bootstrap distribution is NOT Gaussian!')
else

end
%take the m=250 (actually m=500, 250 from each class)

CI95_Percent = [mean(dp_m)-1.96*dp_sdev mean(dp_m)+ 1.96*dp_sdev]
hold on

plot(xi,f)  ;
plot(xi1,f1);
