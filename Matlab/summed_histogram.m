tic
close all;
load loopdata;
fig= figure('color','w');
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

data_summed = summed_data(data);


histogram(data_summed.avgTravelTime)


xlabel('Travel time of trajectory (s)','interpreter','latex')
title('Travel time histogram, all days and times in october','interpreter','latex');
ylabel('Frequency','interpreter','latex');


m = nanmean(data_summed.avgTravelTime);

perc95 = prctile(data_summed.avgTravelTime,95)

buffer_index = (perc95 - m)/m
print_pdf('summed_histo')
toc