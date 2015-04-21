function [  ] = co_fit( x,y )
A=270;
x=log(x);
[a,b]=sum_funct(x,log(y-A));

Y=b.*x + a;


h=figure;
set(h, 'Position', [10 100 1300 600])
subplot(1,2,1);
hold on
plot(x,log(y-A),'r');
plot(x,Y,'b');

xlabel('Date')
ylabel('CO2 (ppm)')
title('CO2 ppm per Year')
grid on

subplot(1,2,2);
hold on
plot(exp(x),(y-A),'r')
plot(exp(x),exp(Y),'b','linewidth',2.5*w);

xlabel('Date')
ylabel('CO2 (ppm)')
title('CO2 ppm per Year')
grid on


end

