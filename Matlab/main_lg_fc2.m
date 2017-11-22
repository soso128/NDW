D = importTrajectFCData('/Volumes/HDD/Users/lvdgraaff/Dropbox/Physics with NDW/FCD_fulltrajectory/tableFCDalldays.csv');
D = D';
%%
time = hours(6)+hours((0:size(D,1)-1)/60); % time in hours
dayOfMonth = datetime(2017,10,1) + days(0:size(D,2)-1);
%% 
% plot(time, D/60000)
% 
% %% apply time window
% clf;
% timeWindowStart = hours(8);
% timeWindowEnd = hours(8.25);
% timeIndx = (time>timeWindowStart)&(time<timeWindowEnd);
% plot(time(timeIndx), D(timeIndx,:)/60000);

%% image of TRAVEL TIME
clf
h = imagesc(hours(time), day(dayOfMonth), D'/60000);
h.Parent.YTick = 1:31;
h.Parent.YTickLabel = datestr(dayOfMonth, 'ddd dd mmm');
h.Parent.XTickLabel = datestr(hours(h.Parent.XTick), 'hh:MM');

%ytickangle(90)
xlabel('Time of day [h]')
hcb=colorbar;
hcb.Label.String = 'Travel Time [min]';

lg_print('Traject travel time', 15, 10);
%% Histogram Calulations
clf
nBins = 15;
windowWidth = 15;
nTimeWindows = floor(numel(time)/windowWidth);
N = zeros(nBins,nTimeWindows);
% create edges
[~,edges] = histcounts(D(:,:),nBins);
% filter working days
daysToInclude = mod(weekday(dayOfMonth),6)>1;

meanTravelTime = zeros(nTimeWindows,1);
stdTravelTime = zeros(nTimeWindows,1);

for j = 1:nTimeWindows
    Dx = D((1:windowWidth) + (j-1)*windowWidth,daysToInclude);
    
    N(:,j) = histcounts(Dx, edges);
    meanTravelTime(j) = mean(Dx(:));
    stdTravelTime(j) = std(Dx(:));
end
%% image the histogram
clf
y = edges(1:end-1) + .5*diff(edges(1:2));
h = imagesc(1:nTimeWindows, y/60000, 100*(N./sum(N)));
h.Parent.YDir='normal';
h.Parent.XTick = 1:nTimeWindows;
h.Parent.XTickLabel = datestr(time(1:windowWidth:end), 'hh:MM');
ylabel 'Travel time [min]';
xlabel 'Time of the day';
title 'Distribution of travel times for weekdays'
hcb = colorbar;
hcb.Label.String = 'Frequency [%]';
%% overlap sigma / mean
hold on;
hm = plot(meanTravelTime/60000,'r');
[hm.LineWidth]=deal(2);
hs = plot((meanTravelTime+2*stdTravelTime)/60000,'g');
[hs.LineWidth]=deal(2);
legend([hm,hs], '\mu', '\mu+2\cdot\sigma','Location','NorthWest');