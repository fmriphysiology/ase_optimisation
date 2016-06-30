%% streamlined-qBOLD paper ASE optimisations
%  figure 3a - optimisation without T2 weighting

toN = 3:2:9; % total number of echoes
r2p = 3.5e-3; % [ms-1]
t2 = 0; % [ms]
r2 = 0; % [ms-1]
TE = [0:0.01:1000]'; % [ms] TE and tau_max
SNR_sum = zeros(length(toN),length(TE)); % final value to be summed
tNn = zeros(length(toN),max(toN),length(TE));
xNn = zeros(length(toN),max(toN),length(TE)); % runnning sum over N component of eqn 
colors = get(gca,'colororder');

Ncount = 0; 
for N = toN % total number of echoes used for calculation of R2'
    Ncount = Ncount + 1;
    for n = 1:N % loop through each acquisition in N
                
        tNn(Ncount,n,:) = ((n-1)./(N-1)).*TE; % calculate tau
        xNn(Ncount,n,:) = exp(-2.*tNn(Ncount,n,:).*r2p); 
        
    end
    
    SNR_sum(Ncount,:) = (exp(-TE.*r2).*(r2p./sqrt(N)))./ squeeze( sqrt(  (sum(xNn(Ncount,1:N,:)) ./ ...
        ( ( sum(xNn(Ncount,1:N,:)).*sum(xNn(Ncount,1:N,:) .* (tNn(Ncount,1:N,:).^2)) )...
        - ( sum(xNn(Ncount,1:N,:).*tNn(Ncount,1:N,:)).^2 )))));
      
    leg_str(Ncount,:) = sprintf('J=%2.0f',N); 
    h(1,Ncount) = plot(TE',SNR_sum(Ncount,:),'Color',colors(Ncount,:)); hold on
end
 
%% Format Plot
title(sprintf('T_2 = %1.0f [ms] |  R_2'' = %1.1f [s^{-1}]',t2,r2p*10^3))
xlabel('TE [ms]');
ylabel('$\frac{SNR}{\frac{S_0}{\sigma_0}}$','interpreter','latex');
xlim([0 max(TE)])
ylim([0 0.3])
hlegend = legend(h,leg_str,'Location','southeast');
box on

%% Format figure
a=findobj(gcf);
allaxes=findall(a,'Type','axes');
alllines=findall(a,'Type','line');
alltext=findall(a,'Type','text');
set(allaxes,'FontName','Helvetica Neue','FontWeight','normal','LineWidth',1,'FontSize',7);
set(alllines,'Linewidth',1)
set(alltext,'FontName','Helvetica Neue','FontSize',7);
box on
width = 6; height = 6;
set(gcf,'PaperUnits','centimeters','PaperPosition',[1 1 width height])
set(hlegend,'FontSize',6);

%% Save
print('figure3a','-depsc2','-r300');
disp('figure3a.eps')
