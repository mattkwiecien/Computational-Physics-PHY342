function [ c_vals ] = efield( q, x1, x2, x3 )
%efield will take as inputs the magnitude of the charge, q, and the
%positions of the charge, x1, x2, and x3, and find where the electric field
%produced by the charges are 0.
k=1/(4*pi*8.854187817e-12);
a=max([x1,x2,x3]);
b=min([x1,x2,x3]);
c=median([x1,x2,x3]);

dist1=abs(b-c);
dist2=abs(c-a);
dt1=dist1/1e9;
dt2=dist2/1e9;
dt=max([dt1,dt2]);

x=linspace(1-b, 1+a, 50);
y=linspace(-(1+a), 1+a, 50);
[X,Y]=meshgrid(x,y);

try 
    [c1] = fzero(@efield, [b+dt,c-dt]);
catch
    c1=0;
    fprintf('failed to find a root between the first two charges \n')
end
try 
    [c2] = fzero(@efield, [c+dt,a-dt]);
catch
    c2=0;
    fprintf('failed to find a root between the last two charges \n')
end

c_vals=[c1,c2];
c_vals(c_vals==0)=[];

r_vec1 = 1./(abs(X-x1).^2 + abs(Y).^2).^(3/2);
r_vec2 = 1./(abs(X-x2).^2 + abs(Y).^2).^(3/2);
r_vec3 = 1./(abs(X-x3).^2 + abs(Y).^2).^(3/2);
 
E_x = (q*k).*( ((X-x1)./r_vec1) + ((X-x2)./r_vec2) + ((X-x3)./r_vec3) );
E_y = (q*k).*( (Y./r_vec1) + (Y./r_vec2) + (Y./r_vec3) );

try
    quiver(X,Y,E_x, E_y)
    hold on
    ylim([-(1+a),1+a])
    xlim([-1+min([x1,x2,x3]),1+max([x1,x2,x3])])
    plot([x1,x2,x3,],0,'.r', 'MarkerSize',20)
    plot(c_vals,0,'xb', 'MarkerSize', 15)
catch
    fprintf('No roots present.')
end

    function strength = efield(x)
       
        q1_dist=1./(abs(x-x1)^2) ;
        q2_dist=1./(abs(x-x2)^2) ;
        q3_dist=1./(abs(x-x3)^2) ;
        strength=q*k*( ((x-x1)/q1_dist^(3/2)) + ((x-x2)/q2_dist^(3/2)) + ((x-x3)/q3_dist^(3/2)) );
        
    end
end

