function [ range ] = rocket_sim( theta, v_ex, k, T, N, mode )
g=9.81; 
c=0.075;            %Coefficient of Drag for a sphere with r=.3m
m_ship=9.8;         %Assuming an aluminum spherical ship of r=.15m and a wall thickness of ~.05m.
m_fuel=5;           %Mass of propellant

if nargin<6
    mode=0;
end

v_ex_x = v_ex*cos(theta*(pi/180));
v_ex_y = v_ex*sin(theta*(pi/180));

%initial conditions
xinit=[0;0;0;0];
options = odeset('RelTol', 1e-6); 
tspan=linspace(0,T,N);

%solve ODE
[t,x_ans] = ode45( @intfun, tspan, xinit, options );

%make calculations easier with simple variables
x = x_ans(:,1);
xdot = x_ans(:,2);
y = x_ans(:,3);
ydot = x_ans(:,4);

%finding the index where y becomes negative
[t_index,~]=find(y<0);
t_max=t_index(1)-1;
t_plot=1;

%optional output of maximum range of rocket 
if mode==1
    
    range=x(t_max);
    
%simulation if not requested
else
    
%plotting boundaries
width=600;
height=600;
hFig=figure(1);
set(hFig, 'position', [0,100,width,height])

%animted plot of trajectory
    while t_plot < t_max
        
        subplot(2,2,1)
        plot(t(1:t_plot),x(1:t_plot))
        ylim([0, 1.1*max(x)])
        xlim([0, 1.1*t(t_max)])
        xlabel('Time (s)')
        ylabel('X position (m)')
        hold on
        grid on
        
        subplot(2,2,2)
        plot(t(1:t_plot),xdot(1:t_plot),'r')
        ylim([1.1*min(xdot),1.1*max(xdot)])
        xlim([0, 1.1*t(t_max)])
        xlabel('Time (s)')
        ylabel('X velocity (m/s)')
        hold on
        grid on
        
        subplot(2,2,3)
        plot(t(1:t_plot),y(1:t_plot))
        xlim([0,1.1*t(t_max)])
        ylim([0,1.1*max(y)])
        xlabel('Time (s)')
        ylabel('Y position (m/s)')
        hold on
        grid on
        
        subplot(2,2,4)
        plot(t(1:t_plot),ydot(1:t_plot),'r')
        ylim([-1.1*max(ydot),1.1*max(ydot)])
        xlabel('Time (s)')
        ylabel('Y velocity (m/s)')
        hold on
        grid on

        pause(.01)
        t_plot=t_plot+1;
        
    end
    
    %trajectory bound
    bound1=max(max(y),max(x));
    
    %more plotting...
    hFig2=figure(2);
    set(hFig2, 'position', [800,100,width,height])
    plot(x,y,'r')
    axis([0 1.1*bound1 0 1.1*bound1])
    grid on
    xlabel('Horizontal Distance (m)')
    ylabel('Vertical Distance (m)')
    title('Simulated motion of a rocket experiencing air resistance')
    
end

    %RHS function
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
