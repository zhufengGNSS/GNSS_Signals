% ****************************************************************************
% AllanVariance.m :Compute Phase or Frequency Sequence's Allan Variance
%  
%           Copyright (C) 2019 by Jason DING , All rights reserved.
%  
%    version :$Revision: 1.0 $ $Date: 2019/04/04 $
%    history : 2019/04/04  1.0  new
%              2019/04/05  1.1  add Modified Allan variance and Time variance.
% ****************************************************************************

function AllanVariance = AVAR_Phase(PhaseSequence,tau,m)
% Calculate the Allan variance of the time difference (phase) sequence.*****
% Given:
%       PhaseSequence      Phase sequence  
%       tau                Sampling interval     
%       m                  Smoothing factor   
% Returned:
%       AllanVariance      Allan variance
% *************************************************************************
M = length(PhaseSequence);
M_= fix(M/m)+1;
bias = zeros(M_,1);
for i = 1:M_-2
    if ((i+1)*m+1 <= M)
        bias(i,1) = PhaseSequence((i+1)*m+1)-2*PhaseSequence(i*m+1)+PhaseSequence((i-1)*m+1);
    end
end
AllanVariance=(bias*bias')/(2*(N-2)*tau*tau);
end

function AllanVariance = AVAR_Freq(FrequencySequence,m)
% Calculate the Allan variance of the frequency sequence.*******************
% Given:
%       FrequencySequence      Frequency sequence(n*1)    
%       m                      Smoothing factor       
% Returned:
%       AllanVariance          Allan variance
% *************************************************************************
M = length(FrequencySequence);
M_= fix(M/m)+1;
bias = zeros(M_-1,1);
for i = 1:M_-1
    if i < M_-1
        bias(i,1) = mean(FrequencySequence((i*m+1):(i+1)*m,1)) ...
                  - mean(FrequencySequence((i-1)*m+1:i*m,1)); 
    else
        bias(i,1) = mean(FrequencySequence((i*m+1):M,1)) ...
                  - mean(FrequencySequence((i-1)*m+1:i*m,1)); 
    end
end
AllanVariance=(bias'*bias)/(2*(M_-1));
end

function Mod_AllanVariance = MAVAR_Phase(PhaseSequence,tau,m)
% Calculate the Modified Allan variance of the time difference (phase) sequence.
% Given:
%       PhaseSequence      Phase sequence  
%       tau                Sampling interval  
%       m                  Smoothing factor       
% Returned:
%       Mod_AllanVariance  Modified Allan variance
% *************************************************************************
N = length(PhaseSequence);
sum = 0;
for j=1:N-3*m+1
    for i=j:j+m-1
        sum = sum+(PhaseSequence(i+2*m)-2*PhaseSequence(i+m)+PhaseSequence(i))^2;
    end
end
Mod_AllanVariance = sum/(2*m^2*tau^2*(N-3*m+1));
end

function Mod_AllanVariance = MAVAR_Freq(FrequencySequence,m)
% Calculate the Modified Allan variance of the frequency sequence.*********
% Given:
%       FrequencySequence      Frequency sequence         
%       m                      Smoothing factor
% Returned:
%       Mod_AllanVariance      Modified Allan variance
% *************************************************************************
M = length(FrequencySequence);
sum = 0;
for j=1:M-3*m+2
    for i=j:j+m-1
       for k=i:i+m-1
           sum = sum+(FrequencySequence(k+m)-FrequencySequence(k))^2;
       end
    end
end
Mod_AllanVariance = sum/(2*m^4*(M-3*m+2));
end

function TimeVariance = TVAR(ModAVAR,tau)
% Calculate the Time Variance. ********************************************
% Given:
%       ModAVAR                Modified Allan variance      
%       tau                    Sampling interval  
% Returned:
%       TimeVariance           Time Variance
% *************************************************************************
TimeVariance = ModAVAR*tau/sqrt(3);
end















