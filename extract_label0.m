function [targettype TimeFeedback latency label ]=extract_label0(event,numBlc,numTar,numTrial)
%%�����
% targettype:�д̼�����
% TimeFeedback:������Ӧʱ��
% latency:�����źõ�label����Ӧ��ǩλ��
% label:�̼������У�ͬһ���д̼���Ϊһ�У��д̼�Ϊ1���ǰ�Ϊ0��


%% �ҵ���ǩ�����ֵ��һ���ж��ٱ�ǩ��
[allx ally]=size(event)
% sizef=size(ally)

%% ��latency��type�ó���
for i=1:ally
    typeall(i,1)=event(1,i).type;
    latencyall(i,1)=fix(event(1,i).latency);
end

%% ��ȡ���ǩ��i_biglabel ��ȡ�б�ǩ��targettype
j=1;
for i=1:ally
    biglabel(i)=typeall(i,1)-110; % ��ȡ�����ǩ
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


%% reshape latency��type �����Ƿֳ�һ��һ����blc 
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

 

%% ȥ�����ǩ  
new_typeall=new_typeall(2:1:end,:);% �ѵ�һ�ŵĴ��ǩ�õ�
new_latencyall=new_latencyall(2:1:end,:);


%% ͨ���б�ǩ��targettype���ܱ�ǩnewtypeall����ȡ������ǩ��ipresslabel

for k=1:numBlc
    j=1;
    for i=1:numTrial+numTar
        presslabel(i,k)=new_typeall(i,k)-120; % targetlabel�ǰѱ�ǩ������120��ɰб�ǩ���
        if (presslabel(i,k))>0
            if i<=targettype(numTar,k) 
                if i<=targettype(j+1,k) 
                    i_presslabel(j,k)=i;           % itargetlabel�ǰ����еİб�ǩ��������� ����blc
                    j=j+1;
                else
                    i_presslabel(j+1,k)=i;           % itargetlabel�ǰ����еİб�ǩ��������� ����blc
                    j=j+2;
                end
            else 
                i_presslabel(numTar,k)=i; 
            end
        end
    end
end

%% ɾ����Ч��ǩ��������Ӧʱ��С��10^(-4)s�� ͨ��i_presslabel
for i=1:numBlc
    for j=1:numTar
        if i_presslabel(j,i)>0
            TimeFeedback(j,i)=new_latencyall(i_presslabel(j,i),i)-new_latencyall(targettype(j,i),i);
        end
    end
end
TimeFeedback(find(TimeFeedback<0.02))=0;%% 0.1s��Ӧ20 0.0001s��Ӧ0.02

%% �������������latency and label

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



%% ��ǩ��ȫ���е�λ��label                            
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


% % % %% ��ǩ��ȫ���е�λ��label                            %%%%%%%����Ҫ������
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

%%֮ǰ���Ƶĳ�����nontargettype ���ǰ��������nontargettype ��Ϊ���治��
% % % % %�ǰд̼�����
% % % % nontargettype=[];
% % % % for i=1:numBlc % ��Ϊlatencyall,typeallΪ10�У���i=1:10��
% % % %     nontargettype=[nontargettype 1:targettype(i)-1 targettype(i)+1:numTrial];
% % % % end
% % % % nontargettype=reshape(nontargettype',numTrial-1,numTar);

