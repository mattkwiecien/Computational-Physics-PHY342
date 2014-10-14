function [  ] = rocket_sim( theta, v_ex, T, N )
g=9.81; 
c=.50;       %Coefficient of Drag for a cylinder
m=90.8;      %Assuming a titanium cylindrical ship of r=.25m h=.75m, and a wall thickness of ~.1m.
k=.6;
v_ex_x = v_ex*cos(theta*(pi/180));
v_ex_y = v_ex*sin(theta*(pi/180));

%initial conditions
xinit=[0;0;0;0];
options = odeset('RelTol', 1e-3); 
tspan=linspace(0,T,N);

%calculate the motion without air resistance
x_noair = xinit(1) + xinit(2).*tspan - (k*v_ex_x.*tspan.^2)./(2*m);
y_noair = xinit(3) + xinit(4).*tspan - (g.*(tspan).^2)./2 - (k*v_ex_y.*tspan.^2)./(2*m);

%solve ODE
[t,x_ans] = ode45( @intfun, tspan, xinit, options );

%make calculations easier with simple variables
x = x_ans(:,1);
xdot = x_ans(:,2);
y = x_ans(:,3);
ydot = x_ans(:,4);

%finding the index where y becomes negative
[t_index,~]=find(y<0);
t_max=t_index(1);
t_plot=0;

figure
%getting only values where y_noair is positive
pyn=y_noair>=0;
plot(x_noair(pyn),y_noair(pyn),'-b')
ylim([0,1.1*max(y_noair)])

hold on
%find only values where y is positive
py=y>=0;
plot(x(py),y(py), '--r')
ylim([0,1.1*max(y_noair)])
xlim([0,1800])

%     while t_plot < t_max
%         
%         subplot(2,2,1)
%         plot(t(1:t_plot),x(1:t_plot))
%         ylim([0, 1.1*max(x)])
%         xlim([0, 1.1*t(t_max)])
%         hold on
%         grid on
%         
%         subplot(2,2,2)
%         plot(t(1:t_plot),xdot(1:t_plot))
%         ylim([1.1*min(xdot),1.1*max(xdot)])
%         xlim([0, 1.1*t(t_max)])
%         hold on
%         grid on
%         
%         subplot(2,2,3)
%         plot(t(1:t_plot),y(1:t_plot))
%         xlim([0,1.1*t(t_max)])
%         ylim([0,1.1*max(y)])
%         hold on
%         grid on
%         
%         subplot(2,2,4)
%         plot(t(1:t_plot),ydot(1:t_plot))
%         xlim([0,1.1*t(t_max)])
%         ylim([1.1*min(ydot),1.1*max(ydot)])
%         hold on
%         grid on
% 
%         pause(.001)
%         t_plot=t_plot+1;
%     end
    

    function ddt = intfun(t,x)
        ddt = [
            x(2); 
            ( -(c/(m-(k*t)) ) * sqrt((x(2))^2 + (x(4))^2) * x(2)) + ((k/(m-(k*t))) * v_ex_x);
            x(4);
            (-g) + ( -(c/(m-(k*t))) * sqrt((x(2))^2 + (x(4))^2) * x(4)) + ((k/(m-(k*t))) * v_ex_y);
            ];
    end

end
