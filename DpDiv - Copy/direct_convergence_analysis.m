clear all
load('n50_uniform_size_1000.mat')

% resids=abs(fullDpmeans1-dpdivFit1(fullSampleSizes)')
% grid on
MAXVAL=1E9
interval=1E5
x=1:interval:MAXVAL;
resids=abs(0.5-dpdivFit1(x)');
dpdivFit1(MAXVAL)
grid on

semilogy(x,resids)
axis([0 MAXVAL 1E-3 1E0 ])
title('Convergence of absolute error for D_p')