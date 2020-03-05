function [x1,x2] = weighted_sum(dd_temp,numRound,numTrial)

   sumBuff(:,1)=dd_temp(1:numTrial,1);
   sumBuff(:,2)=dd_temp(numTrial+1:numTrial*2,1)+sumBuff(:,1);
   sumBuff(:,3)=dd_temp(numTrial*2+1:numTrial*3,1)+sumBuff(:,2);
   sumBuff(:,4)=dd_temp(numTrial*3+1:numTrial*4,1)+sumBuff(:,3);
   sumBuff(:,5)=dd_temp(numTrial*4+1:numTrial*5,1)+sumBuff(:,4);

   rr_sd(:,1)=dd_temp(1:numTrial,1);
   rr_sd(:,2)=dd_temp(numTrial+1:numTrial*2,1);
   rr_sd(:,3)=dd_temp(numTrial*2+1:numTrial*3,1);
   rr_sd(:,4)=dd_temp(numTrial*3+1:numTrial*4,1);
   rr_sd(:,5)=dd_temp(numTrial*4+1:numTrial*5,1);
   if numRound==10
       sumBuff(:,6)=dd_temp(numTrial*5+1:numTrial*6,1)+sumBuff(:,5);
       sumBuff(:,7)=dd_temp(numTrial*6+1:numTrial*7,1)+sumBuff(:,6);
       sumBuff(:,8)=dd_temp(numTrial*7+1:numTrial*8,1)+sumBuff(:,7);
       sumBuff(:,9)=dd_temp(numTrial*8+1:numTrial*9,1)+sumBuff(:,8);
       sumBuff(:,10)=dd_temp(numTrial*9+1:numTrial*10,1)+sumBuff(:,9);
   
       rr_sd(:,6)=dd_temp(numTrial*5+1:numTrial*6,1);
       rr_sd(:,7)=dd_temp(numTrial*6+1:numTrial*7,1);
       rr_sd(:,8)=dd_temp(numTrial*7+1:numTrial*8,1);
       rr_sd(:,9)=dd_temp(numTrial*8+1:numTrial*9,1);
       rr_sd(:,10)=dd_temp(numTrial*9+1:numTrial*10,1);
   end
   
   for i=1:numRound  % x refer to char predict; y refer to unit predict;
        val=max(rr_sd(:,i));
        [x1(i) y1(i)]=find(rr_sd(:,i)==val);
        valsum=max(sumBuff(:,i));
        [x2(i) y2(i)]=find(sumBuff(:,i)==valsum);
   end
end

