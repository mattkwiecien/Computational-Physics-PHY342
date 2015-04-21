function [ ] = astr_rocket_leo( days,speed )
% The astr_rocket_leo will simulate the path taken by a rocket that begins
% in low earth orbit and travels to the moon, stopping in low lunar orbit.
%
% All units will be in terms of the Lunar Distance (L_D = 3.85e8m) and
% Earth Masses (M_E = 5.972e24 kg)

v_exhaust = 1.15e-5;    %Value taken from Space Shuttle exhaust capabilities
m_ship=4.08573e-21;     % Space Shuttle mass
m_fuel=1e-22;           % Assuming mass of fuel is about 2.5% of mass of ship
k=1.89679e-23; 
LLO = 5.1948e-4;        % Low Lunar orbit
theta=38;
% Moon, Earth, and Rocket Positions and values
% Earth Initial Conditions
x_e0 = 0; 
vx_e0 = 0; 
y_e0 = 0; 
vy_e0 =0; 
% Rocket Initial Conditions
x_r0=0; 
vx_r0=-2e-5; %elliptical orbit w/ moon @ 2.722e-5 
y_r0=-.017657; 
vy_r0=0; 
% Moon Initial Conditions
x_m0=cosd(theta); 
vx_m0=-2.6074e-6*sind(theta);
y_m0=sind(theta);
vy_m0=2.6074e-6*cosd(theta); 

xinit1=[
    x_e0; vx_e0; y_e0; vy_e0; 
    x_r0; vx_r0; y_r0; vy_r0;
    x_m0; vx_m0; y_m0; vy_m0
    ];

% Converting all inputs into seconds.
time=days*86400;
speed=speed*8640;
tspan=linspace(0,time,speed);

% Using ODE45 to evaluate the RHS of our equation for xdot and xddot.
options = odeset('RelTol', 1e-10); 
[t_ans,x_ans1] = ode45( @odesolve1, tspan, xinit1, options );

% Extracting information from ode45
% Earth
x_e = x_ans1(:,1);
vx_e = x_ans1(:,2);
y_e = x_ans1(:,3);
vy_e = x_ans1(:,4);

% Rocket
x_r = x_ans1(:,5);
vx_r = x_ans1(:,6);
y_r = x_ans1(:,7);
vy_r = x_ans1(:,8);

% Moon
x_m = x_ans1(:,9);
vx_m = x_ans1(:,10);
y_m = x_ans1(:,11);
vy_m = x_ans1(:,12);


t_prime=3.8722e5;
ind1=find(t_ans<=t_prime);
%%% Second Half of Problem start
% Moon and Rocket in orbit
xinit2=[
    0;0;0;0;
    0; vx_m(ind1(end))-9.04882e-7; (y_r(ind1(end))); 0;
    0; vx_m(ind1(end)); y_m(ind1(end)); 0;
    ];

tspan2=t_prime:speed:time;
[~,x_ans2] = ode45( @odesolve2, tspan2, xinit2, options );

% Extracting information from ode45
% Earth
x_e2 = x_ans2(:,1);
vx_e2 = x_ans2(:,2);
y_e2 = x_ans2(:,3);
vy_e2 = x_ans2(:,4);

% Rocket
x_r2 = x_ans2(:,5);
vx_r2 = x_ans2(:,6);
y_r2 = x_ans2(:,7);
vy_r2 = x_ans2(:,8);

% Moon
x_m2 = x_ans2(:,9);
vx_m2 = x_ans2(:,10);
y_m2 = x_ans2(:,11);
vy_m2 = x_ans2(:,12);

x_et= vertcat( x_e(ind1(1:end-1)), x_e2 ) ;
y_et= vertcat( y_e(ind1(1:end-1)), y_e2 ) ;
x_rt= vertcat( x_r(ind1(1:end-1)), x_r2 ) ;
y_rt= vertcat( y_r(ind1(1:end-1)), y_r2 ) ;
x_mt= vertcat( x_m(ind1(1:end-1)), x_m2 ) ;
y_mt= vertcat( y_m(ind1(1:end-1)), y_m2 ) ;

X=[x_et x_mt x_rt ];
Y=[y_et y_mt y_rt ];

figure
multicomet(X,Y);

for l=1:length(x_et)
    plot(x_et(l),y_et(l),'k',x_rt(l),y_rt(l),'--r',x_mt(l),y_mt(l),'+b')
    hold on

    xlim([1.5*-x_m0 1.5*x_m0])
    ylim([1.5*-x_m0 1.5*x_m0])
    
    pause(.0001)
