load loopdata;
%%
clf
for j = 1:8
    p = data.periodStart(j:8:end);
    t = data.avgTravelTime(j:8:end);
    t(t==-1) = nan;
    %
    N = numel(t);
    m = 24*60;
    Nr = m*floor(numel(t)/m);
    t = reshape(t(1:Nr), m, []);
    tavg = nanmean(t,2);
    tavgs = smooth(tavg,61);
    baseline = mean(tavgs(1:60));
    timeAxis = hours(minutes(1:m));
    plot(timeAxis(1:31:end), tavgs(1:31:end)/baseline*100)
    hold on
end

xlabel 'Time of the day'
title 'Month averaged data of October 2017';
ylabel 'Deviation from free flow travel time [%]';
legend(num2str((1:8)', 'segment %d'),'Location', 'Northwest')