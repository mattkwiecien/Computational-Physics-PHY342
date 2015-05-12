function [ stop ] = stoppingVal( N )
% Written by Matthew Kwiecien in 2014

%assuming 'truth' value at 1e-12
s0 = 1e-14;
best_grid = asymGS(N, s0);

%setting up a parameter range
stop = logspace(-2, -12, 20);
err = zeros(size(stop));

%calculating error at each parameter value
for i = 1:length(stop)
    
    grid = asymGS(N, stop(i));

    ind1=isnan(grid);
    ind2=isnan(best_grid);
    grid_vals = grid(~ind1);
    old_grid_vals = best_grid(~ind2);

    err(i) = sum(sum(abs(grid_vals-old_grid_vals)));
    
end

%plot results
figure
loglog(stop, err, 'o', 'linewidth', 2);
set(gca, 'fontsize', 18)

xlabel('stopping paramater')
ylabel('error')


end

