function [  ] = rocket_sim( theta, v_ex, k, T, N )
g=9.81; 
c=0.25;             %Coefficient of Drag for a sphere
m_ship=9.8;         %Assuming an aluminum spherical ship of r=.15m and a wall thickness of ~.05m.
m_fuel=5;           %Mass of propellant

v_ex_x = v_ex*cos(theta*(pi/180));
v_ex_y = v_ex*sin(theta*(pi/180));

%initial conditions
xinit=[0;0;0;0];
options = odeset('RelTol', 1e-3); 
tspan=linspace(0,T,N);

%solve ODE
[t,x_ans] = ode45( @intfun, tspan, xinit, options );

%analytic solution without air resistance
x_noair = xinit(1) + xinit(2).*tspan - (k*v_ex_x.*tspan.^2)./(2*(m_ship+m_fuel));
y_noair = xinit(3) + xinit(4).*tspan - (g.*(tspan).^2)./2 - (k*v_ex_y.*tspan.^2)./(2*(m_ship+m_fuel));

%make calculations easier with simple variables
x = x_ans(:,1);
xdot = x_ans(:,2);
y = x_ans(:,3);
ydot = x_ans(:,4);

%finding the index where y becomes negative
[t_index,~]=find(y<0);
t_max=t_index(1);
t_plot=1;

figure
% %getting only values where y_noair is positive
% pyn=y_noair>=0;
% plot(x_noair,y_noair,'-b')
% ylim([0,1.1*max(y_noair)])

hfig=figure;
%find only values where y is positive
% plot(x,y, '--r')
% ylim([0,1.1*max(y)])

    while t_plot < t_max
        
        subplot(2,2,1)
        plot(t(1:t_plot),x(1:t_plot))
        ylim([0, 1.1*max(x)])
        xlim([0, 1.1*t(t_max)])
        hold on
        grid on
        
        subplot(2,2,2)
        plot(t(1:t_plot),xdot(1:t_plot))
        ylim([1.1*min(xdot),1.1*max(xdot)])
        xlim([0, 1.1*t(t_max)])
        hold on
        grid on
        
        subplot(2,2,3)
        plot(t(1:t_plot),y(1:t_plot))
        xlim([0,1.1*t(t_max)])
        ylim([0,1.1*max(y)])
        hold on
        grid on
        
        subplot(2,2,4)
        plot(t(1:t_plot),ydot(1:t_plot))
        xlim([0,1.1*t(t_max)])
        ylim([1.1*min(ydot),1.1*max(ydot)])
        hold on
        grid on

        
%         plot(hfig,x(1:t_plot),y(1:t_plot))
%         ylim([0,1.1*max(y_noair)])
%         hold on
%         plot(hfig,x_noair(1:t_plot),y_noair(1:t_plot))

        pause(.01)
        t_plot=t_plot+1;
    end
    

    function ddt = intfun(t,x)
        M =  m_ship + (m_fuel - (k*t));
        if (m_fuel-(k*t))<=0
            thrust=0;
            M=m_ship;
        else
            thrust = (k/M);
        end
        
        air_res = (-c/M)*sqrt((x(2))^2 + (x(4))^2);
        
        ddt = [
            x(2); 
            (air_res * x(2)) + (thrust * v_ex_x);
            x(4);
            (-g) + (air_res * x(4)) + (thrust * v_ex_y);
            ];
    end

end
