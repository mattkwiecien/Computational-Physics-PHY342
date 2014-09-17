function [] = pendulum(theta0,w0,t,dt)
%rodneyc47@gmail.com
%mkwieci2@gmail.com


g=9.8;
l=2;
count=1;
N=t/dt;

theta_arr=zeros(N);
w_arr=zeros(N);

theta_arr[count] = theta0
w_arr[count] = w0

for i=0:dt:t

     w_next = w + i*(-(g/l) * sin(theta0));
     theta_next = theta0 + i*(w_next);
        
        theta_arr[count+1] = 

    
    count=count+1
end




end