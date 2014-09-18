function [] = pendulum(theta0,w0,t,dt)
%rodneyc47@gmail.com
%mkwieci2@gmail.com

g=9.8;
l=2;
count=1;
N=t/dt;

%euler-cromer arrays
theta_arr=zeros(1,N);
w_arr=zeros(1,N);
theta_arr(count) = theta0*(pi/180);
w_arr(count) = w0;

%verlet arrays (2)
theta_arr2=zeros(1,N);
w_arr2=zeros(1,N);
theta_arr2(count) = theta0*(pi/180);
w_arr2(count) = w0;


for i=0:dt:t
%%euler-cromer
    w_next = w_arr(count) + dt*( -(g/l) * sin(theta_arr(count)) );
    theta_next = theta_arr(count) + dt*(w_next);
    
    w_arr(count+1) = w_next;
    theta_arr(count+1) = theta_next;

%%Verlet
    if count == 1 
        theta_old2 = theta_arr2(count) - w_arr2(count)*dt + ((dt^2)/2)*((-g/l)*sin(theta_arr2(count)));
        theta_next2 = 2*theta_arr2(count) - theta_old2 + ((dt^2)/2)*(-(g/l)*sin(theta_arr2(count)));
        
        theta_arr2(count+1) = theta_next2;
    else
        theta_next2 = 2*theta_arr2(count) - theta_arr(count-1) + (dt^2)*(-(g/l)*sin(theta_arr2(count)));
        %theta_old2 = theta_arr2(count-1);
        
        theta_arr2(count+1) = theta_next2;
    end
    
     count=count+1;
    
end


time_arr=0:dt:t+dt;

figure;
%plot(time_arr, theta_arr, 'bo', time_arr, theta_arr2, 'r+')

plot(time_arr, theta_arr, 'bo')


end