end

    function ddt1 = odesolve1(t,x)
        
        G = 6.6573e-12; %Dem^3/(Me s^2)
        m_earth= 1; %Me
        m_moon= .0123; %Me
        M_tot = m_ship + m_fuel ;
        thrust=(k/M_tot);
        
        r12=abs(sqrt( (x(1)-x(5))^2 + (x(3)-x(7) )^2 ))^3;
        r23=abs(sqrt( (x(5)-x(9))^2 + (x(7)-x(11))^2 ))^3;
        r13=abs(sqrt( (x(1)-x(9))^2 + (x(3)-x(11))^2 ))^3;
        if x(5)-x(9)==0
            print(t)
        end
        if t>=(1.8437e4 - 76.667) && t<= (1.8437e4 + 76.667)

            ddt1=[
                x(2);%earth
                G*( (m_moon*(x(5)-x(1)))/r13 );
                x(4);
                G*( (m_moon*(x(7)-x(3)))/r13 );

                x(6);%rocket
                G*( (m_earth*(x(1)-x(5)))/r12 + (m_moon*(x(9)-x(5)))/r23) - thrust*v_exhaust;
                x(8);
                G*( (m_earth*(x(3)-x(7)))/r12 + (m_moon*(x(11)-x(7)))/r23);

                x(10);%moon
                G*( (m_earth*(x(1)-x(9)))/r13 );
                x(12);
                G*( (m_earth*(x(3)-x(11)))/r13 )
                ];
            
            ddt1(1)=0; % until i figure out why sun moves...
            ddt1(2)=0;
            ddt1(3)=0;
            ddt1(4)=0;
        elseif abs(sqrt( (x(5)-x(9))^2 + (x(7)-x(11))^2 ))<=.1 %t>4.7e5 && x(5)<=.1770 && x(5)>=.1750 && t < 5e5%r23<=1.08*LLO && r23>=LLO

            ddt1=[
                x(2);%earth
                G*( (m_moon*(x(5)-x(1)))/r13 );
                x(4);
                G*( (m_moon*(x(7)-x(3)))/r13 );

                (6);%rocket
                G*( (m_earth*(x(1)-x(5)))/r12 + (m_moon*(x(9)-x(5)))/r23) ;
                x(8);
                G*( (m_earth*(x(3)-x(7)))/r12 + (m_moon*(x(11)-x(7)))/r23) ;

                x(10);%moon
                G*( (m_earth*(x(1)-x(9)))/r13 );
                x(12);
                G*( (m_earth*(x(3)-x(11)))/r13 )
                ];
            ddt1(1)=0;
            ddt1(2)=0;
            ddt1(3)=0;
            ddt1(4)=0;        
        else

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
    end

    function ddt2 = odesolve2(t,x)
        
        G = 6.6573e-12; %Dem^3/(Me s^2)
        m_earth= 1; %Me
        m_moon= .0123; %Me
        M_tot = m_ship + m_fuel ;
        thrust=(k/M_tot);
        
        r12=abs(sqrt( (x(1)-x(5))^2 + (x(3)-x(7) )^2 ))^3;
        r23=abs(sqrt( (x(5)-x(9))^2 + (x(7)-x(11))^2 ))^3;
        r13=abs(sqrt( (x(1)-x(9))^2 + (x(3)-x(11))^2 ))^3;
        
        if t>=tprime && t<=tprime+100
            ddt2=[
                x(2);%earth
                G*( (m_moon*(x(5)-x(1)))/r13 );
                x(4);
                G*( (m_moon*(x(7)-x(3)))/r13 );

                x(6);%rocket
                G*((m_moon*(x(9)-x(5)))/r23);
                x(8);
                G*((m_moon*(x(11)-x(7)))/r23);

                x(10);%moon
                G*( (m_earth*(x(1)-x(9)))/r13 );
                x(12);
                G*( (m_earth*(x(3)-x(11)))/r13 )
                ];

            ddt2(1)=0; % until i figure out why sun moves...
            ddt2(2)=0;
            ddt2(3)=0;
            ddt2(4)=0;            
            
        else %F = 6.8182e-28
            ddt2=[
                x(2);%earth
                G*( (m_moon*(x(5)-x(1)))/r13 );
                x(4);
                G*( (m_moon*(x(7)-x(3)))/r13 );

                x(6);%rocket
                G*((m_moon*(x(9)-x(5)))/r23);
                x(8);
                G*((m_moon*(x(11)-x(7)))/r23);

                x(10);%moon
                G*( (m_earth*(x(1)-x(9)))/r13 );
                x(12);
                G*( (m_earth*(x(3)-x(11)))/r13 )
                ];

            ddt2(1)=0; % until i figure out why sun moves...
            ddt2(2)=0;
            ddt2(3)=0;
            ddt2(4)=0;
        end
    end


end

