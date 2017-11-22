D = importTrajectFCData('/Volumes/HDD/Users/lvdgraaff/Dropbox/Physics with NDW/FCD_fulltrajectory/tableFCDalldays.csv');
D = D';
%%
time = hours(6)+hours((0:size(D,1)-1)/60); % time in hours
dayOfMonth = datetime(2017,10,1) + days(0:size(D,2)-1);
%% 
plot(time, D/60000)

%% apply time window
clf;
timeWindowStart = hours(6);
timeWindowEnd = hours(10);
timeIndx = (time>timeWindowStart)&(time<timeWindowEnd);
plot(time(timeIndx), D(timeIndx,:)/60000);

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
%% 2D histogram
clf
nBins = 10;
nDays = 31;
N = zeros(nBins,nDays);

% create edges
[~,edges] = histcounts(D(:,3),nBins);

for d = 1:size(D,2)
    N(:,d) = histcounts(D(:,d), edges);
end

x = edges(1:end-1) + .5*diff(edges(1:2));
h = imagesc(x/60000, day(dayOfMonth), 100*(N./sum(N))');
h.Parent.YTick = 1:31;
h.Parent.YTickLabel = datestr(dayOfMonth, 'ddd dd mmm');
xlabel 'Travel time [min]';
title 'Distribution of travel times'
hcb = colorbar;
hcb.Label.String = 'Frequency [%]';
% overlap sigma / mean
hold on;
x = mean(D)' + [1 -1].*std(D)';
y = repmat((1:31)',1,2);
h = plot(x'/60000,y','r');
[h.LineWidth]=deal(2);