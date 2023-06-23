load('Exp_data.mat');

for i=1:length(n_items)
    n1(i)=ismember(n_items(i),1);
end

n1_num=sum(n1==1,'all');
x=error(n1==1);
% x=x/length(x);

figure
nn=1000;
% x= sorted_resp(1).error*pi/10;%randn(nn,1)
% hist(x)
% [B] = mixtureFit(x,0+zeros(size(x)))
t=zeros(length(x),1)
[B] = mixtureFit(x)
K=B(1)

nBins = 51;
binEdges = linspace(-pi, pi, nBins+1);
[c,r]=hist(x,10)
histT = histcounts(wrap(x ), binEdges, 'Normalization', 'probability');

% bar(r,c)
% bar(r,c/sum(c))
bar(binEdges(1:end-1),histT)

hold on
% p = vonmisespdf ([-pi:0.01:pi], 0, K)
v_x = [-pi/2:0.01:pi/2];
p = vonmisespdf (v_x, 0, j2k_interp(K)) 

p1 = plot(v_x,p)
p1.LineWidth=6;
hold on

sd = k2sd(K)
y = normpdf(v_x,0,sd);
p2=plot(v_x, y)
p2.LineWidth=2; 