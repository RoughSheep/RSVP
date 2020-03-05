function [xx x] = weighted_sum00(dd_temp,numTrial,n)

    global sumBuff;

    rr_sd(:,1)=dd_temp(1:numTrial,1);

    val=max(rr_sd(:,1));
    [x(1) y1]=find(rr_sd(:,1)==val);
   
    rr_sd(x(1),1)=NaN;
    val=max(rr_sd(:,1));
    [x(2) y2]=find(rr_sd(:,1)==val);
   
    rr_sd(x(2),1)=NaN;
    val=max(rr_sd(:,1));
    [x(3) y3]=find(rr_sd(:,1)==val); 
   
    rr_sd(x(3),1)=NaN;
    val=max(rr_sd(:,1));
    [x(4) y4]=find(rr_sd(:,1)==val);  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if n<=4
   sumBuff(:,n)=dd_temp(1:numTrial,1);
elseif n>4
   sumBuff(:,n)=dd_temp(1:numTrial,1)+sumBuff(:,n-4);
end  

    valsum(1)=max(sumBuff(:,n));
    [xx(1) yy1]=find(sumBuff(:,n)==valsum(1));
   
    sumBuff(xx(1),n)=NaN;
    valsum(2)=max(sumBuff(:,n));
    [xx(2) yy2]=find(sumBuff(:,n)==valsum(2));
   
    sumBuff(xx(2),n)=NaN;
    valsum(3)=max(sumBuff(:,n));
    [xx(3) yy3]=find(sumBuff(:,n)==valsum(3)); 
   
    sumBuff(xx(3),n)=NaN;
    valsum(4)=max(sumBuff(:,n));
    [xx(4) yy4]=find(sumBuff(:,n)==valsum(4));  
    
    sumBuff(xx(1),n)=valsum(1);
    sumBuff(xx(2),n)=valsum(2);
    sumBuff(xx(3),n)=valsum(3);
    sumBuff(xx(4),n)=valsum(4);
    
end

    

