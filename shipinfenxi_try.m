
clear;         %���MATLAB�������������еı���

load wbarb;    %װ��ͼ��

subplot(2,2,1);image(X);colormap(map);

title('ԭʼͼ��');

disp('ԭʼͼ��X�Ĵ�С:');

whos('X');

%��ͼ����bior3.7С�����ж���С���ֽ�

[c,s]=wavedec2(X,2,'bior3.7');

%��ȡС���ֽ�ṹ�е�һ��ĵ�Ƶϵ���͸�Ƶϵ��

ca1=appcoef2(c,s,'bior3.7',1);

ch1=detcoef2('h',c,s,1);

cv1=detcoef2('v',c,s,1);

cd1=detcoef2('d',c,s,1);

%�ֱ�Ը�Ƶ�ʳɷֽ����ع�

a1=wrcoef2('a',c,s,'bior3.7',1);

h1=wrcoef2('h',c,s,'bior3.7',1);

v1=wrcoef2('v',c,s,'bior3.7',1);

d1=wrcoef2('d',c,s,'bior3.7',1);

c1=[a1,h1;v1,d1];

%��ʾ�ֽ���Ƶ�ʷ�������Ϣ

subplot(2,2,2);image(c1);

axis square;

title('�ֽ���Ƶ�͸�Ƶ��Ϣ');

%�������ͼ��ѹ������

%����С���ֽ��һ���Ƶ��Ϣ������ͼ���ѹ��

%��һ��ĵ�Ƶ��Ϣ��ca1����ʾ��һ��ĵ�Ƶ��Ϣ

%���ȶԵ�һ����Ϣ������������

ca1=appcoef2(c,s,'bior3.7',1);

ca1=wcodemat(ca1,440,'mat',0);

%�ı�ͼ��ĸ߶�

ca1=0.5*ca1;

subplot(2,2,3);image(ca1);colormap(map);

axis square;

title('��һ��ѹ��ͼ��');

disp('��һ��ѹ��ͼ��Ĵ�С:');

whos('ca1');

% ����С�������ֽ�ڶ����Ƶ��Ϣ������ͼ���ѹ������ʱѹ���ȸ���

% �ڶ���ĵ�Ƶ��Ϣca2����ʾ�ڶ���ĵ�Ƶ��Ϣ

ca2=appcoef2(c,s,'bior3.7',2);

ca2=wcodemat(ca2,440,'mat',0);

ca2=0.25*ca2;

subplot(2,2,4);image(ca2);colormap(map);

axis square;

title('�ڶ���ѹ��ͼ��');

disp('�ڶ���ѹ��ͼ��Ĵ�С:');

whos('ca2');
