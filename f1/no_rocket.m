function [  ] = no_rocket( days,speed )

% Moon, Earth, and Rocket Positions and values
% Let Dem = 1 be the distance from the earth to the moon, and let Me=1 be
% the mass of the earth.
% Earth
x_e0 = 0; %Dem
vx_e0 = 0; 
y_e0 = 0; 
vy_e0 =0; 
% Moon
x_m0=1; %Dem
vx_m0=0;
y_m0=0;
vy_m0=2.6074; %Dem / s

xinit=[
    x_e0; vx_e0; y_e0; vy_e0; 
    
    x_m0; vx_m0; y_m0; vy_m0
    ];

time=days*86400;
speed=speed*8640;
tspan=linspace(0,time,speed);
options = odeset('RelTol', 1e-6); 
%solve ODE
[~,x_ans] = ode45( @odesolve, tspan, xinit, options );

% Extracting information from ode45
x_e = x_ans(:,1);
vx_e = x_ans(:,2);
y_e = x_ans(:,3);
vy_e = x_ans(:,4);

x_m = x_ans(:,5);
vx_m = x_ans(:,6);
y_m = x_ans(:,7);
vy_m = x_ans(:,8);

X=[x_e x_m];
Y=[y_e y_m];

figure
hold on
xlim([-x_m0 x_m0])
ylim([-x_m0 x_m0])
multicomet(X,Y);
%plot(x_earth,y_earth, 'b', x_moon,y_moon,'r',x_rocket,y_rocket,'k')

    function ddt = odesolve(~,x)
        
        G = 6.6573e-12; %Dem^3/(Me s^2)
        m_earth= 1; %Me
        m_moon= .0123; %Me
        
        r13=abs(sqrt( (x(1)-x(5))^2 - (x(3)-x(7) )^2 ))^3; 
        
        ddt=[x(2);
            G*( (m_moon*(x(5)-x(1)))/r13 );
            x(4);
            G*( (m_moon*(x(7)-x(3)))/r13 );
            x(6);
            G*( (m_earth*(x(1)-x(5)))/r13 );
            x(8);
            G*( (m_earth*(x(3)-x(7)))/r13 )];

    end



        



end
