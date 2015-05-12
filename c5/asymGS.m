function [ grid ] = asymGS( n, E )
% Written by Matthew Kwiecien in 2014

% asymGS function will animate the solution laplaces equation on a
% complicated geometry.

% preallocation
BC=1;
grid=zeros(2*n,3*n);
old_grid=ones(2*n,3*n);

% creating the grid for our problem
for i=1:n
    for j=1:3*n
        if j<=n || j>2*n 
            grid(i, j) = NaN;
            old_grid(i, j) = NaN;
        end
    end
end

% setting up boundary conditions
% Each number corresponds to index of bc_vec
%        ___1__
%       |      |
%      8|      |2
%  __7__|      |__3__
% |                  |
%6|                  |4
% |_________5________|
%
bc_vec = [1,0,.5,0,1,0,.5,0];

%top mid
grid(1:n, (n+1))=bc_vec(2);
%horz mid
grid(n+1, 1:n+1)=bc_vec(3);
%bot right
grid(n+1:2*n, 1)=bc_vec(4);

%top mid
grid(1:n, (2*n))=bc_vec(8);
%horz mid
grid(n+1, (2*n)-1:3*n)=bc_vec(7);
%bot left
grid(n+1:2*n, 3*n)=bc_vec(6);

%bottom
grid((2*n), 2:(3*n)-1)=bc_vec(5);
%top
grid(1,n+1:(2*n)-1) = bc_vec(1); 


err=1;

%second function of code - only outputs numerical grid result
if nargin==2
    
    while err>E
        for i=2:2*n-1
            if i<=n+1
                for j=(n+2):(2*n - 1)
                    grid(i,j) = 1/4*(grid(i-1,j) + grid(i,j-1) + grid(i,j+1) + grid(i+1,j));
                end
            elseif i>n+1
                for j=2:(3*n)-1
                    grid(i,j) = 1/4*(grid(i-1,j) + grid(i,j-1) + grid(i,j+1) + grid(i+1,j));
                end
            end
        end

        ind1=isnan(grid);
        ind2=isnan(old_grid);
        grid_vals = grid(~ind1);
        old_grid_vals = old_grid(~ind2);

        err=sum(sum(abs(grid_vals-old_grid_vals)));
        old_grid=grid;
    end
    
else
%animation of Gauss seidel solution to PDE
    x=linspace(0,1,3*n);
    y=linspace(0,1,2*n);
    [X,Y] = meshgrid(x,y);
    h=surf(X,Y,grid);
    view(-40,65)
    hold on
    shading interp
    %error parameter
    E=BC*1e-6;
    while err>E
        %GS method
        for i=2:2*n-1
            if i<=n+1
                for j=(n+2):(2*n - 1)
                    grid(i,j) = 1/4*(grid(i-1,j) + grid(i,j-1) + grid(i,j+1) + grid(i+1,j));
                end
            elseif i>n+1
                for j=2:(3*n)-1
                    grid(i,j) = 1/4*(grid(i-1,j) + grid(i,j-1) + grid(i,j+1) + grid(i+1,j));
                end
            end
        end
        %find indices where matrix is NaN
        ind1=isnan(grid);
        ind2=isnan(old_grid);
        %remove NaNs
        grid_vals = grid(~ind1);
        old_grid_vals = old_grid(~ind2);
        %calculate sum of differences between current grid and old grid
        err=sum(sum(abs(grid_vals-old_grid_vals)));
        set(h,'Zdata',grid);
        pause(.001)
        %set current grid to old grid
        old_grid=grid;
    end

    close;
    sprintf('finished')
end

end

