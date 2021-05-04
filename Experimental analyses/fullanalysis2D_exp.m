
clear all
close all

% Load data
load('Alltrajdata2D1703.mat'); 
xlimz=NPeriods*DT; %Set x limit
alphaS=0.05; %for S confidence intervals
alphaP=0.05; %for P confidence intervals
mse=1; %MSE threshold for cut off in P estimates
%%
%Analyse RMSS, VACF, MSD
[rootmeansquspeed,S_est,ne,S_lower,S_upper,x,normalized,allvel,v,g,YP,Tj,P_est,logACF,lnACF,P_lower,P_upper,MSD,YM,ACF]=sphanalysis2D(tracking_data,NPeriods,Ncells,T,alphaS,alphaP,mse);

%% Plot root mean square speed calculated over all cells at each time point, and S on graph

f1 = figure('PaperSize',[20.98 29.68],'PaperPosition',[1 5 40 18]);
h(1)=subplot(2,2,1);
plot(T,rootmeansquspeed,'g','LineWidth',1.5)
xlabel('Time(h)')
ylabel('RMSS')
hold on
line([0,xlimz],[S_est,S_est],'Color','r','LineWidth',1.5)
axis([0 xlimz min(rootmeansquspeed) max(rootmeansquspeed)])
hold on
line([0,length(rootmeansquspeed)],[S_upper,S_upper],'LineStyle','--','Color','k','LineWidth',1.5)
hold on
line([0,length(rootmeansquspeed)],[S_lower,S_lower],'LineStyle','--','Color','k','LineWidth',1.5)


%% Plot lnVACF and line of best fit

h(2)=subplot(2,2,2);
plot(Tj,YP,'Color','r','LineWidth',1.5)
hold on
plot(T,logACF,'Color','k')
xlabel('Time (h)')
ylabel('ln(VACF)')
%xlim([0 0.6])

%% Plot histogram of all speeds at all times and overlay Rayleigh pdf using S_est 

h(3)=subplot(2,2,3);
bar(x,normalized,'c')
xlabel('Speed (um/h)')
hold on
plot(v,g,'r','LineWidth',1.5)
hold on


%% Calculate MSD from data, plot with line of best fit and theoretical MSD

h(4)=subplot(2,2,4);
plot(T,MSD,'k','LineWidth',1.5)
xlabel('Time (h)')
ylabel('MSD')
%axis([0 xlimz 0 inf])
hold on

%Plot line of best fit
plot(T,YM,'k','LineStyle','--','LineWidth',1.5)
hold on

%P_est=0.000122;
% Plot the theoretical value using estimates
plot(T,(2.*(S_est^2).*(P_est^2).*(exp(-T./P_est)+(T./P_est)-1)),'r','LineWidth',1.5);

%Add sublabels
htext=sublabel(h,0,-15);
%Save figure
print('1703-plots', '-djpeg', '-r500')

%% Plot trajectories
figure
%plot the (x,y) position of the cell
for i=1:Ncells
    S= tracking_data(i,:,:);
    plot(S(1,:,3),S(1,:,4))
    
    hold on
    %hold all
end
axis square
axis([0,0.8,0,0.8])
xlabel('x (um)')
ylabel('y (um)') 

%%

%Save figure
print('1703-tracks', '-djpeg', '-r500')

