%Set Test Parameters-------------------------------------------------
sampleStepSize=25;
minSampleSize=25;
maxSampleSize=1000;
sampleSizes = minSampleSize:sampleStepSize:maxSampleSize;


%-----------set parameters of uniform distr--------------------------
a=3;
b=1;

%-----------set parameters of gaussian distr--------------------------

numTrials=100;
numSampleSizes=(maxSampleSize-minSampleSize)/(sampleStepSize)+1;
dpdivResults1=zeros(numTrials,numSampleSizes);


for ii = 1:numSampleSizes
    f0=b+a.*randn(ii*sampleStepSize,numTrials);
    f1=a+b.*randn(ii*sampleStepSize,numTrials);
    for jj = 1:numTrials   
        dpdivResults1(jj,ii)=Dp_div(f0(:,jj),f1(:,jj));
    end
end


for ii = 1:numSampleSizes
    for jj = 1:numTrials   
        f0=datasample(sampleData1,sampleSizes(ii));
        f1=datasample(sampleData2,sampleSizes(ii));
        dpdivResults(jj,ii)=Dp_div(f0,f1);
    end
end

%create data points for dpdiv value vs sample sizes


%Plot Without Box---------------------------------------------------------

dpdivMeans=mean(dpdivResults);

%create data points for dpdiv value vs sample sizes


%Plot Without Box---------------------------------------------------------

dpdivMeans1=mean(dpdivResults1);
figure(1)
hold on
title('D_p Divergence')
xlabel('SampleSize')
ylabel('D_p div stat')
boxplot(dpdivResults1, 'Labels',sampleSizes)
%-------------------------------------------------------------------------

lowerBound=0.5-0.5.*sqrt(dpdivMeans1);
upperBound=0.5-0.5.*dpdivMeans1;


figure(2)
hold on
title('E_bayes bound')
xlabel('Sample Size')
ylabel('E_bayes')
plot(sampleSizes,lowerBound)
plot(sampleSizes,upperBound)
axis([0 maxSampleSize 0 1])
%-------------------------------------------------------------------------
N=1000;
f0=b+a.*randn(N,1);
f1=a+b.*rand(N,1);

figure(3)
title('Normalized Histogram f0 and f1')
hold on
histogram(f0,'Normalization','probability','BinMethod','sqrt')
histogram(f1,'Normalization','probability','BinMethod','sqrt')
    
%-------------------------------------------------------------------------


