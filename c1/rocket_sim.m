function [  ] = rocket_sim( theta, v_ext, c, k, m, T, dt )
g=9.81
v_ext_x = v_ext*cos(theta);
v_ext_y = v_ext*sin(theta);

options = odeset('RelTol',

tspan=linespace(0,T,dt);


[t,x_ans]=ode45(@ddt, tspan,  )

    function ddt = intfun(x,t)
        ddt=[x(2); 
            ( -c*( sqrt(x(2)^2 +x(4)^2)*x(2)) + (k*v_ext_x)) / (m - (k*t));
            x(4);
            ( (k*t - m)*g - c*(sqrt(x(2)^2 + x(4)^2)*x(4)) + (k*v_ext_y))/ (m-(k*t))];
    end

end
            
