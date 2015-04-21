function [  ] = astr_rocket_leo( days,speed )

% Moon, Earth, and Rocket Positions and values
% Let Dem = 1 be the distance from the earth to the moon, and let Me=1 be
% the mass of the earth.
% Earth
x_e0 = 0; %Lunar Distance
vx_e0 = 0; 
y_e0 = 0; 
vy_e0 =0; 
% Rocket
x_r0=0; %.0011; %Lunar Distance
vx_r0=-2e-5; % 9.5999e-5; 
y_r0=.017657; 
vy_r0=0; %3.74e-6; % LD / s 1.924e8
% Moon
x_m0=1; %Lunar Distance
vx_m0=0;
y_m0=0;
vy_m0=2.6074e-6; % LD / s

xinit1=[
    x_e0; vx_e0; y_e0; vy_e0; 
    x_r0; vx_r0; y_r0; vy_r0;
    x_m0; vx_m0; y_m0; vy_m0
    ];

time=days*86400;
speed=speed*8640;
tspan=linspace(0,time,speed);
options = odeset('RelTol', 1e-8); 
%solve ODE
[~,x_ans1] = ode45( @odesolve1, tspan, xinit1, options );

% Extracting information from ode45
x_e = x_ans1(:,1);
vx_e = x_ans1(:,2);
y_e = x_ans1(:,3);
vy_e = x_ans1(:,4);

x_r = x_ans1(:,5);
vx_r = x_ans1(:,6);
y_r = x_ans1(:,7);
vy_r = x_ans1(:,8);

x_m = x_ans1(:,9);
vx_m = x_ans1(:,10);
y_m = x_ans1(:,11);
vy_m = x_ans1(:,12);

% earth_travel=abs(y_e(1) - y_e(length(y_e)));
% v_stepsize = earth_travel/length(tspan);

% xinit2=[
%     x_e0; vx_e0; y_e0; vy_e0;    
%     x_r0; vx_r0; y_r0; vy_r0;
%     x_m0; vx_m0; y_m0; vy_m0
%     ];
% [~,x_ans2] = ode45( @odesolve2, tspan, xinit2, options );
% x_r = x_ans2(:,5);
% vx_r = x_ans2(:,6);
% y_r = x_ans2(:,7);
% vy_r = x_ans2(:,8);



X=[x_e x_m x_r ];
Y=[y_e y_m y_r];

multicomet(X,Y);
figure

plot(x_e,y_e, 'k', x_m,y_m,'--b', x_r,y_r,'+r')

hold on

xlim([2*-x_m0 2*x_m0])
ylim([2*-x_m0 2*x_m0])

    function ddt1 = odesolve1(~,x)
        
        G = 6.6573e-12; %Dem^3/(Me s^2)
        m_earth= 1; %Me
        m_moon= .0123; %Me
        
        r12=abs(sqrt( (x(1)-x(5))^2 + (x(3)-x(7) )^2 ))^3;
        r23=abs(sqrt( (x(5)-x(9))^2 + (x(7)-x(11))^2 ))^3;
        r13=abs(sqrt( (x(1)-x(9))^2 + (x(3)-x(11))^2 ))^3;
        
        ddt1=[
            x(2);%earth
            G*( (m_moon*(x(5)-x(1)))/r13 );
            x(4);
            G*( (m_moon*(x(7)-x(3)))/r13 );

            x(6);%rocket
            G*( (m_earth*(x(1)-x(5)))/r12 + (m_moon*(x(9)-x(5)))/r23);
            x(8);
            G*( (m_earth*(x(3)-x(7)))/r12 + (m_moon*(x(11)-x(7)))/r23);
            
            x(10);%moon
            G*( (m_earth*(x(1)-x(9)))/r13 );
            x(12);
            G*( (m_earth*(x(3)-x(11)))/r13 )
            ];

    end

%     function ddt2 = odesolve2(~,x)
%         
%         G = 6.6573e-12; %Dem^3/(Me s^2)
%         m_earth= 1; %Me        
%         r12=abs(sqrt( (x(1)-x(5))^2 + (x(3)-x(7) )^2 ))^3;
% 
%         ddt2=[
%             x(2);
%             0;
%             v_stepsize;
%             0;
%             
%             x(6);
%             G*( (m_earth*(x(1)-x(5)))/r12 );
%             x(8);
%             G*( (m_earth*(x(3)-x(7)))/r12 )
%             ];
%             
% 
%     end

end

