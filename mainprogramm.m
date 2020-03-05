clear all;
clc;


name=input('请输入测试文件名：','s');
start_day=input('从哪天开始：');
end_day=input('到哪天结束：');
acc=main_try2(name,start_day,end_day);



% draw=input('想画那个round的图：')

% for n=start_day:1:end_day
%     round1(n)=acc(1,1,n);
% end
%     plot1=plot(round1)
%     
% for n=start_day:1:end_day
%     round2(n)=acc(2,1,n);
% end
%     plot2=plot(round2)
%     
% for n=start_day:1:end_day    
%     round3(n)=acc(3,1,n)
% end
%     plot3=plot(round2);
%     
% for n=start_day:1:end_day        
%     round4(n)=acc(4,1,n);
% end
%     plot4=plot(round2)  


for i=start_day:1:end_day
    for j=1:4
        data(i,j)=[acc(j,1,i)];
    end
end

b = bar(data);

ch = get(b,'children');

set(gca,'XTickLabel',{'第一天','第二天','第三天','第四天','第五天','第六天','第七天','第八天','第九天'})

legend('round1','round2','round3','round4');

ylabel('正确率');
