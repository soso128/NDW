%Data = importLoopData('/Volumes/HDD/Users/lvdgraaff/Dropbox/NDW - Data/A1PwIOktober2017_20171118T193554_196/A1PwIOktober2017_reistijd_00001.csv');
fileName = '/Volumes/HDD/Users/lvdgraaff/Dropbox/NDW - Data/A1PwIOktober2017_20171118T193554_196/A1PwIOktober2017_reistijd_00001.csv';
% fh = fopen(fileName);
% headerData = fgetl(fh);
% 
% L = 1000;
% 
% 
% data.measurementSiteReference = strings(L,1);
% data.periodStart = NaT(L,1);
% data.dataError = false(L,1);
% data.avgTravelTime = zeros(L,1);
% 
% % data.startLocatieForDisplayLat = zeros(L,1);
% % data.startLocatieForDisplayLong = zeros(L,1);
% % data.eindLocatieForDisplayLat = zeros(L,1);
% % data.eindLocatieForDisplayLong = zeros(L,1);
% 
% 
% tic
% for i = 1:L
%     lineData = fgetl(fh);
%     lineData = strsplit(lineData,',');
%     
%     data.measurementSiteReference(i) = lineData{1};
%     data.periodStart(i) = datetime(lineData{4},'InputFormat', 'yyyy-MM-dd HH:mm:ss');
%     data.avgTravelTime(i) = sscanf(lineData{19},'%f');
%     data.dataError(i) = logical(sscanf(lineData{15}, '%d'));
% end
% toc

tic
data = importLoopData(fileName);
toc

save('loopdata', 'data');