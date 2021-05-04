clear all
close all

% Input parameter values for speed S and persistence time P
params.S=2;
params.P=0.0002;

% Initialise cells at the origin
params.x0=0;
params.y0=0;


params.t0=0;
params.dt=0.05; %this is needed in the stochastic simulations, 
nPeriods=960;  %total time is nPeriods*dt

Ncells=96;


% figure(1)
% subplot(2,2,1)

%for each cell
for cell=1:Ncells
    
    %initialise random orientation
    params.theta0=2*pi*rand;
    params.vx0=params.S*cos(params.theta0);
    params.vy0=params.S*sin(params.theta0);

    MDL=random_cell2D(params); 
    [S,T]=simByEuler(MDL, nPeriods,'DeltaTime',params.dt);

    %the output S(:,i) gives vx (i=1), vy (i=2), x (i=3), y (i=4) as a
    %function of time
    
   
    %enter the data for this cell into a master array Alltraj
    [N,M]=size(S);
    for  i=1:N
        for j=1:M
            Alltraj(cell,i,j)=S(i,j);
        end
    end
    
end

save(['PRW2Dsim',num2str(params.S),num2str(nPeriods),num2str(Ncells)])