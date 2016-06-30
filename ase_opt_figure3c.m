%% streamlined-qBOLD paper ASE optimisations
%  figure 3c - effect of T2 and TE on SNR

N = 4; % total number of echoes
r2p = 3.5e-3; % [ms-1]
dt2 = 40;
t2 = [dt2:dt2:dt2*4]; % [ms]
r2 = 1./t2; % [ms-1]
TE = [0:0.1:800]'; % [ms] TE and tau_max
SNR_sum = zeros(N,length(TE),length(t2)); % final value to be summed
tNn = zeros(N,N,length(TE));
xNn = zeros(N,N,length(TE)); % runnning sum over N component of eqn 
colors = get(gca,'colororder');

for N = N % total number of echoes used for calculation of R2'
    for n = 1:N % loop through each acquisition in N

        tNn(N,n,:) = ((n-1)./(N-1)).*TE; % calculate tau
        xNn(N,n,:) = exp(-2.*tNn(N,n,:).*r2p); 

    end
    for r2id = 1:length(r2)
        SNR_sum(N,:,r2id) = (exp(-TE.*r2(r2id)).*(r2p./sqrt(N)))./ squeeze( sqrt(  (sum(xNn(N,1:N,:)) ./ ...
            ( ( sum(xNn(N,1:N,:)).*sum(xNn(N,1:N,:) .* (tNn(N,1:N,:).^2)) )...
            - ( sum(xNn(N,1:N,:).*tNn(N,1:N,:)).^2 )))));

        leg_str{r2id} = sprintf('T_2=%2.0f [ms]',t2(r2id)); 
        h(1,r2id) = plot(TE',squeeze(SNR_sum(N,:,r2id)),'Color',colors(r2id,:)); hold on
    end
end

 
%% Format Plot
title(sprintf('R_2''= %1.1f [s^{-1}]  |  N = %1.0f ', r2p*10^3, N))
xlabel('TE [ms]');
ylabel('$\frac{SNR}{\frac{S_0}{\sigma_0}}$','interpreter','latex');
xlim([0 max(TE)])
hlegend =legend(h(1,1:end),leg_str);

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
print('figure3c','-depsc2','-r300');
disp('figure3c.eps')
