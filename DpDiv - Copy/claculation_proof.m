size_arr=1000;
dim_arr=3;
x=[rand(size_arr,dim_arr)];
y=[rand(size_arr,1)+0.5 rand(size_arr,dim_arr-1)];
Dp_div(x,y)
Dp_div(y,x)




clear all
load('n50_uniform_size_1000.mat')

% resids=abs(fullDpmeans1-dpdivFit1(fullSampleSizes)')
% grid on
MAXVAL=1E8
interval=1E5
x=1:interval:MAXVAL;
resids=abs(0.5-dpdivFit1(x)');
dpdivFit1(MAXVAL)
grid on

semilogy(x,resids)
axis([0 MAXVAL 1E-3 1E0 ])
grid on
title('Error of D_p Estimate vs Sample Size')
ylabel('Absolute Error of D_p Estimate')
xlabel('Sample Size')