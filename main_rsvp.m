clear all;
clc
%% 读取数据文件
s=1;
switch s
    case 1
        filename{1}='C:\天大实习\RSVP\20181222lwt\Day1-5\Day1\';
    case 2
        filename{2}='C:\天大实习\RSVP\20181223sss\Day1-5\Day5\';
end

%% 初始化
feature=[];label=[];
targetList=[];
numK=3; % 用于分类的数据个数
numTar=4;% 每组实验包括的靶字符个数
numBlc=20;% 每个靶字符包含的round个数
numTrial=100;% 每个round包含的trial个数
numRound=4;
for k=1:1:numK
    channels=[10 28 33 43 48 53 59 61 62 63];% 10 28 33 43 48 53 59 61 62 63
    [sizex,sizey]=size(channels);
       
    lpass=1;
    hpass=20;
    fs=200;%采样率

    filterorder = 3;
    filtercutoff = [2*lpass/fs 2*hpass/fs];
    [f_b, f_a] = butter(filterorder,filtercutoff);
    
%% 加载数据 采样 滤波
    file=[filename{s},num2str(k),'.cnt'];
    eeg=pop_loadcnt(file,'dataformat','int32');
    data=pop_resample(eeg,fs);
%     tStart=0.05;%SWLDA：0.05
%     tEnd=0.8;%SWLDA：0.8
    tStart=-0.2;%SWLDA：0.05 %%验证波形是否正确用的
    tEnd=0.8;%SWLDA：0.8

    fprintf('now filting channel ... \n');
    for j = 1:sizey
        fprintf('.');
        dataall(j,:) = filtfilt(f_b,f_a,double(data.data(channels(j),:)));     %%%先按通道filter 十个通道 
    end
    
%% 提取标签 标签重新排序
%     [targettype TimeFeedback latency type]=extract_label(data.event,numBlc,numTar,numTrial);    %%这是重排序标签
    [targettype TimeFeedback latency type]=extract_label0(data.event,numBlc,numTar,numTrial);    %%这是重排序标签

 
%% 为了下一步采样
%     for character=1:numBlc
%         for i=1:numTar+numTrial
% %             if latency(i,character)>0
%                 signal(:,:,i+(numTar+numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):10:latency(i,character)+round(tEnd*fs))';
% %             else
% %                 signal(:,:,i+(numTar+numTrial)*(character-1))=nan;                          %% 验证的时候用步长=1而不是10
% %             end    
%         end             %%10通道 每个标签取16个值(根据初始化时候选择的t参数) 一共2080个标签 
%     end
    
    for character=1:numBlc
        for i=1:numTrial
            if latency(i,character)>0
                signal(:,:,i+(numTrial)*(character-1))=dataall(:,latency(i,character)+round(tStart*fs):1:latency(i,character)+round(tEnd*fs))';
            end    
        end             %%10通道 每个标签取16个值(根据初始化时候选择的t参数) 一共2080个标签 
    end
    

    
    clear data dataall;

    feature=cat(3,feature,signal); %%三个signal叠加起来就是feature 乘3

    label=[label type];  
    
    targetList=[targetList targettype];

end   
%% 通过画靶标签波形验证标签提取是否正确 这步是用来验证上面的程序是否正确 验证后就不需要了
    j=1;
    for k=1:numBlc*numK
        for i=1:numTrial
            if label(i,k)==1
               feature_label(j,:)=feature(:,5,i+numTrial*(k-1));
               j=j+1;
            end
        end
    end
    all=[0];
    for i=1:numBlc*numTar*numK
        all=feature_label(i,:)+all;
    end
    moy=all/numBlc*numTar*numK;
    plot(moy(1,:));
    



%% 交叉验证分类
feature0=(reshape(feature,[],numBlc*numTrial*k))'; %%重组feature sizefeature=16 10 6240 sizefeature0=6240 160
label00=reshape(label,[],1);  %%sizelabel=104 60  sizelabel00=6240
label0=(label00-0.5)*2;  % 1 0 变成 1 -1
Indices =1:numK*numBlc;
% Indices = crossvalind('Kfold',numK*numBlc,numK*numBlc);  %%3*10=30 一共30个组 分成30个层 自己做自己的 一组一层 (一个靶一组 共30个靶)
for n=1:1:numK*numBlc
    I_train=find(Indices~=n);    %%%find可以找到符合条件的元素序号
    I_test=find(Indices==n);
    II_train=get_train_label(I_train,numTrial); %%chan_number=max（chan_ind）= 29 or 30
                                                            %%ind_temp=1:chan_number*chan_length=1：29*26*10=7540
                                                            %%30*260=7800
   % sizef=size(II_train)
   % fprintf('n=%u\n',n)    %%%我测试用的    
   % fprintf('INDICES=%u\n',max(I_train))    %%%我测试用的     
    II_test=get_train_label(I_test,numTrial);
    % SWLDA
   
    [b,se,pval,inmodel,stats,nextstep,history]=stepwisefit(feature0(II_train,:),...
        label0(II_train,:),'penter',0.1,'premove',0.15,'display','off','maxiter',60);
    [p_label_temp D]=q_classify(feature0(II_test,inmodel),feature0(II_train,inmodel),label0(II_train));
%     [p_label_temp D]=q_classify(feature0(II_test,:),feature0(II_train,:),label0(II_train));
    dd_temp=D(:,2)-D(:,1); %SWLDA决策值 
%     [xx1 xx2 xx3 xx4 x1 x2 x3 x4] = weighted_sum0(dd_temp,numTrial);% x1:char acc; x2:round acc

    
    [xx x] = weighted_sum00(dd_temp,numTrial,n);% x1:char acc; x2:round acc
    
    labelPreBuff=find(label0(II_test)==1);   %%测试集的靶
    labelPre(n)=labelPreBuff(1);           %%每次的测试集的第一个靶
    
    PredictChar(:,n)=[x(1);x(2);x(3);x(4)];
    PredictRound(:,n)=[xx(1) xx(2) xx(3) xx(4)];
    
end

for n=1:1:numK*numBlc
    tarBuff(n)=find(Indices==n);
end

targetListBuff=targetList(:,tarBuff);

counter=0;
for n=1:1:numK*numBlc
    i=1;
    for i=1:numRound
        if PredictChar(i,n)==targetListBuff(1,n)||PredictChar(i,n)==targetListBuff(2,n)||PredictChar(i,n)==targetListBuff(3,n)||PredictChar(i,n)==targetListBuff(4,n)
            counter=counter+1;
        end
    end
end

counter0=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
for k=1:numBlc*numK/numRound
    for n=numRound*(k-1)+1:numRound*(k-1)+4
        i=1;
        for i=1:numRound
            if PredictChar(i,n)==targetListBuff(1,n)||PredictChar(i,n)==targetListBuff(2,n)||PredictChar(i,n)==targetListBuff(3,n)||PredictChar(i,n)==targetListBuff(4,n)
                counter0(k)=counter0(k)+1;
            end
        end
    end
end

counter00=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
for k=1:numBlc*numK/numRound
    for n=numRound*(k-1)+1:numRound*(k-1)+4
        i=1;
        for i=1:numRound
            if PredictRound(i,n)==targetListBuff(1,n)||PredictRound(i,n)==targetListBuff(2,n)||PredictRound(i,n)==targetListBuff(3,n)||PredictRound(i,n)==targetListBuff(4,n)
                counter00(k)=counter00(k)+1;
            end
        end
    end
end

acc(:,1)=counter00/(size(targetListBuff,1)*numRound);      
acc(:,2)=counter0/(size(targetListBuff,1)*numRound);      
acc(1,3)=counter/numel(targetListBuff)

