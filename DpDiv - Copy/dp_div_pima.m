%--get pima data-----------------------------------------------------------

%incomplete 
load pimaincomplete.dat


completeRows=pimaincomplete(:,1)~=0;

for ii=2:8
    completeRows=and(completeRows,pimaincomplete(:,ii));
end
completeRows=find(completeRows);

pimacomplete=pimaincomplete(completeRows,:);

comp1=find(pimacomplete(:,9));
comp1=pimacomplete(comp1,:);
comp0=find(xor(pimacomplete(:,9),1));
comp0=pimacomplete(comp0,:);


incomp1=find(pimaincomplete(:,9));
incomp1=pimaincomplete(incomp1,:);
incomp0=find(xor(pimaincomplete(:,9),1));
incomp0=pimaincomplete(incomp0,:);
%--------------------------------------------------------------------------
% incomp1=comp1;
% incomp0=comp0;
dataSetSizeC=length(pimacomplete);
dataSetSizeI=length(pimaincomplete);


numTrials=50;
maxSampleSizeC=1;
maxSampleSizeI=1;

%Calculate maximum possible sub sample size 
for ii =  1:dataSetSizeC
    if nchoosek(dataSetSizeC,dataSetSizeC-ii)>=numTrials
        maxSampleSizeC=dataSetSizeC-ii;
        break
    elseif nchoosek(dataSetSizeC,ii)>1e6
        %Will not have trials of 1 million size
        break
    end
end

for ii =  1:dataSetSizeI
    if nchoosek(dataSetSizeI,dataSetSizeI-ii)>=numTrials
        maxSampleSizeI=dataSetSizeI-ii;
        break
    elseif nchoosek(dataSetSizeI,ii)>1e6
        %Will not have trials of 1 million size
        break
    end
end

fullDpmeansComp=[];
fullDpmeansIncomp=[];
fullSampleSizesI=[];


stepSizeI=ceil(0.002*dataSetSizeI);
stepSizeC=ceil(0.002*dataSetSizeC);


minSampleSizeI=10;
minSampleSizeC=10;


if(stepSizeI==0)
    stepSizeI=1;
end

if(stepSizeC==0)
    stepSizeC=0;
end


% sampleSizesI = [8:50 50:3:109 95:4:144 145:4:205 205:5:267];
% sampleSizesI = [8:50];%70 70:3:109 95:4:144 145:4:205 205:4:267];
% sampleSizesI = [8:30 31:100];
% sampleSizesI = [8:30 31:1:60 60:2:118 120:2:150];
% ; 145:4:200];

sampleSizesI = minSampleSizeC:stepSizeC:267;
% sampleSizesC = minSampleSizeC:stepSizeC:maxSampleSizeC;

fullSampleSizesI=sampleSizesI;



numSampleSizesI=numel(sampleSizesI);

dp_data1=zeros(numSampleSizesI,numTrials);
%     dp_data2=zeros(numSampleSizes,numTrials);

dpdivMeansI=[];

for ii = 1:numel(sampleSizesI)
 
    currSampSize=sampleSizesI(ii);
   
%     if(currSampSize1>=length(incomp1))
%         currSampSize=
%     end
%     if(currSampSize0>=numel)
    
    for jj = 1:numTrials
    
        f0=datasample(incomp0(:,1:8),currSampSize,'Replace',false);
        f1=datasample(incomp1(:,1:8),currSampSize,'Replace',false);
        
%         f0=datasample(incomp0,currSampSize,'Replace',true);
%         f1=datasample(incomp1,currSampSize,'Replace',true);
        dp_data1(ii,jj)=Dp_div(f0,f1);
    end
    dpdivMeansI=mean(dp_data1,2);
end


figure(1)
hold on
grid on

[dpdivFitI, points1]=fit((2*fullSampleSizesI)',dpdivMeansI,'power2')
% [dpdivFit2, points2]=fit(fullSampleSizes',fullDpmeans2','power2')
plot(dpdivFitI,(2*fullSampleSizesI),dpdivMeansI')
% plot(dpdivFit2,fullSampleSizes,fullDpmeans2','x')

data1coef1=coeffvalues(dpdivFitI);
% data1coef2=coeffvalues(dpdivFit2);

dp_div_d1=data1coef1(3);
b1=data1coef1(2);
a1=data1coef1(1);

% dp_div_d2=data1coef2(3);
% b2=data1coef2(2);
% a2=data1coef2(1);

% title('Convergence for Pima Indian Dataset, B=5000 Monte Carlo trials')
xlabel('SampleSize')
ylabel('D_p Divergence')
axis([0 600 0 0.4])


lowerBound=0.5-0.5*sqrt([dpdivMeansI' ]);
upperBound=0.5-0.5*([dpdivMeansI' ]);
lb=0.5-0.5*sqrt(dp_div_d1)
ub=0.5-0.5*dp_div_d1

figure(2)
hold on
title('Ebayes bound')
xlabel('Sample Size')
ylabel('Ebayes')
plot([(2*fullSampleSizesI) ],lowerBound)
plot([(2*fullSampleSizesI) ],upperBound)
axis([0 2*max(sampleSizesI) 0 1])
grid on

figure (3)
hold on
title('Ebayes bound')
xlabel('Sample Size')
ylabel('Ebayes')
[uboundfit, points2]=fit((2*fullSampleSizesI)',upperBound','power2')
[lboundfit, points2]=fit((2*fullSampleSizesI)',lowerBound','power2')
plot(uboundfit,(2*fullSampleSizesI)',upperBound')
plot(lboundfit,(2*fullSampleSizesI)',lowerBound')
grid on



[dpdivFitI, points1]=fit((2*fullSampleSizesI)',dpdivMeansI,'power2')
lb=0.5-0.5*sqrt(dp_div_d1)
ub=0.5-0.5*dp_div_d1

