tic
load loopdata;
hold on;
close all;
fig = figure('color','w')
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
segment = 8;

vidwr=VideoWriter(['eachday_seg8_video.mp4'],'MPEG-4');
vidwr.FrameRate = 3;
open(vidwr);
    
data_seg = segment_number_data(data,segment);

maxax = max(data_seg.avgTravelTime);


    
for i = 1:31
   if (mod(i,7) == 1 || mod(i, 7) ==0)
       leg_str{i} = ['\textit{October ' num2str(i) '}'];
   else
       leg_str{i} = ['October ' num2str(i)];
   end
end
    
for day = 1:31
    hold on;
    index = 60*24*(day-1)+1:60*24*(day);
    p = data_seg.periodStart(index);
    t = data_seg.avgTravelTime(index);
    timeAxis = hours(minutes(1:60*24));
    t(t==-1) = nan;   
    Ph=plot(timeAxis,t);
    axis([0 24 12 maxax + 10])
    box on
    Ph.LineWidth = 2.0;
    xlabel('Time of the day','interpreter','latex')
    title('Travel time during the day on segment no. 8, for each day of the month','interpreter','latex');
    ylabel('Travel time on segment no. 8 (s)','interpreter','latex');

    
    
    %num2str((1:day)', 'October %d')
    legend(leg_str(1:day),'Location', 'eastoutside','interpreter','latex')

    
    frame=getframe(gcf);
    writeVideo(vidwr,frame);
    
    Ph.LineWidth = 0.5;
end
%xlim([7 9])
close(vidwr);
%print('alldays.pdf','-dpdf')
toc