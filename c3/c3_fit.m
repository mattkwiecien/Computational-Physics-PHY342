function [  ] = c3_fit( num )

%preallocation
l_vel = zeros(1,num);
l_std = zeros(1,num);
masses = zeros(1,num);

%loading in data and velocity values
for i=1:1:num
    var_names='m%d.mat';
    fname=sprintf(var_names,i);
    
    [linear_v, linear_std, mass]=c3_poly(fname);
    l_vel(i) = linear_v;
    l_std(i) = linear_std;
    masses(i)=mass;
end

%Fitting an exponential to our data
l1=polyfit( log(masses) , log(-l_vel) , 1 );

%Extracting the coefficients from polyfit and plotting relationship
v_ter = exp(l1(2)).*masses.^(l1(1));

%plot settings
set(gca,'fontsize', 18);
hold on
errorbar(masses,-l_vel,l_std,'ok')
plot(masses,v_ter,'-b')
legend('Experimental (measured) Data','Data Fit')
xlabel('Mass')
ylabel('V_{ter}')
title('The relationship between Terminal Velocity and Mass')

fprintf('The coefficient of terminal velocity was found to be %2f.\n', l1(1));
end

