load loopdata;
%%
p = data.periodStart(1:80:end);
t = data.avgTravelTime(1:80:end);
%N = numel(data.periodStart);
%Nr = 8*floor(N/8);
%p = reshape(data.periodStart(1:Nr), 8, []);
%t = reshape(data.avgTravelTime(1:Nr), 8, []);
%%
clf
t(t==-1) = nan;
plot(p,t);