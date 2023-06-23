% * * * * * * * * * * * * * * * *Neural data analysis Summer school* * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * *Held in: IPM* * * * * * * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * * *August 2021* * * * * * * * * * * * * * * * * * *
% This function plot mean of data and standard error  
% 
% inputs:
% input: M * N matrix of data  M is the number of repetition 
% N is number ot time points on X axis
% t: the value of X axis 
% win: the smoothing windowq size 
% c1 c2 c3: color of plot in  R G B
%
% Edited  By M.R.A Dehaqani & E.Rezayat

function ndass_niceplot(input,t, win, c1, c2, c3)

for k = 1 : size(input,1)
    jnk(k,:) = ndass_smooth(input(k, :), win);
end
matr = jnk(:,:);
inte = 2.5;
y  = nanmean(matr);
y1 = nanmean(matr)+nanstd(matr)./(size(matr, 1).^.5);
y2 = nanmean(matr)-nanstd(matr)./(size(matr, 1).^.5);
y3 = y2(size(matr , 2):-1:1);
y2 = y3;
Y  = [y1 y2];

x1 = t;
x2 = sort(t , 'descend');
X  = [x1 x2];
fill(X, Y, [c1/inte c2/inte c3/inte], 'LineStyle', 'none');
hold on;
plot(t, y,  'color', [c1 c2 c3],'LineWidth',1);


