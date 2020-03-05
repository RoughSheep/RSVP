function plot_all(start_day,end_day,rounds,acc,data)

subject_names=['20181222lwt';'20181223sss';'20181223ww ';'20181224tlx';'20181229yj '];

for num_name=1:5
    plot_name=[,strrep(subject_names(num_name,:),' ',''),];
    figure('name',plot_name);
    for i=start_day:1:end_day
        for j=1:4
            if ~(rounds(j)==0)
                data_all(i,j)=acc(j,3,i,num_name);
            else
                data_all(i,j)=0;
            end
        end
    end
    
    b = bar(data_all);
    
    ch = get(b,'children');

    set(gca,'XTickLabel',{'��һ��','�ڶ���','������','������','������','������','������','�ڰ���','�ھ���'})

    legend('round1','round2','round3','round4');

    ylabel('��ȷ��');
end

figure('name','average');

b = bar(data);

ch = get(b,'children');

set(gca,'XTickLabel',{'��һ��','�ڶ���','������','������','������','������','������','�ڰ���','�ھ���'})

legend('round1','round2','round3','round4');

ylabel('��ȷ��');
