function [  ] = rocket_leo( days,speed )

% Moon, Earth, and Rocket Positions and values
% Let Dem = 1 be the distance from the earth to the moon, and let Me=1 be
% the mass of the earth.
% Earth
x_e0 = 0; %Dem
vx_e0 = 0; 
y_e0 = 0; 
vy_e0 =0; 
% Rocket
x_r0=424220; %Dem
vx_r0=0; 
y_r0=0; 
vy_r0=8000; 
% Moon
x_m0=3.844e8; %Dem
vx_m0=0;
y_m0=0;
vy_m0=1020; %m / s

xinit=[
    x_e0; vx_e0; y_e0; vy_e0;    
    x_r0; vx_r0; y_r0; vy_r0; 
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

x_r = x_ans(:,5);
vx_r = x_ans(:,6);
y_r = x_ans(:,7);
vy_r = x_ans(:,8);

x_m = x_ans(:,9);
vx_m = x_ans(:,10);
y_m = x_ans(:,11);
vy_m = x_ans(:,12);

X=[x_e x_m x_r];
Y=[y_e y_m y_r];
whos
% figure
% hold on
% xlim([-x_m0 x_m0])
% ylim([-x_m0 x_m0])
% multicomet(X,Y);
figure

plot(x_e,y_e, 'or', x_m,y_m,'--b')

hold on

xlim([2*-x_m0 2*x_m0])
ylim([2*-x_m0 2*x_m0])

    function ddt = odesolve(~,x)
        
        G = 6.67384e-11; %Dem^3/(Me s^2)
        m_earth= 5.972e24; %Me
        m_moon=7.3459e22 ; %Me
        
        r12=abs(sqrt( (x(1)-x(5))^2 + (x(3)-x(7) )^2 ))^3;
        r23=abs(sqrt( (x(5)-x(9))^2 + (x(7)-x(11))^2 ))^3;
        r13=abs(sqrt( (x(1)-x(9))^2 + (x(3)-x(11))^2 ))^3;
        
        ddt=[
            x(2);
            G*( (m_moon*(x(9)-x(1)))/r13 );%+ (m_rocket*(x(5)-x(1)))/r12 );
            x(4);
            G*( (m_moon*(x(11)-x(3)))/r13 );%+ (m_rocket*(x(7)-x(3)))/r12 );
            
            x(6);
            G*( (m_earth*(x(1)-x(5)))/r12 + (m_moon*(x(9)-x(5)))/r23 );
            x(8);
            G*( (m_earth*(x(3)-x(7)))/r12 + (m_moon*(x(11)-x(7)))/r23 );
            
            x(10);
            G*( (m_earth*(x(1)-x(9)))/r13 );%+ (m_rocket*(x(5)-x(9)))/r23 );
            x(12);
            G*( (m_earth*(x(3)-x(11)))/r13 )
            ];%+ (m_rocket*(x(7)-x(11)))/r23 )];

    end



        



end

