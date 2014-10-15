k_init=.075;
dk=k_init/50;
k=.04:dk:2*k_init;

range=zeros(1,length(k));

for i=1:1:length(k)
    range(i)=rocket_sim(45,6000,k(i),1000,1001,1);
end
best_ind=find(max(range));
worst_ind=find(min(range));
fprintf('The average range at varying thrust coefficients is %f meters\n', mean(range))
fprintf('The best coefficient was k=%f giving a range of %f meters\n', k(best_ind) ,max(range))
fprintf('The worst coefficient was k=%f giving a range of %f meters\n', k(worst_ind) ,min(range))

plot(range,k,'+b')
grid on
title('Thrust coefficient versus range of rocket')
xlabel('Distance (m)')
ylabel('Thrust Coefficient')