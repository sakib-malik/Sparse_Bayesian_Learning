rng(786); % setting the random number generator seed
%% Generating Synthetic Data

N = 20; % Number of data points
M = 40; % Numer of features
Do = 7; % Number of Non zero weights 
          
Phi = randn(N, M); % PHI(N X M) design matrix

w = zeros(M, 1); % Weight vector initially filled with all zeros
k = randperm(M, Do); % random permutation of 'Do' rows from 'M' rows
w(k, :) = randn(Do, 1); % 'Do' values of w to be drawn from standard normal-N(0, 1)

t = zeros(N, 5); % t(:, i) contains target (t) for i'th noise variance 
w_map = zeros(M, 5); % output sparse parameters for each of the noise variance, w(:, i) contains the output map estimate for ith noise variance.

i = 1; % iteration number for each noise variance

s2_dB = [-20 -15 -10 -5 0]; % list of noise variance in dB
s2_act = 10.^(s2_dB/10); % list of noise variance in actual units

%% Main Loop to calculate W_MAP or each of the noise variance
for sigma2 = s2_act  % for each of the noise variance
    
    eps = sqrt(sigma2).*randn(N,1); % e_n ~ N(0,sigma^2) - error term
    
    t(: , i) = Phi * w + eps; % output vector (t) for this noise variance
    
    % SBL takes as input [output(t), PHI (design matrix), N, M, beta(1 / sigma^2)]
    w_map(: , i) = SBL_prun(t(:, i), Phi, N, M, 1/sigma2); % sparse parameter w_map for this noise variance
    
    i = i + 1;
end
fprintf("The Map estimate for w is\n");
disp(w_map)
% NMSE = sum((w_map - w).^2)/ sum(w.^2);
% plot(s2, NMSE, '-o');
%% Calculating AVG NMSE for each noise variance for 100 loops and plotting

NMSE_AVG = zeros(1, 5); % NMSE for each noise variance
for j = 1:100 % averaging over 100 times
    
    i = 1;
    for sigma2 = s2_act
        eps = sqrt(sigma2).*randn(N,1); % e_n ~ N(0,sigma^2) - error term
        
        t(: , i) = Phi * w + eps; % output vector for this noise variance
        
        w_map(: , i) = SBL_prun(t(:, i), Phi, N, M, 1 / sigma2); % sparse parameter
        
        i = i + 1;
    end
    NMSE_CURR = sum((w_map - w).^2)/ sum(w.^2); % for the above loop
    NMSE_AVG = NMSE_AVG + NMSE_CURR; % Running sum for NMSE
end
NMSE_AVG = NMSE_AVG ./ 100; % Divide the running sum by total to get average

fprintf("NMSE Average values are given by \n");
disp(NMSE_AVG);
% Normalized mean squares

semilogy(s2_dB, NMSE_AVG, '-o')
title('Average NMSE Plot')
xlabel('Noise variance in (dB)')
ylabel('Average NMSE')


