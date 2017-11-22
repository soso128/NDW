function out=segment_number_data(data,segmentnumber)
    segmentnumber = segmentnumber + 1 ;
    out.measurementSiteReference = data.measurementSiteReference(segmentnumber:8:end);

    out.periodStart = data.periodStart(segmentnumber:8:end);

    out.avgTravelTime =  data.avgTravelTime(segmentnumber:8:end);
    
    out.avgTravelTime(out.avgTravelTime==-1) = nan;
    
    out.dataError = data.dataError(segmentnumber:8:end);

end