 function start_plot_eeg(num_name,eeg_eachpeople,eeg_day,eeg_allpeople,start_day,end_day)

subject_names=['20181222lwt';'20181223sss';'20181223ww ';'20181224tlx';'20181229yj '];
%%%%这是画 ‘每个人每天的’ 和 ‘每个人所有天的平均’
% % for jj=1:5
% %     for i=start_day:1:end_day
% % 
% %         if jj==num_name || num_name==6
% %             plot_name=[,strrep(subject_names(jj,:),' ',''),];
% %             day_plot_name=[plot_name,'_',num2str(i)];
% %             figure('name',day_plot_name);
% %             plot(eeg_day(:,i,jj));
% %         end
% %     end
% %     
% %     if jj==num_name || num_name==6
% %         people_plot_name=[plot_name,'_average'];
% %         figure('name',people_plot_name);
% %         plot(eeg_eachpeople(:,jj));
% %     end
% % end

%% 这个是画每一天所有人平均

t=-0.2:0.005:0.8;
eeg_perday=zeros(201,9);
if num_name==6
    
%     perday_plot_name=[plot_name,'_',num2str(i)];
    figure('name','average_perday');

    for i=start_day:1:end_day
        for jj=1:5
            eeg_perday(:,i)=eeg_day(:,i,jj)+eeg_perday(:,i);        
        end  

        plot(t,eeg_day(:,i));
        hold on;

    end
    legend('1','2','3','4','5');
end

if num_name==6
    
    figure('name','all_average');

    plot(eeg_allpeople);

end