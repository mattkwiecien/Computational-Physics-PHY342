function [ t,x ] = ThreeBodySolarSystem(days,speed,earth_speed,animate)
% Models the interaction of a three body system in the plane of the solar
% system. T is a vector of the form [t_o t_f] and init is a vector of the
% intial conditions in the form [x1_0 v1x_0 y1_0 v1y_0 x2_0 v2x_0 y2_0 v2y_0 x3_0 v3x_0 y3_0
% v3y_0].

%**********************************************************************************
% Planetary Initial Conditions

% Earth
x1_0 = 1.5e11; %m
v1x_0 = 0; %m
y1_0 = 0; %m
v1y_0 = earth_speed*1.0*30e3; %m/s % 2.592e6; %km/day

%Mars
x2_0 = 2.3e11; %m
v2x_0 = 0; %m/s
y2_0 = 0; %m
v2y_0 = 24e3; %m/s %2.074e6;% km/day 24e3; %m/s;

%Sun
x3_0 = 0;
v3x_0 = 0;
y3_0= 0;
v3y_0= 0;

% Initial Conditions Vector
init=[x1_0 v1x_0 y1_0 v1y_0 x2_0 v2x_0 y2_0 v2y_0 x3_0 v3x_0 y3_0 v3y_0];

%**********************************************************************************

seconds=days*86400;
speed=speed*8640;

% tspan = linspace(T(1),T(2),n);
tspan = 0:speed:seconds;

options=odeset('RelTol',1e-5);
[t,x]=ode45(@deriv,tspan,init,options);

x1=x(:,1);
y1=x(:,3);

x2=x(:,5);
y2=x(:,7);

x3=x(:,9);
y3=x(:,11);

X=[x1 x2 x3];
Y=[y1 y2 y3];

screen_size = get(0,'ScreenSize');
fig_size = screen_size(4);

if animate == 1
    
    figure('units','points','outerposition',[.3*fig_size 0 .8*fig_size fig_size])
    multicomet(X,Y);
    %plot(x1,y1,'+',x2,y2,'+',x3,y3,'+')
    %figure
    %plot(x1,y1,x2,y2,x3,y3)
    
end

function dxdt = deriv(~,x)
        
        G = 6.67384e-11; %m^3/kg/s^2 %4.97912832e-10; % days/km
        m1=5.972e24; %kg, Earth
        m2=6.39e23; %kg, Mars
        m3=1.989e30; %kg, Sun
        
        r12=abs(sqrt((x(5)-x(1))^2+(x(7)-x(3))^2))^3; %distance from 1 to 2
        r13=abs(sqrt((x(9)-x(1))^2+(x(11)-x(3))^2))^3; %distance from 1 to 3
        r23=abs(sqrt((x(5)-x(9))^2+(x(7)-x(11))^2))^3; %distance from 2 to 3
        
%         if r13<0.5*x1_0 
%            
%             half_time=t/8640;
%             pause
%                         
%         end
        
        %dx1/dt
        dxdt(1)=x(2);
        %dv1x/dt
        dxdt(2)=G*(m2/r12*(x(5)-x(1))+m3/r13*(x(9)-x(1)));
        %dy1/dt
        dxdt(3)=x(4);
        %dv1y/dt
        dxdt(4)=G*(m2/r12*(x(7)-x(3))+m3/r13*(x(11)-x(3)));
        %dx2/dt
        dxdt(5)=x(6);
        %dv2x/dt
        dxdt(6)=G*(m1/r12*(x(1)-x(5))+m3/r23*(x(9)-x(5)));
        %dy2/dt
        dxdt(7)=x(8);
        %dv2y/dt
        dxdt(8)=G*(m1/r12*(x(3)-x(7))+m3/r23*(x(11)-x(7)));
        %dx3/dt
        dxdt(9)=x(10);
        %dv3x/dt
        dxdt(10)=G*(m1/r13*(x(1)-x(9))+m2/r23*(x(5)-x(9)));
        %dy3/dt
        dxdt(11)=x(12);
        %dv3y/dt
        dxdt(12)=G*(m1/r13*(x(3)-x(11))+m2/r23*(x(7)-x(11)));
        
        dxdt=dxdt';
        
end

end