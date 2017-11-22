close all;
load loopdata;

times = data.periodStart(2:8:end);

plot(times)