function [  ] = rocket_sim( theta, v_ext, c, k, m, T, N )
g=9.81;
v_ext_x = v_ext*cos(theta*(pi/180));
v_ext_y = v_ext*sin(theta*(pi/180));

options = odeset('RelTol', 1e-3); 
tspan=linspace(0,T,N);

xinit=[0;100;0;100];

[t,x_ans] = ode45( @intfun, tspan, xinit, options );

x = x_ans(:,1);
xdot = x_ans(:,2);
y = x_ans(:,3);
ydot = x_ans(:,4);

hold on
plot(x,y,'g');
%plot(t,ydot,'b');
%plot(t,xdot,'r');
grid on
ylim([0,1.1*max(y)])

    function ddt = intfun(t,x)
        ddt = [
            x(2); 
            ( -c*( sqrt(x(2)^2 + x(4)^2) * x(2) ) + (k*v_ext_x) ) / ( m - (k*t) );
            x(4);
            ( (k*t - m)*g - c*(sqrt(x(2)^2 + x(4)^2)*x(4)) + (k*v_ext_y))/ (m-(k*t))
            ];
    end

%     function ddt = intfun(t,x)
%         ddt=[
%             x(2); 
%             0;
%             x(4);
%             -g
%             ];
%     end

end

