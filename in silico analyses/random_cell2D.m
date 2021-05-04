
function MDL=random_cell2D(params) %Function for defining drift and diffusion vectors required to simulate the PRW model

%vx=p(1)
%vy=p(2)
%x=p(3)
%y=p(4)

%this is the drift vector in the SDE
%the first 2 components are vx and vy
%the 4th and 5th components represent dx/dt=vx; dy/dt=vy; 

 F = @(t,p)[-p(1)/params.P;...
            -p(2)/params.P;...
            p(1);...
            p(2)];% updating the drift
       
  
 %this is the diffusion tensor in the SDE 
   G=@(t,p)[params.S/sqrt(params.P) 0 0 0 ;...
            0  params.S/sqrt(params.P) 0 0;...
            0 0 0 0;...
            0 0 0 0]; %% updating the diffusion function
   
%construct the SDE with specified initial conditions 
MDL = sde(F,G,'StartState', [params.vx0;params.vy0;params.x0;params.y0],'StartTime',params.t0);


end