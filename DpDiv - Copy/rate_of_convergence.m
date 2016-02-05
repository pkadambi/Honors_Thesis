%Set Test Parameters-------------------------------------------------

numFeatures=20;

maxSampleSize=200; % this must be determined

dataSetSize=500; %

minSampleSize=maxSampleSize/20;

sampleStepSize=maxSampleSize/20;

numTrials=100;

sampleSizes = minSampleSize:sampleStepSize:maxSampleSize;




%create parameters for each dimension
Means=4*rand(numFeatures,1)-2;
stdev=4*rand(numFeatures,1)-2;


%create test data
%first data set is unit variance, zero mean, normal
Data1=u1+s1*randn(dataSetSize,numFeatures);

Data2=zeros(dataSetSize)
for ii = 1:numFeatures 
    Data2=u2+s2*randn(dataSetSize,numFeatures);
end




%parameters of both guassian test data
% vary separation distance
u1=0;
s1=1;

u2=1;
s2=1;




numSampleSizes=numel(sampleSizes);
dpdivResults=zeros(numTrials,numSampleSizes);


for ii = 1:numSampleSizes
    for jj = 1:numTrials   
        f0=datasample(Data1,sampleSizes(ii));
        f1=datasample(Data2,sampleSizes(ii));
        dpdivResults(jj,ii)=Dp_div(f0,f1);
    end
end

%create data points for dpdiv value vs sample sizes






%Plot Without Box---------------------------------------------------------

dpdivMeans=mean(dpdivResults);
figure(1)
hold on
title('D_p Divergence')
xlabel('SampleSize')
ylabel('D_p div stat')
boxplot(dpdivResults, 'Labels',sampleSizes)

% plot(dpdivCurve,sampleSizes,dpdivMeans)

figure(2)
hold on
[dpdivFit, points]=fit(sampleSizes',dpdivMeans','power2')
plot(dpdivFit,sampleSizes,dpdivMeans)
title('D_p Divergence Convergence')
xlabel('SampleSize')
ylabel('D_p div means')