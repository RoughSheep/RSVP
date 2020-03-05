 function acc=main_try2(num_name,start_day,end_day)
% clear all;
 clc
%% ��ȡ�����ļ�

subject_names=['20181222lwt';'20181223sss';'20181223ww ';'20181224tlx';'20181229yj '];
if num_name<6
    i=num_name;
elseif num_name==6  
    i=[1 2 3 4 5];
end

for ii=i
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

    for character=1:numBlc
        for i=1:numTrial
            if latency(i,character)>0
                signal(:,:,i+(numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):10:latency(i,character)+round(tEnd*fs))';
            end    
        end             %%10ͨ�� ÿ����ǩȡ16��ֵ(���ݳ�ʼ��ʱ��ѡ���t����) һ��2080����ǩ 
    end
    

    
    clear data dataall;

    feature=cat(3,feature,signal); %%����signal������������feature ��3

    label=[label type];  
    
    targetList=[targetList targettype];

    
end



%% ������֤����
feature0=(reshape(feature,[],numBlc*numTrial*k))'; %%����feature sizefeature=16 10 6240 sizefeature0=6240 160
label00=reshape(label,[],1);  %%sizelabel=104 60  sizelabel00=6240
label0=(label00-0.5)*2;  % 1 0 ��� 1 -1
Indices =1:numK*numBlc;
% Indices = crossvalind('Kfold',numK*numBlc,numK*numBlc);  %%3*10=30 һ��30���� �ֳ�30���� �Լ����Լ��� һ��һ�� (һ����һ�� ��30����)
for n=1:1:numK*numBlc
    I_train=find(Indices~=n);    %%%find�����ҵ�����������Ԫ�����
    I_test=find(Indices==n);
    II_train=get_train_label(I_train,numTrial); %%chan_number=max��chan_ind��= 29 or 30
                                                            %%ind_temp=1:chan_number*chan_length=1��29*26*10=7540
                                                            %%30*260=7800
  
    II_test=get_train_label(I_test,numTrial);
    % SWLDA
   
    [b,se,pval,inmodel,stats,nextstep,history]=stepwisefit(feature0(II_train,:),...
        label0(II_train,:),'penter',0.1,'premove',0.15,'display','off','maxiter',60);
    [p_label_temp D]=q_classify(feature0(II_test,inmodel),feature0(II_train,inmodel),label0(II_train));

    dd_temp=D(:,2)-D(:,1); %SWLDA����ֵ 
    
    [xx x] = weighted_sum00(dd_temp,numTrial,n);% x1:char acc; x2:round acc
    
    labelPreBuff=find(label0(II_test)==1);   %%���Լ��İ�
    labelPre(n)=labelPreBuff(1);           %%ÿ�εĲ��Լ��ĵ�һ����
    
    PredictChar(:,n)=[x(1);x(2);x(3);x(4)];
    PredictRound(:,n)=[xx(1) xx(2) xx(3) xx(4)];
    
end

for n=1:1:numK*numBlc
    tarBuff(n)=find(Indices==n);
end

targetListBuff=targetList(:,tarBuff);

counter01=0;
for n=1:1:numK*numBlc
    i=1;
    for i=1:numRound
        if PredictChar(i,n)==targetListBuff(1,n)||PredictChar(i,n)==targetListBuff(2,n)||PredictChar(i,n)==targetListBuff(3,n)||PredictChar(i,n)==targetListBuff(4,n)
            counter01=counter01+1;
        end
    end
end

counter001=0;
for n=1:1:numK*numBlc
    i=1;
    for i=1:numRound
        if PredictRound(i,n)==targetListBuff(1,n)||PredictRound(i,n)==targetListBuff(2,n)||PredictRound(i,n)==targetListBuff(3,n)||PredictRound(i,n)==targetListBuff(4,n)
            counter001=counter001+1;
        end
    end
end


counter0=[0 0 0 0];
for k=1:numRound
    for n=1:numBlc*numK
        if PredictChar(1,n)==targetListBuff(k,n)||PredictChar(2,n)==targetListBuff(k,n)||PredictChar(3,n)==targetListBuff(k,n)||PredictChar(4,n)==targetListBuff(k,n)
            counter0(k)=counter0(k)+1;
        end
    end
end

counter00=[0 0 0 0];
for k=1:numRound
    for n=1:numBlc*numK
        if PredictRound(1,n)==targetListBuff(k,n)||PredictRound(2,n)==targetListBuff(k,n)||PredictRound(3,n)==targetListBuff(k,n)||PredictRound(4,n)==targetListBuff(k,n)
            counter00(k)=counter00(k)+1;
        end
    end
end

acc(:,1,s,ii)=counter00/(size(targetListBuff,2));    
acc(:,3,s,ii)=counter0/(size(targetListBuff,2));      
acc(1,4,s,ii)=counter01/numel(targetListBuff);
acc(1,2,s,ii)=counter001/numel(targetListBuff)

end
end
