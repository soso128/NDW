T = TrajectObj;
T.nBins = 15;
T.windowWidth = 15;
T.loadData('/Volumes/HDD/Users/lvdgraaff/Dropbox/Physics with NDW/FCD_fulltrajectory/tableFCDalldays.csv');
%% plot data for one day in the week
dayOfWeek = 2; % select the day (Sunday == 1)
T.daysToInclude = weekday(T.dayOfMonth)==dayOfWeek; 
T.calculate();

clf;
T.image();
hold on;
T.plot();
title(sprintf('Travel time distribution for %s', T.dayName{dayOfWeek}));

%% plot data for all weekdays

T.daysToInclude = mod(weekday(T.dayOfMonth),7)>1;
T.calculate();

clf;
T.image();
hold on;
T.plot();
title('Travel time distribution for all working days');


%% add pct
T.plotP()