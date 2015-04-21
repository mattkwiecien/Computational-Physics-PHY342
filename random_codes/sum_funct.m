function [ a,b ] = sum_funct( x,y )

N=length(x);

S=0;
S_x=0;
S_y=0;
S_xy=0;
S_xx=0;


for i=1:1:N
    S = S + 1;
    S_x = S_x + x(i);
    S_y = S_y + y(i);
    S_xy = S_xy + (x(i)*y(i));
    S_xx = S_xx + (x(i)*x(i));
end

a= ( (S_y*S_xx) - (S_x*S_xy) ) / ( (S*S_xx - (S_x)^2) );

b= ( (S*S_xy) - (S_y*S_x) ) / ( (S*S_xx) - (S_x)^2 );
