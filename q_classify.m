function [outclass,dv] = q_classify(sample, training, group)

% grp2idx sorts a numeric grouping var ascending, and a string grouping
% var by order of first occurrence
% group=label(index);
% training=feature(index,:);
% sample=feature;

[gindex,groups] = grp2idx(group); %groups���group����Щ���� gindex��group�����ְ��մ�С�Ӵ�1��ʼ��дһ��
                                  %����֪��group��label0��train�� �������ǡ�1 -1 -1 -1 -1 ����������
                                  %����groups��{-1}{1}  gindex�ǡ�2 1 1 1 1����������

ngroups = length(groups); %ngroupӦ����Զ��2
%fprintf('%u ',)%�Ҳ����õ�
gsize = hist(gindex,1:ngroups); %%gsize=ÿ��group����ĸ��� gsize=7250 290 ���� ��2 1 1 1 1 1 1 1 1 1 1 1 1 1 1�� ngrp=2 gsize=14 1 
nonemptygroups = find(gsize>0);%%nonemptgrps=1 2 

[n,d] = size(training); %%��ѡ����Ч������ѵ���������� [7540     56]
m = size(sample,1);     %%��ѡ����Ч�����Ĳ��Լ�������  [260 56]
fprintf('%u  \n',d)
gmeans = NaN(ngroups, d);%����һ����2 56����NaNֵ

for k = nonemptygroups
    gmeans(k,:) = mean(training(gindex==k,:),1); %%mean��ÿ�����������зǰб�ǩƽ�� �б�ǩƽ��
end

mm=m;
D = repmat(NaN, mm, ngroups); %��NaN����mm*ngroups=260*2�� ��ΪD

% Pooled estimate of covariance.  Do not do pivoting, so that A can be
% computed without unpermuting.  Instead use SVD to find rank of R.
[Q,R] = qr(training - gmeans(gindex,:), 0); %%���ò��Լ�����������ȥѵ����ƽ������
R = R / sqrt(n - ngroups); % SigmaHat = R'*R
s = svd(R);
logDetSigma = 2*sum(log(s)); % avoid over/underflow

prior = ones(1, ngroups) / ngroups;
% MVN relative log posterior density, by group, for each sample
% invR=inv(R);
for k = nonemptygroups
        A = (sample - repmat(gmeans(k,:), mm, 1)) / R;
        D(:,k) = log(prior(k)) - .5*(sum(A .* A, 2) + logDetSigma);  %%��һ���ǲ��Լ�ƽ���ķǰ� �ڶ����ǰ�
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