%2-dimensional gaussian dataset--------------------------------------------

dimension=8;

offset=[zeros(1,8) ; 0.5 (zeros(1,7))];
% ud2=[zeros(1,8);3.86 3.1 0.84 0.84 1.64 1.08 0.26 0.01];
% 
% sigmad1=ones(2,8);
% sigmad2=[ones(1,8);8.41 12.06 0.12 0.22 1.49 1.77 0.35 2.73];

%--------------------------------------------------------------------------
numTrials=200;

dp_data1=zeros(3,numTrials);
dp_data2=zeros(3,numTrials);

dataSize=10000;

data1=zeros(dataSize,dimension,2);
a=repmat(offset(1,:),[dataSize,1])+rand(dataSize,dimension);
data1(:,:,1)=a;
b=repmat(offset(2,:),[dataSize,1])+rand(dataSize,dimension);
data1(:,:,2)=b;

% data2(:,:,1)=repmat(ud2(1,:),[dataSize,1])+repmat(sigmad2(1,:),[dataSize,1]).*randn(dataSize,dimension);
% data2(:,:,2)=repmat(ud2(2,:),[dataSize,1])+repmat(sigmad2(2,:),[dataSize,1]).*randn(dataSize,dimension);


% minSampleSize=[10  ];
% maxSampleSize=[500  ];
% sampleStepSize=[5  ];

% minSampleSize=[10 50  ];%  100];
% maxSampleSize=[50 500 ];% 10000];
% sampleStepSize=[5 25  ];%  50];

% minSampleSize=[10 50    100];
% maxSampleSize=[100 500  10000];
% sampleStepSize=[5 25    50];

minSampleSize=[10 100 500    1000];
maxSampleSize=[100 500 1000  2000];
sampleStepSize=[5 25 50     100];

fullDpmeans1=[];
% fullDpmeans2=[];
fullSampleSizes=[];

% for nn = 1:10

for n = 1:length(maxSampleSize)
    
    
    
    sampleSizes = minSampleSize(n):sampleStepSize(n):maxSampleSize(n);
    fullSampleSizes=[fullSampleSizes sampleSizes];
    numSampleSizes=numel(sampleSizes);
    
    dp_data1=zeros(numSampleSizes,numTrials);
%     dp_data2=zeros(numSampleSizes,numTrials);
    
    for ii = 1:numSampleSizes
        
        currSampSize=sampleSizes(ii);
        
        for jj = 1:numTrials
            %Monte Carlo sampling done here WITHOUT REPLACEMENT
            %datasample uses randperm.m (in built) to choose vales
            f0=datasample(data1(:,:,1),currSampSize,'Replace',false);
            f1=datasample(data1(:,:,2),currSampSize,'Replace',false);
            
            dp_data1(ii,jj)=Dp_div(f0,f1);
            
%             f0=datasample(data2(:,:,1),currSampSize,'Replace',false);
%             f1=datasample(data2(:,:,2),currSampSize,'Replace',false);
%             dp_data2(ii,jj)=Dp_div(f0,f1);
        end
    end
    
    
    dpdivMeans1=mean(dp_data1,2); %2 is to avoid doing the transpose of dp_data
%     dpdivMeans2=mean(dp_data2,2);
    
    fullDpmeans1=[fullDpmeans1 dpdivMeans1'];
%     fullDpmeans2=[fullDpmeans2 dpdivMeans2'];
    
end

figure(1)
hold on
grid on

[dpdivFit1, points1]=fit(fullSampleSizes',fullDpmeans1','power2')
% [dpdivFit2, points2]=fit(fullSampleSizes',fullDpmeans2','power2')
plot(dpdivFit1,fullSampleSizes,fullDpmeans1')
% plot(dpdivFit2,fullSampleSizes,fullDpmeans2','x')
% boxplot(dpdivResults1, 'Labels',sampleSizes)


data1coef1=coeffvalues(dpdivFit1);
% data1coef2=coeffvalues(dpdivFit2);

dp_div_d1=data1coef1(3);
b1=data1coef1(2);
a1=data1coef1(1);

% dp_div_d2=data1coef2(3);
% b2=data1coef2(2);
% a2=data1coef2(1);

% title('D_p Divergence Convergence for Uniform Dataset, B=200 Monte Carlo Trials')
xlabel('SampleSize')
ylabel('D_p Divergence')
axis([0 maxSampleSize(length(maxSampleSize)) 0.2 0.6])


lowerBound1=0.5-0.5*sqrt(dp_div_d1)
upperBound1=0.5-0.5*dp_div_d1

% end
% lowerBound2=0.5-0.5*sqrt(dp_div_d2)
% upperBound2=0.5-0.5*dp_div_d2




