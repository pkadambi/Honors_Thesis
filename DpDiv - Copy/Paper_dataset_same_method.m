%8-dimensional gaussian dataset--------------------------------------------

dimension=8;

ud1=[zeros(1,8) ; 2.56 zeros(1,7)];

ud2=[zeros(1,8);3.86 3.1 0.84 0.84 1.64 1.08 0.26 0.01];

sigmad1=ones(2,8);
sigmad2=[ones(1,8);8.41 12.06 0.12 0.22 1.49 1.77 0.35 2.73];



%--------------------------------------------------------------------------

sampleSizes=[100 500 1000];


dataSize=2000;
numTrials=50;
dp_data1=zeros(3,numTrials);
dp_data2=zeros(3,numTrials);

% data1=zeros(dataSize,dimension,2);
% data2=zeros(dataSize,dimension,2);

% data1(:,:,1)=repmat(ud1(1,:),[dataSize,1])+repmat(sigmad1(1,:),[dataSize,1]).*randn(dataSize,dimension);
% data1(:,:,2)=repmat(ud1(2,:),[dataSize,1])+repmat(sigmad1(2,:),[dataSize,1]).*randn(dataSize,dimension);
% 
% data2(:,:,1)=repmat(ud2(1,:),[dataSize,1])+repmat(sigmad2(1,:),[dataSize,1]).*randn(dataSize,dimension);
% data2(:,:,2)=repmat(ud2(2,:),[dataSize,1])+repmat(sigmad2(2,:),[dataSize,1]).*randn(dataSize,dimension);

for ii = 1:3
    currSampSize=sampleSizes(ii);
    
    %create data sets
    for jj = 1:50
        
        %Monte Carlo sampling done here WITHOUT REPLACEMENT
        %datasample uses randperm.m (in built) to choose vales
        f0=datasample(data1(:,:,1),currSampSize,'Replace',false);
        f1=datasample(data1(:,:,2),currSampSize,'Replace',false);
        
        dp_data1(ii,jj)=Dp_div(f0,f1);
        
        f0=datasample(data2(:,:,1),currSampSize,'Replace',false);
        f1=datasample(data2(:,:,2),currSampSize,'Replace',false);
        dp_data2(ii,jj)=Dp_div(f0,f1);
    end
end
dpdivMeans1=mean(dp_data1,2) %2 is to avoid doing the transpose of dp_data
dpdivMeans2=mean(dp_data2,2)

%e_bayes bounds
% lowerBound1=0.5-0.5.*sqrt(dpdivMeans1)
% upperBound1=0.5-0.5.*dpdivMeans1

lowerBound1=0.5-0.5.*sqrt(dp_data1);
upperBound1=0.5-0.5.*dp_data1;
mean(lowerBound1,2)
mean(upperBound1,2)
var(lowerBound1,0,2);
var(upperBound1,0,2);

lowerBound2=0.5-0.5.*sqrt(dp_data2);
upperBound2=0.5-0.5.*dp_data2;
mean(lowerBound2,2)
mean(upperBound2,2)
var(lowerBound2,0,2);
var(upperBound2,0,2);