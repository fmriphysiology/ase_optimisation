%% streamlined-qBOLD paper ASE optimisations
%  figure 3f - effect of qBOLD cut-off time on SNR eff

toN = 10; % total number of echoes
r2p = 3.5e-3; % [ms-1]
t2 = 80; % [ms]
r2 = 1/t2; % [ms-1]
TE = t2; % [ms] TE and tau_max
Tc = [0:10:t2-5]; % characteristic time = 1.5tc 
SNR_sum = zeros(toN,length(Tc)); % final value to be summed
tNn_1 = zeros(toN,length(Tc));
tNn_2 = zeros(toN,length(Tc));
xNn_1 = zeros(toN,length(Tc)); % runnning sum over N component of eqn 
xNn_2 = zeros(toN,length(Tc)); % runnning sum over N component of eqn 
colors = get(gca,'colororder');

N = toN; % total number of echoes used for calculation of R2'
for n = 1:N % loop through each acquisition in N

    tNn_1(n,:) = ((n-1)./(N-1)).*TE;
    tNn_2(n,:) = (((n-1)./(N-1)).*(TE-Tc))+Tc;

    xNn_1(n,:) = exp(-2.*tNn_1(n,:).*r2p);
    xNn_2(n,:) = exp(-2.*tNn_2(n,:).*r2p);


end

SNR_sum_1 = (exp(-TE.*r2).*(r2p./sqrt(N)))./ squeeze( sqrt(  (sum(xNn_1(1:N,:)) ./ ...
    ( ( sum(xNn_1(1:N,:)).*sum(xNn_1(1:N,:) .* (tNn_1(1:N,:).^2)) )...
    - ( sum(xNn_1(1:N,:).*tNn_1(1:N,:)).^2 )))));

SNR_sum_2 = (exp(-TE.*r2).*(r2p./sqrt(N)))./ squeeze( sqrt(  (sum(xNn_2(1:N,:)) ./ ...
    ( ( sum(xNn_2(1:N,:)).*sum(xNn_2(1:N,:) .* (tNn_2(1:N,:).^2)) )...
    - ( sum(xNn_2(1:N,:).*tNn_2(1:N,:)).^2 )))));

h(1,1) = plot(Tc',SNR_sum_1,'Color',colors(1,:)); hold on
h(1,2) = plot(Tc',SNR_sum_2,'Color',colors(2,:)); hold on

%% Format Plot
title(sprintf('T_2 = TE = %1.0f [ms] |  R_2''= %1.1f [s^{-1}] | N = %1.0f',t2,r2p*10^3,N))
xlabel('T_c [ms]');
ylabel('$\frac{SNR}{\frac{S_0}{\sigma_0}}$','interpreter','latex');
xlim([0 max(Tc)])
hlegend = legend(h,{'No T_c', 'T_c'},'Location','southwest');
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
set(hlegend,'FontSize',6);

%% Save
print('figure3f','-depsc2','-r300');
disp('figure3f.eps')