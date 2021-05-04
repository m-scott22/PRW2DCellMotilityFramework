
clear all
close all

% Load data
%load('PRW2Dsim1110001000.mat'); %good
%load('PRW2Dsim25210001000.mat'); %good
%load('PRW2Dsim20008796096.mat'); %good
load('PRW2Dsim20000296096.mat');
%load('PRW2Dsim296096.mat');
xlimz=nPeriods*params.dt; %Set x limit
alphaS=0.05; %for S confidence intervals
alphaP=0.05; %for P confidence intervals
mse=0.5; %MSE threshold for cut offs in P estimates
%%
%Analyse RMSS, VACF, MSD
[rootmeansquspeed,S_est,ne,S_lower,S_upper,x,normalized,allvel,v,g,YP,Tj,P_est,logACF,P_lower,P_upper,MSD,YM]=sphanalysisinsilico2D(Alltraj,N,Ncells,T,alphaS,alphaP,mse);

%% Plot root mean square speed calculated over all cells at each time point, and S on graph

f1 = figure('PaperSize',[20.98 29.68],'PaperPosition',[1 5 40 18]);
h(1)=subplot(2,4,1);
plot(T,rootmeansquspeed,'g','LineWidth',1.5)
xlabel('Time')
ylabel('RMSS')
hold on
line([0,xlimz],[S_est,S_est],'Color','r','LineWidth',1.5)
axis([0 xlimz min(rootmeansquspeed) max(rootmeansquspeed)])
hold on
line([0,length(rootmeansquspeed)],[S_upper,S_upper],'LineStyle','--','Color','k','LineWidth',1.5)
hold on
line([0,length(rootmeansquspeed)],[S_lower,S_lower],'LineStyle','--','Color','k','LineWidth',1.5)


%% Plot lnVACF and line of best fit

h(2)=subplot(2,4,2);
plot(Tj,YP,'Color','r','LineWidth',1.5)
hold on
plot(T,logACF,'Color','k')
xlabel('Time')
ylabel('ln(VACF)')
xlim([0 0.6])

%% Plot histogram of all speeds at all times and overlay Maxwell Boltzmann pdf using S_est 

h(3)=subplot(2,4,5);
bar(x,normalized,'c')
xlabel('Speed')
hold on
plot(v,g,'r','LineWidth',1.5)
hold on


%% Calculate MSD from data, plot with line of best fit and theoretical MSD

h(4)=subplot(2,4,6);
plot(T,MSD,'k','LineWidth',1.5)
xlabel('Time')
ylabel('MSD')
axis([0 xlimz 0 inf])
hold on

%Plot line of best fit
plot(T,YM,'k','LineStyle','--','LineWidth',1.5)
hold on

% Plot the theoretical value using estimates
plot(T,(2.*(S_est^2).*(P_est^2).*(exp(-T./P_est)+(T./P_est)-1)),'r','LineWidth',1.5);


%% Plot trajectories

h(5)=subplot(2,4,[3,4,7,8]);
%plot the (x,y,z) position of the cell
for i=1:Ncells
    S= Alltraj(i,:,:);
    plot(S(1,:,3),S(1,:,4))
    
    hold on
    %hold all
end
axis square
xlabel('x')
ylabel('y')
zlabel('z')  

%% Add sublabels
htext=sublabel(h,0,-15);

%Save figure
print('fullanalysisPRW2Dsim296096', '-djpeg', '-r500')

