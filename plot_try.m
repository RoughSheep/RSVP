function plot_try(h1)

data=[1 2;2 3;3 4];

x=[1 2 3 4];

axes(h1);


plot(x,[10,10,30,30])
b = bar(data);

ch = get(b,'children');

set(gca,'XTickLabel',{'��һ��','�ڶ���','������','������','������','������','������','�ڰ���','�ھ���'})

legend('round1','round2','round3','round4');

ylabel('��ȷ��');
