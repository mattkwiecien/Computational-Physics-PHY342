function [  ] = ana_orbit( days,speed )
% The astr_rocket_leo will simulate the path taken by a rocket that begins
% in low earth orbit and travels to the moon, stopping in low lunar orbit.
%
% All units will be in terms of the Lunar Distance (L_D = 3.85e8m) and
% Earth Masses (M_E = 5.972e24 kg)


% Rocket Initial Conditions
x_r0=0; 
vx_r0=-1e-5+9.04882e-7; 
y_r0=.1; 
vy_r0=1e-7; 
% Moon Initial Conditions
x_m0=0; 
vx_m0=-1e-5;
y_m0=0;
vy_m0=1e-7; 

xinit1=[
    x_r0; vx_r0; y_r0; vy_r0;
    x_m0; vx_m0; y_m0; vy_m0
    ];

% Converting all inputs into seconds.
time=days*86400;
speed=speed*8640;
tspan=linspace(0,time,speed);

% Using ODE45 to evaluate the RHS of our equation for xdot and xddot.
options = odeset('RelTol', 1e-8); 
[t_ans,x_ans1] = ode45( @odesolve1, tspan, xinit1, options );

% Extracting information from ode45

% Rocket
x_r = x_ans1(:,1);
vx_r = x_ans1(:,2);
y_r = x_ans1(:,3);
vy_r = x_ans1(:,4);

% Moon
x_m = x_ans1(:,5);
vx_m = x_ans1(:,6);
y_m = x_ans1(:,7);
vy_m = x_ans1(:,8);

X=[x_m x_r];
Y=[y_m y_r];

%%% Second Half of Problem start
% Moon and Rocket in orbit
multicomet(X,Y)

% whos
% plot(x_m,y_m,'r')
% hold on
% plot(x_r,y_r,'b')
% xlim([-.3 .3])
% ylim([-.3 .3])

    function ddt1 = odesolve1(t,x)
        
        G = 6.6573e-12; %Dem^3/(Me s^2)
        m_moon= .0123; %Me
        
        r12=abs(sqrt( (x(1)-x(5))^2 + (x(3)-x(7) )^2 ))^3;

        ddt1=[
            x(2);%rocket
            G*( (m_moon*(x(5)-x(1)))/r12) ;
            x(4);
            G*( (m_moon*(x(7)-x(3)))/r12) ;

            x(6);%moon
            0;
            x(8);
            0
            ];

    end
end