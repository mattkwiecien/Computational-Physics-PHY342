function [  ] = c3_poly( data_loc )
% polyfit, polyfit(xyn) y is data, x is time
load(data_loc)

N1=length(t1)-1;
N2=length(t2)-1;
N3=length(t3)-1;

p1=polyfit(t1,y1,N1);
p2=polyfit(t2,y2,N2);
p3=polyfit(t3,y3,N3);

whos





end

