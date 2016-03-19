clear all
load('n200_uniform_size_1000.mat')
bvals=zeros(1,length(fullDpmeans1)-3)
for i = 3:length(fullDpmeans1)
    sub_dpdivMeansI=fullDpmeans1(1:i);
    sub_sampleSizesI=fullSampleSizes(1:i);
    [dpdivFit, points]=fit(sub_sampleSizesI',sub_dpdivMeansI','power2')
    a=coeffvalues(dpdivFit);
    
    bvals(i-2)=a(2);
end

scatter(fullSampleSizes(3:end), bvals)

indecies=find(bvals<0)
bvals=bvals(indecies)
SampleSizes=fullSampleSizes(length(fullSampleSizes)-length(bvals)+1:end);
[convergence points]=fit(SampleSizes',bvals','power2');
resids=abs(bvals-convergence(SampleSizes)')

figure(1)
grid on
axis([0 1000 -1 0])
plot(convergence,SampleSizes, bvals,'o')

figure(2)
plot(SampleSizes, resids)