function [  ] = analytic_apollo( )
% Moon, Earth, and Rocket 
radius_earth = 6370;    radius_moon = 1737.4;
LLO = 100;              LEO = 431;

% ========================== Moon Parameters =============================
m_min = 362600; m_max = 405400;
eccen_moon = .0549; 

% ========================== Rocket Parameters ===========================
rocket_min = radius_earth+LEO; rocket_max = 410000; 
eccen_rocket = (rocket_max - rocket_min)/(rocket_max + rocket_min);

% ======================= Polar Coordinates of Orbit =====================

phi = linspace(0,2*pi,1000);

% ======================= Moon Analytic Solution =========================
c_moon = m_min * (1+eccen_moon);
r_moon = c_moon./(1+eccen_moon.*cos(phi));

% ====================== Rocket Analytic Solution ========================
c_rocket = rocket_min * (1+eccen_rocket);
r_rocket = c_rocket./(1+eccen_rocket.*cos(phi));
 



x_moon = r_moon.*cos(phi); y_moon = r_moon.*sin(phi);
x_rocket = r_rocket.*cos(phi); y_rocket = r_rocket.*sin(phi);

figure; hold on;
plot(x_moon,y_moon); plot(0,0,'ro');
plot(x_rocket,y_rocket, '-r');


end
