function [] = pendulum(theta0,w0,t,dt)
%rodneyc47@gmail.com
%mkwieci2@gmail.com

g=9.8;
l=2;
count=1;
N=t/dt;

theta_arr=zeros(1,N);
w_arr=zeros(1,N);

theta_arr(count) = theta0;
w_arr(count) = w0;

for i=0:dt:t
% %euler-cromer
    w_next = w_arr(count) + dt*( -(g/l) * sin(theta_arr(count)) );
    theta_next = theta_arr(count) + dt*(w_next);
    
    w_arr(count+1) = w_next;
    theta_arr(count+1) = theta_next;
    
    count=count+1;
    
end

time_arr=0:dt:t+dt;
length(time_arr)
length(theta_arr)
figure;
plot(time_arr, theta_arr, 'r+')




end