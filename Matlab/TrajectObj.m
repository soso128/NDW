classdef TrajectObj < handle
    
    properties
        % settings
        nBins = 15;
        windowWidth = 15;
        daysToInclude
        pct = 95
        
        
        % set after loadData()
        Data
        timeOfDay
        dayOfMonth
        nTimeWindows
        
        % set after calculate()
        edges
        TTDistribution
        meanTT
        stdTT
        pctTT
        
        % misc
        dayName = {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'};

    end
    
    methods
        
        function loadData(this, fileName)
            this.Data = importTrajectFCData(fileName);
            this.Data = this.Data';
            
            this.timeOfDay = hours(6)+hours((0:size(this.Data,1)-1)/60); % time in hours
            this.dayOfMonth = datetime(2017,10,1) + days(0:size(this.Data,2)-1);
            this.nTimeWindows = floor(numel(this.timeOfDay)/this.windowWidth);
        end
        
        function calculate(this)
            
            % create edges
            [~,this.edges] = histcounts(this.Data(:,:),this.nBins);
            
            this.TTDistribution = zeros(this.nBins,this.nTimeWindows);
            this.meanTT = zeros(this.nTimeWindows,1);
            this.stdTT = zeros(this.nTimeWindows,1);
            this.pctTT = zeros(this.nTimeWindows,1);

            for j = 1:this.nTimeWindows
                DataW = this.getData(j);
                
                this.TTDistribution(:,j) = histcounts(DataW, this.edges);
                this.meanTT(j) = mean(DataW(:));
                this.stdTT(j) = std(DataW(:));
                this.pctTT(j) = prctile(DataW(:),this.pct);
            end
        end
        
        function DataW = getData(this, j)
            DataW = this.Data((1:this.windowWidth) + (j-1)*this.windowWidth,this.daysToInclude);
        end
        
        function image(this)
                        
            y = this.edges(1:end-1) + .5*diff(this.edges(1:2));
            h = imagesc(1:this.nTimeWindows, y/60000, 100*(this.TTDistribution./sum(this.TTDistribution)));
            h.Parent.YDir='normal';
            h.Parent.XTick = 1:this.nTimeWindows;
            h.Parent.XTickLabel = datestr(this.timeOfDay(1:this.windowWidth:end), 'hh:MM');
            ylabel 'Travel time [min]';
            xlabel 'Time of the day';
            title('Travel time distribution');
            hcb = colorbar;
            hcb.Label.String = 'Frequency [%]';
        end
        
        function plot(this)
            hm = plot(this.meanTT/60000,'r');
            [hm.LineWidth]=deal(2);
            hm.DisplayName = '\mu';
            hs = plot((this.meanTT+2*this.stdTT)/60000,'g');
            [hs.LineWidth]=deal(2);
            hs.DisplayName = '\mu+2\cdot\sigma';
            legend('-DynamicLegend','Location','NorthWest');
        end
        
        function plotP(this)
            hp = plot(this.pctTT/60000,'w');
            [hp.LineWidth]=deal(2);
            hp.DisplayName = sprintf('%d%% pct',this.pct);
            legend('-DynamicLegend','Location','NorthWest');
        end
    end
end