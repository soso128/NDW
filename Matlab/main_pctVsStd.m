T = TrajectObj;
T.nBins = 15;
T.windowWidth = 15;
T.loadData('/Volumes/HDD/Users/lvdgraaff/Dropbox/Physics with NDW/FCD_fulltrajectory/tableFCDalldays.csv');
%% plot data for all weekdays

T.daysToInclude = mod(weekday(T.dayOfMonth),7)>1;
T.calculate();

clf;
T.image();
hold on;
T.plot();
title('Travel time distribution for all working days');
T.plotP
%% find best c
p = 10:1:99;
c = zeros(size(p));
sc = zeros(size(p));
for i = 1:numel(p)
    T.pct = p(i);
    T.calculate();
    
    c(i) = T.stdTT\(T.pctTT-T.meanTT);
    sc(i) = std(T.stdTT.\(T.pctTT-T.meanTT));
end

errorbar(p, c, sc);
ylabel 'c = Number of times \sigma'
xlabel 'Percentile to estimate';
title 'Estimating percentiles as \mu + c\cdot \sigma';

%% find best c for all days of the week
clf

for j = 2:6
    hold on
    
    p = 10:1:99;
    c = zeros(size(p));
    sc = zeros(size(p));
    for i = 1:numel(p)
        T.pct = p(i);
        T.daysToInclude = j;
        T.calculate();
        
        c(i) = T.stdTT\(T.pctTT-T.meanTT);
        sc(i) = std(T.stdTT.\(T.pctTT-T.meanTT));
    end
    
    errorbar(p, c, sc);
    ylabel 'c = Number of times \sigma'
    xlabel 'Percentile to estimate';
    title 'Estimating percentiles as \mu + c\cdot \sigma';
end

%% how reliable can I estimate my percentile?!
clf
p = 10:1:99;
meanError = zeros(size(p));
stdError = zeros(size(p));
for i = 1:numel(p)
    T.pct = p(i);
    T.calculate();
    
    c = T.stdTT\(T.pctTT-T.meanTT);
    
    error = (T.meanTT+c*T.stdTT) - T.pctTT;
    meanError(i) = mean(error);
    stdError(i) = std(error);
end

errorbar(p, meanError/60000, stdError/60000);
ylabel 'Error of estimate [min]'
xlabel 'Percentile to estimate';
title 'How reliable can I estimate my percentile';

%% how reliable can I estimate on every day of the week
clf

% calibrate on WORKING DAYS
p = 10:1:99;
c = zeros(size(p));
for i = 1:numel(p)
    T.pct = p(i);
    T.daysToInclude = mod(weekday(T.dayOfMonth),7)>1;
    T.calculate();
    
    c(i) = T.stdTT\(T.pctTT-T.meanTT);
end

% test on individual DAYS OF THE WEEK
for j = 1:7
    p = 10:1:99;
    meanError = zeros(size(p));
    %stdError = zeros(size(p));
    for i = 1:numel(p)
        T.pct = p(i);
        T.daysToInclude = j;
        T.calculate();

        error = (T.meanTT+c(i)*T.stdTT) - T.pctTT;
        meanError(i) = rms(error./T.pctTT);
        %stdError(i) = std(error);
    end

    %errorbar(p, meanError/60000, stdError/60000);
    h = plot(p, meanError*100);
    h.DisplayName = T.dayName{j};
    hold on
    
end
plot(xlim, 10*[1 1], 'k--')
ylabel 'Error of estimate [%]'
xlabel 'Percentile to estimate';
title 'How reliable can I estimate my percentile?';
legend -DynamicLegend
legend Location NorthWest
%% Show how it works for weekdays
clf
T.pct = 80;
T.daysToInclude = mod(weekday(T.dayOfMonth),7)>1;
T.calculate();

clf;
T.image();
hold on;
T.plotP
c = T.stdTT\(T.pctTT-T.meanTT);
h = plot((T.meanTT+c*T.stdTT)/60000, 'r');
h.LineWidth = 2;
h.DisplayName = sprintf('\\mu+%.2f\\sigma', c);

%% make a movie of it
fps = 30;
duration = 10;
t = linspace(0,1,fps*duration);

v = VideoWriter('PctFromStd','MPEG-4');
open(v);

hFig = figure;
hFig.WindowStyle='normal';

P = Progress('creating video', numel(t));
for i = 1:numel(t)
    P.step(i);
    T.pct = 75+25*cos(acos(20/25) + 2*pi*t(i));
    T.daysToInclude = mod(weekday(T.dayOfMonth),7)>1;
    T.calculate();
    
    clf;
    T.image();
    hold on;
    h = T.plotP();
    h.LineWidth=4;
    c = T.stdTT\(T.pctTT-T.meanTT);
    h = plot((T.meanTT+c*T.stdTT)/60000, 'r');
    h.LineWidth = 4;
    h.DisplayName = sprintf('\\mu+%.2f\\sigma', c);
    
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
    hFig.Position = [0 0 1000 600];
    
   
    frame = getframe(gcf);
    writeVideo(v,frame);
end
P.done
close(v);
