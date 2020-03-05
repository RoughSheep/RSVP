 function [eeg_day eeg_eachpeople eeg_allpeople]=main_eeg(num_name,start_day,end_day)
% clear all;
 clc
%% ��ȡ�����ļ�

subject_names=['20181222lwt';'20181223sss';'20181223ww ';'20181224tlx';'20181229yj '];
if num_name<6
    i_name=num_name;
elseif num_name==6  
    i_name=[1 2 3 4 5];
end

    all_eeg_day=zeros(201,9,5);
    eeg_eachpeople_all=zeros(201,5);
    eeg_allpeople_all=zeros(201,1);

for ii=i_name
    if ~(ii==0)
        subject_name=strrep(subject_names(ii,:),' ','');
    end
    
for s=start_day:1:end_day

    
    if s<=5
        filename=['C:\���ʵϰ\RSVP\',num2str(subject_name),'\Day1-5\Day',num2str(s),'\'];

    elseif s>=6
        filename=['C:\���ʵϰ\RSVP\',num2str(subject_name),'\Day6-9\Day',num2str(s),'\'];
    end

%% ��ʼ��
feature=[];label=[];
targetList=[];
numK=3; % ���ڷ�������ݸ���
numTar=4;% ÿ��ʵ������İ��ַ�����
numBlc=20;% ÿ�����ַ�������round����
numTrial=100;% ÿ��round������trial����
numRound=4;

for k=1:1:numK
    channels=[10 28 33 43 48 53 59 61 62 63];% 10 28 33 43 48 53 59 61 62 63
    [sizex,sizey]=size(channels);
       
    lpass=1;
    hpass=20;
    fs=200;%������

    filterorder = 3;
    filtercutoff = [2*lpass/fs 2*hpass/fs];
    [f_b, f_a] = butter(filterorder,filtercutoff);
    
%% �������� ���� �˲�
    file=[filename,num2str(k),'.cnt'];

    eeg=pop_loadcnt(file,'dataformat','int32');
    data=pop_resample(eeg,fs);
%     tStart=0.05;%SWLDA��0.05
%     tEnd=0.8;%SWLDA��0.8
    tStart=-0.2;%SWLDA��0.05 %%��֤�����Ƿ���ȷ�õ�
    tEnd=0.8;%SWLDA��0.8

    fprintf('now filting channel ... \n');
    for j = 1:sizey
        fprintf('.');
        dataall(j,:) = filtfilt(f_b,f_a,double(data.data(channels(j),:)));     %%%�Ȱ�ͨ��filter ʮ��ͨ�� 
    end
    
%% ��ȡ��ǩ ��ǩ��������
%     [targettype TimeFeedback latency type]=extract_label(data.event,numBlc,numTar,numTrial);    %%�����������ǩ
    [targettype TimeFeedback latency type]=extract_label0(data.event,numBlc,numTar,numTrial);    %%�����������ǩ

 
%% Ϊ����һ������
%     for character=1:numBlc
%         for i=1:numTar+numTrial
% %             if latency(i,character)>0
%                 signal(:,:,i+(numTar+numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):10:latency(i,character)+round(tEnd*fs))';
% %             else
% %                 signal(:,:,i+(numTar+numTrial)*(character-1))=nan;                          %% ��֤��ʱ���ò���=1������10
% %             end    
%         end             %%10ͨ�� ÿ����ǩȡ16��ֵ(���ݳ�ʼ��ʱ��ѡ���t����) һ��2080����ǩ 
%     end
    
    for character=1:numBlc
        for i=1:numTrial
            if latency(i,character)>0
                signal(:,:,i+(numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):1:latency(i,character)+round(tEnd*fs))';
            end    
        end             %%10ͨ�� ÿ����ǩȡ16��ֵ(���ݳ�ʼ��ʱ��ѡ���t����) һ��2080����ǩ 
    end
    

    
    clear data dataall;

    feature=cat(3,feature,signal); %%����signal������������feature ��3

    label=[label type];  
    
    targetList=[targetList targettype];

end   
%% ͨ�����б�ǩ������֤��ǩ��ȡ�Ƿ���ȷ �ⲽ��������֤����ĳ����Ƿ���ȷ ��֤��Ͳ���Ҫ��
    j=1;
    
    for k=1:numBlc*numK
        for i=1:numTrial
            if label(i,k)==1
               feature_label(j,:)=feature(:,5,i+numTrial*(k-1));
               j=j+1;
            end
        end
    end
    
    for i=1:numBlc*numTar*numK
        all_eeg_day(:,s,ii)=feature_label(i,:)'+all_eeg_day(:,s,ii);
    end
    eeg_day(:,s,ii)=all_eeg_day(:,s,ii)/(numBlc*numTar*numK);

    eeg_eachpeople_all(:,ii)=eeg_day(:,s,ii)+eeg_eachpeople_all(:,ii);
    
end
eeg_eachpeople(:,ii)=eeg_eachpeople_all(:,ii)/(end_day-start_day+1);

eeg_allpeople_all(:)=eeg_eachpeople(:,ii)+eeg_allpeople_all(:);
end
eeg_allpeople=eeg_allpeople_all/num_name;




