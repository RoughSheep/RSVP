function feature_index=get_train_feature(chan_ind,chan_length)

chan_number=max(chan_ind);
ind_temp=1:chan_number*chan_length;%�˴����䣨30���д̼�(һ��10���У�����������)����2700���С��ǰд̼�������9��9��Ϊһ��[1-9],��*10��һ���д̼���10�飩��
ind_temp=reshape(ind_temp,chan_length,chan_number);%ע������������chan_number������Ϊ�˺���ѡȡ������


ind_temp2=ind_temp(:,chan_ind);%���ݷ�����ۣ�train,����testѡ������
feature_index=reshape(ind_temp2,1,numel(ind_temp2));%��һ��ѡ������ų�һ�С