function [  ] = neutron_density( L,N )
T=0;
h=L/(N-1);  
D=10e5;     
C=10^8;     
tau=h^2/(6*D);

rho=zeros(1,L+1);
rho(1,floor((L+1)/2))=1;

rho(1)=0;
rho(end)=0;

rhoR=[rho(2:end) rho(1)];
rhoL=[rho(end) rho(1:end-1)];


rhoTot= ( ( D.*( rhoR + rhoL - 2.*rho )./ h^2 ) - C.*rho )*tau + rho;

f=figure;
p=plot(1:L+1,rhoTot);

count=0;

while T<100
    count=count+1;
    T=count*tau;
    rhoTot= ( ( D.*( rhoR + rhoL - 2.*rho )./ h^2 ) - C.*rho )*T + rho;

    if ishandle(f)
        
        set(p,'ydata', rhoTot)
        
    else
        
        break

    end
    
end

    

end

