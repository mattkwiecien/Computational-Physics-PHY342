function [ linear_v, linear_std, m  ] = c3_data( data_loc )
% Written by Matthew Kwiecien in 2014
% loading in the data
load(data_loc)
m=mass;

%%% linear fits
l1=polyfit(t1,y1,1);
l2=polyfit(t2,y2,1);
l3=polyfit(t3,y3,1);

line1=l1(1);
line2=l2(1);
line3=l3(1);

%%% average velocity
linear_v = (line1 + line2 + line3)/3;
linear_std = std([line1, line2, line3]);


end

