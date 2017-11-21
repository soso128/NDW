fileName = '/Volumes/HDD/Users/lvdgraaff/Dropbox/NDW - Data/A1PwIOktober2017_20171118T193554_196/A1PwIOktober2017_reistijd_00001.csv';
tic
data = importLoopData(fileName);
toc
save('loopdata', 'data');