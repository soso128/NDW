tic
load loopdata;

set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

data_summed = summed_data(data);

maxax = max(data_summed.avgTravelTime);

fig = figure('color','w');
vidwr=VideoWriter(['eachday_summed_video.mp4'],'MPEG-4');
vidwr.FrameRate = 2;
open(vidwr);
filename = 'eachday_summed.gif'
    
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
    p = data_summed.periodStart(index);
    t = data_summed.avgTravelTime(index);
    timeAxis = hours(minutes(1:60*24));
    t(t==-1) = nan;   
    Ph=plot(timeAxis,t);
    axis([0 24 0 maxax + 10])
    box on
    Ph.LineWidth = 2.0;
    xlabel('Time of the day (h)','interpreter','Latex')
    title('Travel time during the day on full trajectory, for each day of the month','interpreter','Latex')
    ylabel('Travel time on full trajectory (s)','interpreter','latex')

    legend(leg_str(1:day),'Location', 'eastoutside','interpreter','latex')

    
    frame=getframe(gcf);
    writeVideo(vidwr,frame);
    
    Ph.LineWidth = 0.5;
end
%xlim([7 9])
close(vidwr);
%print('alldays.pdf','-dpdf')
toc