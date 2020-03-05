clear all
clc

import fonction_plot.*;

screen=get(0,'ScreenSize');
W=screen(3);H=screen(4);
my_interface=figure('Color',[1,1,1],'Position',[0.3*H,0.3*H,0.7*W,0.5*H],'Name','RSVP_100Trl_4Trg_20Blc_3Grp_9Day_5Ppl','NumberTitle','off','MenuBar','none');
 
    


%% 熊猫烧香

ha=axes('units','normalized','position',[0.018 0.56 .18 .4]);
uistack(ha,'down')
II=imread('熊猫.jpg');
III=imread('瑞星.jpg');

shizi5=image(III);
panda1=image(II);

colormap gray;
set(ha,'handlevisibility','off','visible','off');


% %% 定义Quit菜单项
% uimenu(gcf,'Label','&Quit','Callback','close(gcf)');
s=1;
while 1
    
switch s
    case 1
        %% 建立弹出框
        %%文本
        popup_name_txt=uicontrol(gcf,'Style','Text','string','被试编号','Position',[20,210,80,20]);

        num_name=1;
        popup_name=uicontrol(gcf,'Style','popup','Units','pixel','String','20181222lwt|20181223sss|20181223ww|20181224tlx|20181229yj|average',...%用|隔开各个选项
            'Position',[100,150,100,80],'Callback',['num_names=[''1'',''2'',''3'',''4'',''5'',''6''];','num_name=str2num(num_names(get(popup_name,''value'')));']);%一个比较好的设置方法


        popup_start_txt=uicontrol(gcf,'Style','Text','string','开始天数','Position',[20,190,80,20]);
        start_day=1;
        popup_start=uicontrol(gcf,'Style','popup','Units','pixel','String','第一天|第二天|第三天|第四天|第五天|第六天|第七天|第八天|第九天',...%用|隔开各个选项
            'Position',[100,130,100,80],'Callback',['starts=[''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9''];','start_day=str2num(starts(get(popup_start,''value'')));']);%一个比较好的设置方法

        popup_end_txt=uicontrol(gcf,'Style','Text','string','结束天数','Position',[20,170,80,20]);
        end_day=1;
        popup_end=uicontrol(gcf,'Style','popup','Units','pixel','String','第一天|第二天|第三天|第四天|第五天|第六天|第七天|第八天|第九天',...%用|隔开各个选项
            'Position',[100,110,100,80],'Callback',['ends=[''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9''];','end_day=str2num(ends(get(popup_end,''value'')));']);%一个比较好的设置方法

        %% 建立复选框
        round_txt=uicontrol(gcf,'Style','Text','Position',[20,120,90,20],'Units','normalized','String','显示哪些round');
        rounds=[0 0 0 0];
        round1=uicontrol(gcf,'Style','check','Position',[20,100,90,20],'Units','normalized','String','round1',...
            'CallBack',['rounds(1)=0;',' if get(round1,''Value'')==1','rounds(1)=1,','end']);

        round2=uicontrol(gcf,'Style','check','Position',[20,80,90,20],'Units','normalized','String','round2',...
            'CallBack',['rounds(2)=0;',' if get(round2,''Value'')==1','rounds(2)=2,','end']);

        round3=uicontrol(gcf,'Style','check','Position',[20,60,90,20],'Units','normalized','String','round3',...
            'CallBack',['rounds(3)=0;',' if get(round3,''Value'')==1','rounds(3)=3,','end']);

        round4=uicontrol(gcf,'Style','check','Position',[20,40,90,20],'Units','normalized','String','round4',...
            'CallBack',['rounds(4)=0;',' if get(round4,''Value'')==1','rounds(4)=4,','end']);



        %% 单击按钮开始学习
        study_start=uicontrol(gcf,'Style','Push','Position',[130,130,70,20],'String','Start Study',...
            'CallBack','acc=main_try2(num_name,start_day,end_day)');

        %% 坐标

        h1=axes('position', [0.25 0.15 0.7 0.7]);

        %% 单击按钮画图
        plot_start=uicontrol(gcf,'Style','Push','Position',[130,100,70,20],'String','Start Plot',...
            'CallBack','data=fonction_plot(acc,start_day,end_day,rounds,num_name,h1)');


        %% 单击按钮保存
        figure_save=uicontrol(gcf,'Style','Push','Position',[130,70,70,20],'String','Save Figure',...
            'CallBack','save_fig(h1)');

        %% 单击按钮画所有图
        show_all=uicontrol(gcf,'Style','Push','Position',[130,40,70,20],'String','Show All',...
            'CallBack','plot_all(start_day,end_day,rounds,acc,data)');

        %%%%%%%%%%%%%%%%%%%%%%%%%%%case2的 需要在1里先显示
        start_analyse_eeg=uicontrol(gcf,'Style','Push','Position',[70,120,100,35],'String','Analyse',...
            'CallBack','[eeg_day eeg_eachpeople eeg_allpeople]=main_eeg(num_name,start_day,end_day)','visible','off');

        plot_start_eeg=uicontrol(gcf,'Style','Push','Position',[70,75,100,35],'String','Plot Average',...
            'CallBack','plot_eeg(num_name,h1,eeg_eachpeople,eeg_allpeople)','visible','off');        
     
        show_all_eeg=uicontrol(gcf,'Style','Push','Position',[70,30,100,35],'String','Show All',...
            'CallBack','plot_all_eeg(num_name,eeg_eachpeople,eeg_day,eeg_allpeople,start_day,end_day)','visible','off');
        
        FFT_eeg=uicontrol(gcf,'Style','Push','Position',[180,30,40,35],'String','FFT',...
            'CallBack','FFT_try','visible','off');        
    case 2
        
 %%%%%%%%%%%%%%%%%%%%%5       
        set(plot_start,'visible','off');
        set(study_start,'visible','off');
        set(round4,'visible','off');
        set(round3,'visible','off');
        set(round2,'visible','off');
        set(round1,'visible','off');
        set(show_all,'visible','off');
        set(round_txt,'visible','off');
        set(figure_save,'visible','off');
%%%%%%%%%%%%%%%%
        num_name=1;
        start_day=1;
        end_day=1;
                
        set(start_analyse_eeg,'visible','on');
        set(plot_start_eeg,'visible','on');
        set(show_all_eeg,'visible','on');
        set(FFT_eeg,'visible','on');
        
    case 3

        
        set(start_analyse_eeg,'visible','off');
        set(plot_start_eeg,'visible','off');
        set(show_all_eeg,'visible','off');    
        set(FFT_eeg,'visible','off');
        
        set(plot_start,'visible','on');
        set(study_start,'visible','on');
        set(round4,'visible','on');
        set(round3,'visible','on');
        set(round2,'visible','on');
        set(round1,'visible','on');
        set(show_all,'visible','on');
        set(round_txt,'visible','on');
        set(figure_save,'visible','on');
end

%%
myhandles.x=0;
myhandles.y=0;
guidata(my_interface,myhandles);  
set(gcf,'WindowButtonDownFcn',{@click_back,my_interface});    




    uiwait(my_interface);
    myhandles=guidata(my_interface);
    if myhandles.x>65 && myhandles.x<170 && myhandles.y>263 && myhandles.y<398
        [panda1,shizi5,s]=figure_exchange(panda1,shizi5,s);
        
        myhandles.x=0
        myhandles.y=0
    end
end

