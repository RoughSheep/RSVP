% clear all;
% clc
% %% ��ȡ�����ļ�
% s=1;
% switch s
%     case 1
%         filename{1}='C:\���ʵϰ\RSVP\20181222lwt\Day1-5\Day1\';
%     case 2
%         filename{2}='C:\���ʵϰ\RSVP\20181223sss\Day1-5\Day5\';
% end
% 
% %% ��ʼ��
% feature=[];label=[];
% targetList=[];
% numK=3; % ���ڷ�������ݸ���
% numTar=4;% ÿ��ʵ������İ��ַ�����
% numBlc=20;% ÿ�����ַ�������round����
% numTrial=100;% ÿ��round������trial����
% numRound=4;
% for k=1:1:numK
%     channels=[10 28 33 43 48 53 59 61 62 63];% 10 28 33 43 48 53 59 61 62 63
%     [sizex,sizey]=size(channels);
%        
%     lpass=1;
%     hpass=20;
%     fs=200;%������
% 
%     filterorder = 3;
%     filtercutoff = [2*lpass/fs 2*hpass/fs];
%     [f_b, f_a] = butter(filterorder,filtercutoff);
%     
% %% �������� ���� �˲�
%     file=[filename{s},num2str(k),'.cnt'];
%     eeg=pop_loadcnt(file,'dataformat','int32');
%     data=pop_resample(eeg,fs);
% %     tStart=0.05;%SWLDA��0.05
% %     tEnd=0.8;%SWLDA��0.8
%     tStart=-0.2;%SWLDA��0.05 %%��֤�����Ƿ���ȷ�õ�
%     tEnd=0.8;%SWLDA��0.8
% 
%     fprintf('now filting channel ... \n');
%     for j = 1:sizey
%         fprintf('.');
%         dataall(j,:) = filtfilt(f_b,f_a,double(data.data(channels(j),:)));     %%%�Ȱ�ͨ��filter ʮ��ͨ�� 
%     end
%     
% %% ��ȡ��ǩ ��ǩ��������
% %     [targettype TimeFeedback latency type]=extract_label(data.event,numBlc,numTar,numTrial);    %%�����������ǩ
%     [targettype TimeFeedback latency type]=extract_label0(data.event,numBlc,numTar,numTrial);    %%�����������ǩ
% 
%  
% %% Ϊ����һ������
% %     for character=1:numBlc
% %         for i=1:numTar+numTrial
% % %             if latency(i,character)>0
% %                 signal(:,:,i+(numTar+numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):10:latency(i,character)+round(tEnd*fs))';
% % %             else
% % %                 signal(:,:,i+(numTar+numTrial)*(character-1))=nan;                          %% ��֤��ʱ���ò���=1������10
% % %             end    
% %         end             %%10ͨ�� ÿ����ǩȡ16��ֵ(���ݳ�ʼ��ʱ��ѡ���t����) һ��2080����ǩ 
% %     end
%     
%     for character=1:numBlc
%         for i=1:numTrial
%             if latency(i,character)>0
%                 signal(:,:,i+(numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):1:latency(i,character)+round(tEnd*fs))';
%             end    
%         end             %%10ͨ�� ÿ����ǩȡ16��ֵ(���ݳ�ʼ��ʱ��ѡ���t����) һ��2080����ǩ 
%     end
%     
% 
%     
%     clear data dataall;
% 
%     feature=cat(3,feature,signal); %%����signal������������feature ��3
% 
%     label=[label type];  
%     
%     targetList=[targetList targettype];
% 
% end   
% %% ͨ�����б�ǩ������֤��ǩ��ȡ�Ƿ���ȷ �ⲽ��������֤����ĳ����Ƿ���ȷ ��֤��Ͳ���Ҫ��
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
    
open('ÿ�������˵�erpƽ��.fig');
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
% ��db4С����������һά����С���任
c=cwt(xdata{1},ydata{1},1:48,'amor','plot');
subplot(122);
% ����ѡ��߶Ⱥ����һά����С���任
c=cwt(ydata(1),2:2:128,'db4','plot');