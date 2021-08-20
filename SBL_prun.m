function [W_map] = SBL_prun(t, Phi, N, M, BETA)
    %% Initializations
    MAX	= 1e9; % Maximum value for alpha to avoid large spikes
    % Initialize alpha and mu
    alpha = 100 * ones(M, 1);
    mu = ones(M, 1);
    tol = 1; % tolerance for loop breaking
    iteration = 0; % iteration number
    %% Main loop [Algorithm]
    while tol > 1e-3
        relevant	= (alpha < MAX); % Relavant Alpha's
        alpha_here	= alpha(relevant); % Use only Relevant alpha's for computation
        mu(~relevant)	= 0; % Put 'Non relevant' mu = 0
        Phi_here	= Phi(:,relevant); % Only relevant basis functions to be used
        
        % update mean (mu) and  covariance (S) for the weight posterior
        mu_old = mu;
        S = inv((Phi_here' * Phi_here)*BETA + diag(alpha_here));
        mu(relevant) = BETA .* S * Phi_here.' * t;
        
        % compute all gamma's and calculate new values for alpha
        
        gamma = 1 - alpha_here .* diag(S);
        alpha(relevant) = gamma ./ mu(relevant).^2; % updating new value for alpha
        
        % update tolerance for loop breaking
        
        tol = sum((mu - mu_old).^2)/sum(mu_old.^2);
        iteration = iteration + 1;
    end
    
    W_map = mu; % mean of posterior is required MAP estimate
end