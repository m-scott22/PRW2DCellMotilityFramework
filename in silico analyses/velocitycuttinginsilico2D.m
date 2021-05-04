function [Tj,Y,P,fulllogACF,P_lower,P_upper]=velocitycuttinginsilico2D(Alltraj,Ncells,T,alphaP,mse)
%Choose robustness
MSEchoice=mse; %MSE threshold
n=120; %Number of spaces in cutoffs vector

for cell=1:Ncells
    %compute the velocity correlation over time for an individual cell 
    for i=1:length(T)
        ACF_cell(cell,i)= Alltraj(cell,1,1).*Alltraj(cell,i,1)+ Alltraj(cell,1,2).*Alltraj(cell,i,2);
    end
end

%compute the mean velocity autocorrelation (VACF)
ACF=nanmean(ACF_cell)
fulllogACF=log(ACF)


indexneg=find(ACF<0,1);
if indexneg>1
    ACF=ACF(1:indexneg-1);
    Tnew=T(1:indexneg-1);
else
    Tnew=T;
end

Tnew
logACF=log(ACF)
minlogACF=min(logACF);
maxlogACF=max(logACF);

%Create vector of cutoffs in lnACF
cutoffs=linspace(maxlogACF,minlogACF,n);

%% Choose cutoff which satistifes MSE condition

MSE=zeros(1,length(cutoffs)-1);
indexACF=zeros(1,length(cutoffs)-1);
P_est=zeros(1,length(cutoffs)-1);

for j=1:length(cutoffs)-1
    
    %Eliminate all entries less than cutoff by finding the first one that
    %strays below the cutoff
    indexACF(j)=find(logACF < cutoffs(j),1);
    lnACF=logACF(1:indexACF(j)-1);
    Tj=Tnew(1:length(lnACF)); 
    
    if length(Tj)>5
        %Fit a line of best fit to the log data but change sign
        [coeffsP]=fgls(Tj,-lnACF,'innovMdl','AR','numIter',10,'resCond',true);
        YP=coeffsP(1)+coeffsP(2)*Tj;
        P_est=1/coeffsP(2);
        
        %Calculate MSE for all possible cutoffs
        SE=zeros(length(lnACF),1);
        for k=1:length(lnACF)
            SE(k)=lnACF(k)-YP(k);
        end 

        MSE(j)=nanmean(SE.^2);

        % Estimate P from log VACF for this cutoff
        P_est(j)=1/coeffsP(2);
    end

end 

%Choose final cutoff
finalcutoffindex=find(MSE<MSEchoice,1,'last');
finalcutoff=cutoffs(finalcutoffindex);

MSE
%% Use cutoff to make a subset for line fit, fit line and calculate CI for P
%Cut lnACF to relevant cutoff point
logACF = log(ACF);
lnACF=[];
 for i=1:length(logACF)
  if logACF(i) >= finalcutoff
      lnACF=[lnACF,logACF(i)];
  end
 end
 
Tj=T(1:length(lnACF));

%Fit fgls model to updated subset
[coeffsP,seP]=fgls(Tj,-lnACF,'innovMdl','AR','numIter',10,'resCond',true);
P=1/coeffsP(2);
beta = coeffsP(2);
se_beta = seP(2);

%Calculate confidence limits
n = length(lnACF);
tval = tinv(1-alphaP/2,n-2);
beta_left = beta - tval*se_beta;
beta_right = beta + tval*se_beta;
P_upper=1/beta_left;
P_lower=1/beta_right;

%Model for plotting
[coeffsP]=fgls(Tj,lnACF,'innovMdl','AR','numIter',10,'resCond',true);
Y=coeffsP(1)+coeffsP(2)*Tj;

end