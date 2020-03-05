function feature_index=get_train_feature(chan_ind,chan_length)

chan_number=max(chan_ind);
ind_temp=1:chan_number*chan_length;%此处扩充（30个靶刺激(一次10个靶，共三组数据)扩成2700个靶、非靶刺激，乘以9（9个为一个[1-9],）*10（一个靶刺激有10组））
ind_temp=reshape(ind_temp,chan_length,chan_number);%注意列数不超过chan_number，正是为了后面选取列数。


ind_temp2=ind_temp(:,chan_ind);%根据分配的折，train,或者test选列数；
feature_index=reshape(ind_temp2,1,numel(ind_temp2));%上一行选择完后，排成一行。