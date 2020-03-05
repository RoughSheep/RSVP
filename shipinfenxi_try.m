
clear;         %清除MATLAB工作环境中现有的变量

load wbarb;    %装入图像

subplot(2,2,1);image(X);colormap(map);

title('原始图像');

disp('原始图像X的大小:');

whos('X');

%对图像用bior3.7小波进行二层小波分解

[c,s]=wavedec2(X,2,'bior3.7');

%提取小波分解结构中第一层的低频系数和高频系数

ca1=appcoef2(c,s,'bior3.7',1);

ch1=detcoef2('h',c,s,1);

cv1=detcoef2('v',c,s,1);

cd1=detcoef2('d',c,s,1);

%分别对各频率成分进行重构

a1=wrcoef2('a',c,s,'bior3.7',1);

h1=wrcoef2('h',c,s,'bior3.7',1);

v1=wrcoef2('v',c,s,'bior3.7',1);

d1=wrcoef2('d',c,s,'bior3.7',1);

c1=[a1,h1;v1,d1];

%显示分解后各频率分量的信息

subplot(2,2,2);image(c1);

axis square;

title('分解后低频和高频信息');

%下面进行图像压缩处理

%保留小波分解第一层低频信息，进行图像的压缩

%第一层的低频信息即ca1，显示第一层的低频信息

%首先对第一层信息进行量化编码

ca1=appcoef2(c,s,'bior3.7',1);

ca1=wcodemat(ca1,440,'mat',0);

%改变图像的高度

ca1=0.5*ca1;

subplot(2,2,3);image(ca1);colormap(map);

axis square;

title('第一次压缩图像');

disp('第一次压缩图像的大小:');

whos('ca1');

% 保留小波分析分解第二层低频信息，进行图像的压缩，此时压缩比更大

% 第二层的低频信息ca2，显示第二层的低频信息

ca2=appcoef2(c,s,'bior3.7',2);

ca2=wcodemat(ca2,440,'mat',0);

ca2=0.25*ca2;

subplot(2,2,4);image(ca2);colormap(map);

axis square;

title('第二次压缩图像');

disp('第二次压缩图像的大小:');

whos('ca2');
