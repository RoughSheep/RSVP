function plot_try(h1)

data=[1 2;2 3;3 4];

x=[1 2 3 4];

axes(h1);


plot(x,[10,10,30,30])
b = bar(data);

ch = get(b,'children');

set(gca,'XTickLabel',{'第一天','第二天','第三天','第四天','第五天','第六天','第七天','第八天','第九天'})

legend('round1','round2','round3','round4');

ylabel('正确率');
