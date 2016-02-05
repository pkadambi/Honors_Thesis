%Set Test Parameters-------------------------------------------------

numFeatures=5;

maxSampleSize=200; % this must be determined

dataSetSize=500; %

minSampleSize=maxSampleSize/10;
sampleStepSize=maxSampleSize/10;

numTrials=100;

%Calculate maximum possible sub sample size 
for ii =  1:dataSetSize
    if nchoosek(dataSetSize,dataSetSize-ii)>=numTrials
        maxSampleSize=dataSetSize-ii;
        break
    elseif nchoosek(dataSetSize)>1e6
        %Will not have trials of 1 million size
        break
    end
end

disp('Source data size: ')
disp(strcat('Largest unique sample possible without replacement: ',num2str(maxSampleSize)))
sampleSizes = minSampleSize:sampleStepSize:maxSampleSize;

%parameters of both guassian test data
% vary separation distance
u1=0;
s1=1;

u2=1;
s2=1;


%create test data

%--- differently distributed feature data-----------------------
%run this once at the beginning of varying feature count test
%then comment it out so that the distributions stay the same

numFeaturesMax=15;
Data1=zeros(dataSetSize,numFeaturesMax);
Data2=zeros(dataSetSize,numFeaturesMax);
for ii = 1:numFeaturesMax
    
    Data1(:,ii)=2*rand(1,1)+2*rand(1,1)*randn(dataSetSize,1);
    Data2(:,ii)=3*rand(1,1)+3*rand(1,1)*randn(dataSetSize,1);
end

%--- differently distributed feature data-----------------------



    



%Define number of sample sizes used
numSampleSizes=numel(sampleSizes);
dpdivResults=zeros(numTrials,numSampleSizes);


DataUse1=Data1(:,1:numFeatures);
DataUse2=Data2(:,1:numFeatures);

for ii = 1:numSampleSizes
    for jj = 1:numTrials   
        
        %Monte Carlo sampling done here WITHOUT REPLACEMENT
        f0=datasample(DataUse1,sampleSizes(ii),'Replace',false);
        f1=datasample(DataUse2,sampleSizes(ii),'Replace',false);
        
        %Monte Carlo sampling done here WITH REPLACEMENT
%         f0=datasample(Data1,sampleSizes(ii));
%         f1=datasample(Data2,sampleSizes(ii));
        
        dpdivResults(jj,ii)=Dp_div(f0,f1);
    end
end
dpdivMeans=mean(dpdivResults);

%create data points for dpdiv value vs sample sizes






%Plot Without Box---------------------------------------------------------


figure(1)
hold on
grid on
title('D_p Divergence')
xlabel('SampleSize')
ylabel('D_p div stat')
boxplot(dpdivMeans, 'Labels',sampleSizes)
axis([0 numSampleSizes+1 -.1 1.1])
% plot(dpdivCurve,sampleSizes,dpdivMeans)

figure(2)
hold on
grid on

[dpdivFit, points]=fit(sampleSizes',dpdivMeans','power2')
plot(dpdivFit,sampleSizes,dpdivMeans)
boxplot(dpdivResults1, 'Labels',sampleSizes)

a=coeffvalues(dpdivFit);
c=a(3);
b=a(2);
a=a(1);
title('D_p Divergence Convergence')
xlabel('SampleSize')
ylabel('D_p div means')
axis([0 maxSampleSize 0 1])
%-------------------------------------------------------------------------
%
% lowerBound=0.5-0.5.*sqrt(dpdivMeans/.25);
% upperBound=0.5-0.5.*dpdivMeans/.25;




% lowerBound=0.5-0.5.*sqrt(dpdivMeans);
% upperBound=0.5-0.5.*dpdivMeans;
% figure(3)
% hold on
% title('E_bayes bound')
% xlabel('Sample Size')
% ylabel('E_bayes')
% plot(sampleSizes,lowerBound)
% plot(sampleSizes,upperBound)
% axis([0 maxSampleSize 0 1])




%-------------------------------------------------------------------------
% N=1000;
% figure(4)
% title('Normalized Histogram f0 and f1')
% hold on
% histogram(Data1,'Normalization','probability','BinMethod','sqrt')
% histogram(Data2,'Normalization','probability','BinMethod','sqrt')
     
%-------------------------------------------------------------------------
figure(5)
hold on
title('Rate of Convergence')
plot(numFeatures,b,'x')
axis([0 15 -8 3.5 ])
xlabel('Number of Features')
ylabel('Value of b, rate parameter')
grid on

figure(6)
hold on
title('DP Div Asymptotic Value vs Feature Size')
plot(numFeatures,c,'o')
grid on
axis([0 15 -.2 1])
xlabel('Number of Features')
ylabel('Calculated Dp Divergence at specified feature size')
disp(strcat('DP Div Asyptotic Value is:',num2str(c)))


