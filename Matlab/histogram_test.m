load loopdata;
close all
fig = figure('color','w')
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

segment =8 ;
data_1 = segment_number_data(data,segment);

histogram(data_1.avgTravelTime)

m = nanmean(data_1.avgTravelTime)

perc95 = prctile(data_1.avgTravelTime,95)

buffer_index = (perc95 - m)/m


 
xlabel(num2str(segment,'Travel time of segment no. %d'),'interpreter','latex')
%xlabel 'Travel time of segment #1 (s)'
title('Travel time histogram of segment 8, all days and times in october','interpreter','latex');
ylabel('Frequency','interpreter','latex');

print_pdf('histo')