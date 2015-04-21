function [  ] = a_rocket( v_ex, theta )

g = 9.81; m_ship = 9.8; m_fuel = 5; k = ;

v_ex_x = v_ex*cos(theta*(pi/180));
v_ex_y = v_ex*sin(theta*(pi/180));

T = 1000; N = 1001;

xinit = [0;0;0;0];
options = odeset('AbsTol',1e-9,'RelTol',1e-9);
tspan = linspace(0,T,N);

[T,X] = ode45( @myode, tspan, xinit, options);

 x = X(:,1);  y = X(:,3);
vx = X(:,2); vy = X(:,4);

[t_index


    function dt = myode(t,x)
       
        M = m_ship + (m_fuel - (k*t));
        if (m_fuel - (k*t))<=0
            thrust = 0;
            M = m_ship;
        else
            thrust = (k/M);
        end
        
        dt(1) = x(2);
        dt(2) = thrust*v_ex_x/M;
        dt(3) = x(4);
        dt(4) = -g + (thrust*v_ex_y)/M;
        
        dt = dt';
        
    end


end

