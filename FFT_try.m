% clear all;
% clc
% %% 读取数据文件
% s=1;
% switch s
%     case 1
%         filename{1}='C:\天大实习\RSVP\20181222lwt\Day1-5\Day1\';
%     case 2
%         filename{2}='C:\天大实习\RSVP\20181223sss\Day1-5\Day5\';
% end
% 
% %% 初始化
% feature=[];label=[];
% targetList=[];
% numK=3; % 用于分类的数据个数
% numTar=4;% 每组实验包括的靶字符个数
% numBlc=20;% 每个靶字符包含的round个数
% numTrial=100;% 每个round包含的trial个数
% numRound=4;
% for k=1:1:numK
%     channels=[10 28 33 43 48 53 59 61 62 63];% 10 28 33 43 48 53 59 61 62 63
%     [sizex,sizey]=size(channels);
%        
%     lpass=1;
%     hpass=20;
%     fs=200;%采样率
% 
%     filterorder = 3;
%     filtercutoff = [2*lpass/fs 2*hpass/fs];
%     [f_b, f_a] = butter(filterorder,filtercutoff);
%     
% %% 加载数据 采样 滤波
%     file=[filename{s},num2str(k),'.cnt'];
%     eeg=pop_loadcnt(file,'dataformat','int32');
%     data=pop_resample(eeg,fs);
% %     tStart=0.05;%SWLDA：0.05
% %     tEnd=0.8;%SWLDA：0.8
%     tStart=-0.2;%SWLDA：0.05 %%验证波形是否正确用的
%     tEnd=0.8;%SWLDA：0.8
% 
%     fprintf('now filting channel ... \n');
%     for j = 1:sizey
%         fprintf('.');
%         dataall(j,:) = filtfilt(f_b,f_a,double(data.data(channels(j),:)));     %%%先按通道filter 十个通道 
%     end
%     
% %% 提取标签 标签重新排序
% %     [targettype TimeFeedback latency type]=extract_label(data.event,numBlc,numTar,numTrial);    %%这是重排序标签
%     [targettype TimeFeedback latency type]=extract_label0(data.event,numBlc,numTar,numTrial);    %%这是重排序标签
% 
%  
% %% 为了下一步采样
% %     for character=1:numBlc
% %         for i=1:numTar+numTrial
% % %             if latency(i,character)>0
% %                 signal(:,:,i+(numTar+numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):10:latency(i,character)+round(tEnd*fs))';
% % %             else
% % %                 signal(:,:,i+(numTar+numTrial)*(character-1))=nan;                          %% 验证的时候用步长=1而不是10
% % %             end    
% %         end             %%10通道 每个标签取16个值(根据初始化时候选择的t参数) 一共2080个标签 
% %     end
%     
%     for character=1:numBlc
%         for i=1:numTrial
%             if latency(i,character)>0
%                 signal(:,:,i+(numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):1:latency(i,character)+round(tEnd*fs))';
%             end    
%         end             %%10通道 每个标签取16个值(根据初始化时候选择的t参数) 一共2080个标签 
%     end
%     
% 
%     
%     clear data dataall;
% 
%     feature=cat(3,feature,signal); %%三个signal叠加起来就是feature 乘3
% 
%     label=[label type];  
%     
%     targetList=[targetList targettype];
% 
% end   
% %% 通过画靶标签波形验证标签提取是否正确 这步是用来验证上面的程序是否正确 验证后就不需要了
%     j=1;
%     for k=1:numBlc*numK
%         for i=1:numTrial
%             if label(i,k)==1
%                feature_label(j,:)=feature(:,5,i+numTrial*(k-1));
%                j=j+1;
%             end
%         end
%     end
%     all=[0];
%     for i=1:numBlc*numTar*numK
%         all=feature_label(i,:)+all;
%     end
%     moy=all/numBlc*numTar*numK;
%     plot(moy(1,:));
    
open('每天所有人的erp平均.fig');
line=get(gca,'Children');%get line handles
xdata=get(line,'Xdata');
ydata=get(line,'Ydata');


L=200;
Fs=1000;
% 
% for k=1:9
%     Y = fft(ydata{k});
%     P2 = abs(Y/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     f = Fs*(0:(L/2))/L;
%     figure;
%     plot(f,P1) 
%     title('Single-Sided Amplitude Spectrum of X(t)')
%     xlabel('f (Hz)')
%     ylabel('|P1(f)|')
% end

figure(2);
plot(xdata{1},ydata{1});
figure(3);
subplot(121);
% 用db4小波函数进行一维连续小波变换
c=cwt(xdata{1},ydata{1},1:48,'amor','plot');
subplot(122);
% 重新选择尺度后进行一维连续小波变换
c=cwt(ydata(1),2:2:128,'db4','plot');