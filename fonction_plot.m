 function data=start_plot(acc,start_day,end_day,rounds,num_name,h1)

if num_name<6
    for i=start_day:1:end_day
        for j=1:4
            if ~(rounds(j)==0)
                data(i,j)=acc(j,3,i,num_name);
            else
                data(i,j)=0;
            end
        end
    end
elseif num_name==6
    for i=start_day:1:end_day
        for j=1:4
            if ~(rounds(j)==0)
                data(i,j)=(acc(j,3,i,1)+acc(j,3,i,2)+acc(j,3,i,3)+acc(j,3,i,4)+acc(j,3,i,5))/5;
            else
                data(i,j)=0;
            end
        end
    end       
end

axes(h1);

b = bar(data);

ch = get(b,'children');

set(gca,'XTickLabel',{'第一天','第二天','第三天','第四天','第五天','第六天','第七天','第八天','第九天'})

legend('round1','round2','round3','round4');

ylabel('正确率');