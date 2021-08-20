function [W_map] = SBL_ogl(t, Phi, N, M, BETA)
    %% Initializations
    % Initialize alpha and mu
    alpha = 100 .* ones(M, 1);
    mu = ones(M, 1);
    tol = 1; % tolerance for loop breaking
    iteration = 0; % iteration number
    %% Main loop [Algorithm]
    while tol > 1e-3
        % update mean (mu) and  covariance (S) for the weight posterior
        
        S = inv((Phi' * Phi)*BETA + diag(alpha));
        mu_old = mu;
        mu = BETA .* S * Phi.' * t;
        % compute all gamma's and calculate new values for alpha
        
        gamma = 1 - alpha .* diag(S);
        alpha = gamma ./ mu.^2; % updating new value for alpha

        % update tolerance for loop breaking using normalised difference of weight norm
        tol = sum((mu - mu_old).^2)/sum(mu_old.^2);
        iteration = iteration + 1;
    end
    
    W_map = mu; % mean of posterior is required MAP estimate
end