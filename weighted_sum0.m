function [x1 x2 x3 x4] = weighted_sum0(dd_temp,numTrial)
   
    rr_sd(:,1)=dd_temp(1:numTrial,1);

    val=max(rr_sd(:,1));
    [x1 y1]=find(rr_sd(:,1)==val);
   
    rr_sd(x1,1)=NaN;
    val=max(rr_sd(:,1));
    [x2 y2]=find(rr_sd(:,1)==val);
   
    rr_sd(x2,1)=NaN;
    val=max(rr_sd(:,1));
    [x3 y3]=find(rr_sd(:,1)==val); 
   
    rr_sd(x3,1)=NaN;
    val=max(rr_sd(:,1));
    [x4 y4]=find(rr_sd(:,1)==val);    
end

    


