function out = summed_data(data)
        
    out.periodStart = data.periodStart(2:8:end);
    out.avgTravelTime = data.avgTravelTime(2:8:end);
        
    for segment=3:9

        out.avgTravelTime(:) = out.avgTravelTime +  data.avgTravelTime(segment:8:end);

        

        
    end
    
    out.avgTravelTime(out.avgTravelTime < 0) = nan

end