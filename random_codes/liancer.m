function [ output_args ] = liancer( a,b,c,d )


if b^2 == 3*a*c;
    root_con=1;       
elseif b^2 < 3*a*c;       
    root_con=2;       
elseif b^2 > 3*a*c;
    root_con=3;
end

%%%%
if root_con==3;
% Three roots possible (max/min) 
    min = ( -b - sqrt(b^2 - (3*a*c)) )/ (3*a);
    max = ( -b + sqrt(b^2 - (3*a*c)) )/ (3*a);
    %
    y_max = ( a*max^3 ) + ( b*max^2 ) + ( c*max ) + d;
    y_min = ( a*min^3 ) + ( b*min^2 ) + ( c*min ) + d;
    
    dist=abs(max-min);
    x_mid=(max-min)/2;
    guess_metric=3*dist;
    
    % above x-axis (1 root)
    if y_min>0 && y_max>0
        
        if a<0
            x_g = x_mid + guess_metric;       
        elseif a>0
            x_g = x_mid - guess_metric;            
        end
     % below x-axis (1 root)
    elseif y_min<0 && y_max<0
        
        if a<0
            x_g = x_mid - guess_metric;       
        elseif a>0
            x_g = x_mid + guess_metric;            
        end
     % above and below (3 roots)
    else
        
        x_g = x_mid;
        
    end
    
elseif root_con==1
 %saddle point, one root
    sad_pt = -b/(3*a);
    y_sad_val = (a * sad_pt^3) + (b* sad_pt^2) + (c* sad_pt) + d;
    
    if y_sad_val > 0
         
        if a > 0
            x_g = sad_pt-1;
        elseif a < 0
            x_g = sad_pt+1;
        end
        
    elseif y_sad_val < 0
        
        if a < 0 
            x_g = sad_pt -1;
        elseif a > 0
            x_g = sad_pt+1;
        end
        
    else
        
        root2=y_sad_val;
    end
    
elseif root_con==2
    
    x_g = 0
    
end
%%%%

y_prime= (3*a*(x_g)^2) + (2*b*x) + c;

if y_prime < 10^-8
    x_g = x_g+1;
end

% if root_con==2 || root_con==1
%     if d==0
%         root1=0
%     end
% end




        
    
    

    
end
    
    
    
    
    
end

