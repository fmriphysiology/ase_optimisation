%% streamlined-qBOLD paper ASE optimisations
%  figure 3d - show the combined effects of T2 & R2' on TEmax 

toN = 4; % total number of echoes
t2p = [1e6 1e3 1e2 1e1]; 
r2p = 1./t2p; % [s-1]
d = 0.1; % [ms] increments in t2 and line
t2 = [d:d:500]'; % [ms]
delta = [0:d:3000]'; % [ms] this is TE and tau_max
SNR_sum = zeros(length(r2p),length(delta),length(t2)); % final value to be summed
tNn = zeros(length(r2p),toN,length(delta));
xNn = zeros(length(r2p),toN,length(delta)); % runnning sum over N component of eqn 
delta_maxID = zeros(toN,length(t2));
linewidth =  1; % plot linewidth
figure(13), hold on
colors = get(gca,'colororder');

N = toN; % total number of echoes in acquisiton
 
for r2pid = 1:length(r2p) % loop through R2'
    for n = 1:N % loop through each acquisition in N

        tNn(r2pid,n,:) = ((n-1)./(N-1)).*delta; % calculate tau
        xNn(r2pid,n,:) = exp(-2.*tNn(r2pid,n,:).*r2p(r2pid)); % delta_R2p decay

    end

    for t2_ID = 1:length(t2)

        SNR_sum(r2pid,:,t2_ID) = (exp(-delta.*(1/t2(t2_ID))).*(r2p(r2pid)./sqrt(N)))./ squeeze( sqrt(  (sum(xNn(r2pid,1:N,:)) ./ ...
            ( ( sum(xNn(r2pid,1:N,:)).*sum(xNn(r2pid,1:N,:) .* (tNn(r2pid,1:N,:).^2)) )...
            - ( sum(xNn(r2pid,1:N,:).*tNn(r2pid,1:N,:)).^2 )))));

        tmp_id = find(squeeze(SNR_sum(r2pid,:,t2_ID)) == max(squeeze(SNR_sum(r2pid,:,t2_ID))));
        delta_maxID(r2pid,t2_ID) = ind2sub(size(squeeze(SNR_sum(r2pid,:,t2_ID))),tmp_id);

    end

    % Plot TEmax vs T2
    figure(12), hold on
    leg_str{r2pid} = sprintf('R_2''=%2.2f [s^{-1}]',r2p(r2pid)*10^3); 
    h(1,r2pid) = plot(t2,delta(delta_maxID(r2pid,:)),'Color',colors(r2pid,:),'Linewidth',linewidth), xlabel('T_2 [ms]'), ylabel('TE_{max} [ms]');
end

%% Format Plot
title(sprintf(' N = %1.0f ', N))
hlegend = legend(h(1,:),leg_str,'Location','northwest');

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

%% save
print('figure3d.eps','-depsc2','-r300');
disp('figure3d.eps')