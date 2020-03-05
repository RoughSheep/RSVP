function [targettype TimeFeedback latency label ]=extract_label0(event,numBlc,numTar,numTrial)
%%已完成
% targettype:靶刺激序列
% TimeFeedback:按键反应时间
% latency:根据排好的label，对应标签位置
% label:刺激序列中，同一个靶刺激排为一列；靶刺激为1，非靶为0；


%% 找到标签的最大值（一共有多少标签）
[allx ally]=size(event)
% sizef=size(ally)

%% 把latency和type拿出来
for i=1:ally
    typeall(i,1)=event(1,i).type;
    latencyall(i,1)=fix(event(1,i).latency);
end

%% 提取大标签号i_biglabel 提取靶标签号targettype
j=1;
for i=1:ally
    biglabel(i)=typeall(i,1)-110; % 提取出大标签
%     fprintf('%u\n',biglabel);
    if (biglabel(i))==1
            targettype(:,j)=[9 28 57 81];
            i_biglabel(j,1)=i;
            j=j+1;
        elseif (biglabel(i))==2
            targettype(:,j)=[12 32 55 80];
            i_biglabel(j,1)=i;
            j=j+1;
        elseif (biglabel(i))==3
            targettype(:,j)=[16 33 60 84];
            i_biglabel(j,1)=i;
            j=j+1;
        elseif (biglabel(i))==4
            targettype(:,j)=[11 35 67 83];
            i_biglabel(j,1)=i;
            j=j+1;
    end
end


%% reshape latency和type 让他们分成一个一个的blc 
for j=1:numBlc-1
    k=1;
    for i=i_biglabel(j,1):1:(i_biglabel(j+1,1)-1) 
        new_typeall(k,j)=typeall(i,:);
        new_latencyall(k,j)=latencyall(i,:);
        k=k+1;
    end
    if j==numBlc-1
        k=1;
        for i=i_biglabel(j+1,1):1:ally
            new_typeall(k,j+1)=typeall(i,:);
            new_latencyall(k,j+1)=latencyall(i,:);
            k=k+1;
        end
    end
end

 

%% 去除大标签  
new_typeall=new_typeall(2:1:end,:);% 把第一排的大标签拿掉
new_latencyall=new_latencyall(2:1:end,:);


%% 通过靶标签号targettype和总标签newtypeall来提取按键标签数ipresslabel

for k=1:numBlc
    j=1;
    for i=1:numTrial+numTar
        presslabel(i,k)=new_typeall(i,k)-120; % targetlabel是把标签都减掉120变成靶标签序号
        if (presslabel(i,k))>0
            if i<=targettype(numTar,k) 
                if i<=targettype(j+1,k) 
                    i_presslabel(j,k)=i;           % itargetlabel是把所有的靶标签单独打出来 并分blc
                    j=j+1;
                else
                    i_presslabel(j+1,k)=i;           % itargetlabel是把所有的靶标签单独打出来 并分blc
                    j=j+2;
                end
            else 
                i_presslabel(numTar,k)=i; 
            end
        end
    end
end

%% 删掉无效标签（按键反应时间小于10^(-4)s） 通过i_presslabel
for i=1:numBlc
    for j=1:numTar
        if i_presslabel(j,i)>0
            TimeFeedback(j,i)=new_latencyall(i_presslabel(j,i),i)-new_latencyall(targettype(j,i),i);
        end
    end
end
TimeFeedback(find(TimeFeedback<0.02))=0;%% 0.1s对应20 0.0001s对应0.02

%% 在这里完成最后的latency and label

for k=1:numBlc
    i=1;
    for ii=1:numTrial
        if new_typeall(i,k)==ii
            real_typeall(ii,k)=new_typeall(i,k);
            real_latencyall(ii,k)=new_latencyall(i,k);
            i=i+1;
        elseif ~(new_typeall(i,k)==ii)
            real_typeall(ii,k)=new_typeall(i+1,k);
            real_latencyall(ii,k)=new_latencyall(i+1,k);        
            i=i+2;
        end
    end
end
        
latency=real_latencyall;



%% 标签在全部中的位置label                            
for k=1:numBlc
    j=1;
    for i=1:numTrial
        if j<4
            if real_typeall(i,k)==targettype(j,k)
                label(i,k)=1;
                j=j+1;
            elseif ~(real_typeall(i,k)==targettype(j,k))
                label(i,k)=0;
            end
        else
            if real_typeall(i,k)==targettype(j,k)
                label(i,k)=1;
            elseif ~(real_typeall(i,k)==targettype(j,k))
                label(i,k)=0;

            end
        end
    end
end


% % % %% 标签在全部中的位置label                            %%%%%%%不需要这样做
% % % for k=1:numBlc
% % %     j=1;
% % %     for i=1:numTrial+numTar
% % %         if j<4
% % %             if new_typeall(i,k)==targettype(j,k)
% % %                 label(i,k)=1;
% % %                 j=j+1;
% % %             elseif ~(new_typeall(i,k)==targettype(j,k)) && ~(new_typeall(i,k)==0)
% % %                 label(i,k)=0;
% % %             elseif new_typeall(i,k)==0
% % %                 label(i,k)=[];
% % %             end
% % %         else
% % %             if new_typeall(i,k)==targettype(j,k)
% % %                 label(i,k)=1;
% % %             elseif ~(new_typeall(i,k)==targettype(j,k)) && ~(new_typeall(i,k)==0)
% % %                 label(i,k)=0;
% % %             elseif new_typeall(i,k)==0
% % %                 label(i,k)=nan;
% % %             end
% % %         end
% % %     end
% % % end

%%之前复制的程序有nontargettype 但是俺并不想编nontargettype 因为后面不用
% % % % %非靶刺激序列
% % % % nontargettype=[];
% % % % for i=1:numBlc % 因为latencyall,typeall为10列，故i=1:10；
% % % %     nontargettype=[nontargettype 1:targettype(i)-1 targettype(i)+1:numTrial];
% % % % end
% % % % nontargettype=reshape(nontargettype',numTrial-1,numTar);

