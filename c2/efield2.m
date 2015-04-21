    function strength = efield2(x)
       q=1;
       k=1/(4*pi);
        x1=1;
        x2=2;
        x3=3;
    
        q1_dist = 1/(abs(x-x1))^(3/2) ;
        q2_dist = 1/(abs(x-x2))^(3/2) ;
        q3_dist = 1/(abs(x-x3))^(3/2) ;
        strength = q*k*( ((x-x1)*q1_dist) + ((x-x2)*q2_dist) + ((x-x3)*q3_dist) );
        
    end