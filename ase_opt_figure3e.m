%% streamlined-qBOLD paper ASE optimisations
%  figure 3e - relationship between SNR effeciency and number of
%  tau_weighted points

toN = 50; % total number of echoes
r2p = 3.5e-3; % [ms-1]
t2 = 80; % [ms]
r2 = 1/t2; % [ms-1]
TE = 80; % [ms] TE and tau_max
SNR_sum = zeros(toN,length(TE)); % final value to be summed
tNn = zeros(toN,toN,length(TE));
xNn = zeros(toN,toN,length(TE)); % runnning sum over N component of eqn 
figure(3), hold on
colors = get(gca,'colororder');

for N = 1:toN % total number of echoes used for calculation of R2'
    for n = 1:N % loop through each acquisition in N
        
        tNn(N,n,:) = ((n-1)./(N-1)).*TE; % calculate tau
        xNn(N,n,:) = exp(-2.*tNn(N,n,:).*r2p); 
        
    end
    
    SNR_sum(N,:) = (exp(-TE.*r2).*(r2p./sqrt(N)))./ squeeze( sqrt(  (sum(xNn(N,1:N,:)) ./ ...
        ( ( sum(xNn(N,1:N,:)).*sum(xNn(N,1:N,:) .* (tNn(N,1:N,:).^2)) )...
        - ( sum(xNn(N,1:N,:).*tNn(N,1:N,:)).^2 )))));
      
end

plot(2:toN,SNR_sum(2:toN,:))

%% Format Plot 
title(sprintf('T_2 = TE = %1.0f [ms] |  R_2''= %1.1f [s^{-1}]',t2,r2p*10^3))
xlabel('N');
ylabel('$\frac{SNR}{\frac{S_0}{\sigma_0}}$','interpreter','latex');
xlim([0 toN])
ylim([0 0.044])
box on

%% Format figure
a=findobj(gcf);
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
set(allaxes,'FontName','Helvetica Neue','FontWeight','normal','LineWidth',1,'FontSize',7);
set(alllines,'Linewidth',1)
set(alltext,'FontName','Helvetica Neue','FontSize',7);
width = 6; height = 6;
set(gcf,'PaperUnits','centimeters','PaperPosition',[1 1 width height])

%% Save
print('figure3e','-depsc2','-r300');
disp('figure3e.eps')
