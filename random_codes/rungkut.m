function[ ] = rungkut(a,b,theta0,omega0,T,tau,g,l)

num_step = T/tau;
t = 0:tau:num_step+1;

w2=1/(2*a);
w1=1-w2;

omega=zeros(1,length(t));
theta=zeros(1,length(t));

omega(1) = omega0;
theta(1) = w0;

    for i=1:length(t)
        
        [domega,dtheta] = derivvy(omega(i),theta(i));
        theta_star = theta(i) + tau*b*domega;
        omega_star = omega(i) + (tau*b)*((-g/l)*(sin(theta(i))));
      
        [domega,dtheta] = derivvy(theta_star);
        theta(i+1) = theta(i) + tau*(w1*dtheta + 
    
    
    
    end

    function[domega,dtheta] = derivvy(omega,theta)
        dtheta = omega;

        domega = (-g/l)*sin(theta);
    end
end