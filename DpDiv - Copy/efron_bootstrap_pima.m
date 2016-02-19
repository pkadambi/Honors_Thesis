% load('n200_pima_534.mat')
%doublebootstrap
%N=10000
%M=1000 (2000, 2 class)
numTrials=50;
sampSize=610;

bs_dpmeans=zeros(1,numTrials);
numFeatures=4;
f0=datasample(incomp0(:,1:numFeatures),sampSize,'Replace',false);
f1=datasample(incomp1(:,1:numFeatures),sampSize,'Replace',false);
    
dpbar=Dp_div(f0,f1);

for jj = 1:numTrials
    %Monte Carlo sampling done here WITHOUT REPLACEMENT M<N
    %bootstrap
    
    %datasample uses randperm.m (in built) to choose vales
    f0=datasample(incomp0(:,1:numFeatures),sampSize,'Replace',true);
    f1=datasample(incomp1(:,1:numFeatures),sampSize,'Replace',true);
    
    bs_dpmeans(jj)=Dp_div(f0,f1);
    
end

CI_double_bs=[prctile(bs_dpmeans,2.5) prctile(bs_dpmeans,97.5)]
%--------------------------------------------------------------------------

% CI_precomp=[prctile(dp_data1(191,:),2.5) prctile(dp_data1(191,:),97.5)] %N=200

[dpdivFitI, points1]=fit((2*fullSampleSizesI)',dpdivMeansI,'power2')

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
