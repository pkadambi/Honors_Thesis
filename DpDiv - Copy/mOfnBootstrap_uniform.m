load('n200_uniform_size_1000.mat')
%doublebootstrap
%N=10000
%M=1000 (2000, 2 class)
numTrials=200;
sampSize=1000;
dpvals=fulldpdata(:,47);
dpbar=mean(dpvals);
bs_dpmeans=zeros(1,numTrials);
mndpdata=zeros(1,numTrials);
for jj = 1:numTrials
    %Monte Carlo sampling done here WITHOUT REPLACEMENT M<N
    %bootstrap
    
    %datasample uses randperm.m (in built) to choose vales
    f0=datasample(data1(:,:,1),sampSize,'Replace',false);
    f1=datasample(data1(:,:,2),sampSize,'Replace',false);
    
    bs_dpmeans(jj)=Dp_div(f0,f1);
end

tenThousandDpUniform=Dp_div(data1(:,:,1),data1(:,:,1));
CI_b_s=[prctile(bs_dpmeans,2.5) prctile(bs_dpmeans,97.5)]
%--------------------------------------------------------------------------

CI_direct=[prctile(dpvals,2.5) prctile(dpvals,97.5)]

resids=dpbar-bs_dpmeans;
CI_sub=[dpbar-prctile(resids,97.5) dpbar-prctile(resids,2.5)]

[f xi]=ksdensity(bs_dpmeans);
figure (1)

plot(xi,f)

grid on
hold on





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
