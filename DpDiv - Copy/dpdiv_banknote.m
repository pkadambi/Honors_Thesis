%--get pima data-----------------------------------------------------------

%incomplete 
load banknote.txt


% completeRows=pimaincomplete(:,1)~=0;

% for ii=2:8
%     completeRows=and(completeRows,pimaincomplete(:,ii));
% end
% completeRows=find(completeRows);

% pimacomplete=pimaincomplete(completeRows,:);

% comp1=find(pimacomplete(:,9));
% comp1=pimacomplete(comp1,:);
% comp0=find(xor(pimacomplete(:,9),1));
% comp0=pimacomplete(comp0,:);


incomp1=find(banknote(:,5));
incomp1=banknote(incomp1,:);
incomp0=find(xor(banknote(:,5),1));
incomp0=banknote(incomp0,:);

[datalength numFeatures]=size(banknote);
numFeatures=numFeatures-1;
%--------------------------------------------------------------------------
% incomp1=comp1;
% incomp0=comp0;
% dataSetSizeC=length(pimacomplete);
dataSetSizeI=length(banknote);


numTrials=50;

maxSampleSizeI=1;

%Calculate maximum possible sub sample size 

for ii =  1:dataSetSizeI
    if nchoosek(dataSetSizeI,dataSetSizeI-ii)>=numTrials
        maxSampleSizeI=dataSetSizeI-ii;
        break
    elseif nchoosek(dataSetSizeI,ii)>1e6
        %Will not have trials of 1 million size
        break
    end
end

fullDpmeansIncomp=[];
fullSampleSizesI=[];

stepSizeI=ceil(0.002*dataSetSizeI);



minSampleSizeI=10;



if(stepSizeI==0)
    stepSizeI=1;
end



      
% sampleSizesI = [8:30 31:2:70 70:3:109 95:4:144 145:4:205 205:4:267];
sampleSizesI = [10:5:90 100:25:300 300:50:600];

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
    
        f0=datasample(incomp0(:,1:numFeatures),currSampSize,'Replace',false);
        f1=datasample(incomp1(:,1:numFeatures),currSampSize,'Replace',false);
        
%         f0=datasample(incomp0,currSampSize,'Replace',true);
%         f1=datasample(incomp1,currSampSize,'Replace',true);
        dp_data1(ii,jj)=Dp_div(f0,f1);
    end
    dpdivMeansI=mean(dp_data1,2);
end


figure(1)
hold on
grid on

[dpdivFitI, points1]=fit(fullSampleSizesI',dpdivMeansI,'power2')
% [dpdivFit2, points2]=fit(fullSampleSizes',fullDpmeans2','power2')
plot(dpdivFitI,fullSampleSizesI,dpdivMeansI')
% plot(dpdivFit2,fullSampleSizes,fullDpmeans2','x')

data1coef1=coeffvalues(dpdivFitI);
% data1coef2=coeffvalues(dpdivFit2);

dp_div_d1=data1coef1(3);
b1=data1coef1(2);
a1=data1coef1(1);

% dp_div_d2=data1coef2(3);
% b2=data1coef2(2);
% a2=data1coef2(1);

% title('Convergence for Banknote Dataset, N=50 trials')
xlabel('SampleSize')
ylabel('D_p Divergence')
axis([0 600 0.5 1])





% figure(2)
% hold on
% title('Ebayes bound')
% xlabel('Sample Size')
% ylabel('Ebayes')
% plot([sampleSizesI ],lowerBound)
% plot([sampleSizesI ],upperBound)
% axis([0 600 0 .1])
% grid on

% figure (3)
% hold on
% title('Ebayes bound')
% xlabel('Sample Size')
% ylabel('Ebayes')
% [uboundfit, points2]=fit(sampleSizesI',upperBound','power2')
% [lboundfit, points2]=fit(sampleSizesI',lowerBound','power2')
% plot(uboundfit,sampleSizesI,upperBound')
% plot(lboundfit,sampleSizesI,lowerBound')
% grid on
% axis([0 600 0 .1])
% lowerBound2=0.5-0.5*sqrt(dp_div_d2)
% upperBound2=0.5-0.5*dp_div_d2

lb=0.5-0.5*sqrt(dp_div_d1)
ub=0.5-0.5*dp_div_d1



