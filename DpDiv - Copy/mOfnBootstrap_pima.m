load('n200_pima_534.mat')
clc
%doublebootstrap
%N=10000
%M=1000 (2000, 2 class)
numTrials=200;
sampSize=200;
dpvals=dp_data1(258,:);
dpbar=mean(dpvals);
bs_dpmeans=zeros(1,numTrials);


for jj = 1:numTrials
    %Monte Carlo sampling done here WITHOUT REPLACEMENT M<N
    %bootstrap
    
    %datasample uses randperm.m (in built) to choose vales
    f0=datasample(incomp0(:,1:8),sampSize,'Replace',false);
    f1=datasample(incomp1(:,1:8),sampSize,'Replace',false);
    
    bs_dpmeans(jj)=Dp_div(f0,f1);
    
end
dpmean=mean(bs_dpmeans)

lb=100*(0.5-0.5*sqrt(dpmean))
ub=100*(0.5-0.5*dpmean)

CI_b_s=[prctile(bs_dpmeans,2.5) prctile(bs_dpmeans,97.5)]
%--------------------------------------------------------------------------

CI_direct=[prctile(dpvals,2.5) prctile(dpvals,97.5)]

% CI_precomp=[prctile(dp_data1(191,:),2.5) prctile(dp_data1(191,:),97.5)] %N=200


[f xi]=ksdensity(bs_dpmeans);
figure (1)

plot(xi,f)

grid on
hold on


[f1 xi1]=ksdensity(dpvals);


plot(xi1,f1)





% dp_sdev = std(dp_m);%/sqrt(length(dp_m));
% test_distr=mean(dp_m)+dp_sdev*randn(1,10000);
% [f1 xi1]=ksdensity(test_distr);
% [h,p,ksstat]=kstest2(test_distr,dp_m)
% if(h==1)
%     disp('ERROR: Bootstrap distribution is NOT Gaussian!')
% else

% end
%take the m=250 (actually m=500, 250 from each class)

% CI95_Percent = [mean(dp_m)-1.96*dp_sdev mean(dp_m)+ 1.96*dp_sdev]
% hold on
%
% plot(xi,f)  ;
% plot(xi1,f1);
