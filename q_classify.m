function [outclass,dv] = q_classify(sample, training, group)

% grp2idx sorts a numeric grouping var ascending, and a string grouping
% var by order of first occurrence
% group=label(index);
% training=feature(index,:);
% sample=feature;

[gindex,groups] = grp2idx(group); %groups输出group有哪些数字 gindex把group的数字按照大小从从1开始重写一遍
                                  %我们知道group是label0（train） 所以他是【1 -1 -1 -1 -1 。。。。】
                                  %所以groups是{-1}{1}  gindex是【2 1 1 1 1。。。。】

ngroups = length(groups); %ngroup应该永远是2
%fprintf('%u ',)%我测试用的
gsize = hist(gindex,1:ngroups); %%gsize=每个group里面的个数 gsize=7250 290 例子 【2 1 1 1 1 1 1 1 1 1 1 1 1 1 1】 ngrp=2 gsize=14 1 
nonemptygroups = find(gsize>0);%%nonemptgrps=1 2 

[n,d] = size(training); %%被选入有效特征的训练集的特征 [7540     56]
m = size(sample,1);     %%被选入有效特征的测试集的特征  [260 56]
fprintf('%u  \n',d)
gmeans = NaN(ngroups, d);%创造一个（2 56）的NaN值

for k = nonemptygroups
    gmeans(k,:) = mean(training(gindex==k,:),1); %%mean求每个特征的所有非靶标签平均 靶标签平均
end

mm=m;
D = repmat(NaN, mm, ngroups); %把NaN复制mm*ngroups=260*2份 作为D

% Pooled estimate of covariance.  Do not do pivoting, so that A can be
% computed without unpermuting.  Instead use SVD to find rank of R.
[Q,R] = qr(training - gmeans(gindex,:), 0); %%先用测试集所有特征减去训练集平均特征
R = R / sqrt(n - ngroups); % SigmaHat = R'*R
s = svd(R);
logDetSigma = 2*sum(log(s)); % avoid over/underflow

prior = ones(1, ngroups) / ngroups;
% MVN relative log posterior density, by group, for each sample
% invR=inv(R);
for k = nonemptygroups
        A = (sample - repmat(gmeans(k,:), mm, 1)) / R;
        D(:,k) = log(prior(k)) - .5*(sum(A .* A, 2) + logDetSigma);  %%第一行是测试减平均的非靶 第二个是靶
%     sample = (sample - repmat(gmeans(k,:), mm, 1));
%     for j=1:mm
%         sample(j,:)=sample(j,:)*invR;
%     end
%     D(:,k) = log(prior(k)) - .5*(sum(sample .* sample, 2) + logDetSigma);
end

% find nearest group to each observation in sample data
[maxD,outclass] = max(D, [], 2);
% assignin('base', 'maxD', maxD);
% assignin('base', 'D', D);
dv=D;
% Compute apparent error rate: percentage of training data that
% are misclassified, weighted by the prior probabilities for the groups.


% Convert back to original grouping variable type
if isa(group,'categorical')
   labels = getlabels(group);
   if isa(group,'nominal')
       groups = nominal(groups,[],labels);
   else
       groups = ordinal(groups,[],getlabels(group));
   end
elseif isnumeric(group)
   groups = str2num(char(groups));
   groups=cast(groups,class(group)); 
elseif islogical(group)
   groups = logical(str2num(char(groups)));
elseif ischar(group)
   groups = char(groups);
%else may be iscellstr
end
if isvector(groups)
    groups = groups(:);
end
outclass = groups(outclass,:);