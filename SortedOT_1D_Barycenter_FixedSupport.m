function a_hat = SortedOT_1D_Barycenter_FixedSupport(X, YY_cell, bb_cell, maxIter, tol, step_size, mb_size, a_0)

% Optimize with Nesterov accelearation
% using CUTURI's Algorithm (1)

% INPUT:
% X: sorted supports of barycenter
% YY_cell: cell of sorted 1D supports (column vectors)
% bb_cell: cell of corresponding weights (column vectors)

% OPTIONAL:
% maxIter: maximum iterations
% tol: tolerance as a stopping conditions
% step_size: step size of (sub)gradient descent
% mb_size: mini batch size
% a_0: initialization for weights (used for warm-start)

% OUTPUT: 
% optimal (stationary point) weight a_hat for the barycenter

if nargin < 4
    maxIter = 100;
    tol = 1e-6;
    step_size = 0.01;
    mb_size = 50;
    a_0 = ones(length(X), 1)/length(X);
end

a_hat = a_0;
a_tilde = a_0;

N = length(YY_cell);

tt = 1;
while tt <= maxIter
    beta = (tt+1)/2;
    a = ((beta-1)*a_hat + a_tilde)/beta;
    
    % Compute GRAD_a from OT(X, YY_cell{...}, a, bb_cell{...})
    % uniform random
    id_rand = randperm(N);
    grad_a = zeros(length(X), 1);
    for ii = 1:mb_size
        [~, grad_a_ii, ~] = SortedOT_1D_L2S_Full(X, YY_cell{id_rand(ii)}, a, bb_cell{id_rand(ii)});
        grad_a = grad_a + grad_a_ii;
    end
    grad_a = grad_a / mb_size;
    
    % Kullback-Leibler divergence for the probability simplex
    a_tilde = a_tilde .* exp(-step_size*beta*grad_a);
    a_tilde = a_tilde / sum(a_tilde);
    
    a_hat_new = ((beta-1)*a_hat + a_tilde)/beta;
    if norm(a_hat_new - a_hat, Inf) <= tol
        break;
    end
    
    a_hat = a_hat_new;
    tt = tt + 1;
end


end







