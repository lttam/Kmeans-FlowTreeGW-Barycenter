function [X, a_hat] = SortedOT_1D_Barycenter_FreeSupport(kk, YY_cell, bb_cell, maxIter, tol, theta, optFS)

% OUTPUT
% Barycenter (X, a_hat)
% X: sorted 1D_support (non-negative)

% INPUT
% kk: maximum number of supports in barycenter
% input measures (YY_cell, bb_cell)
% maxIter, tol, theta: parameter of ALGORITHM 2

% initilization
% sorted 1D-support
X = rand(kk, 1);
X = sort(X);

a_hat = ones(kk, 1);
a_hat = a_hat/kk;

iIter = 1;

% % % for inner (fixed supports)
% % maxIter_a = 500;
% % tol_a = 1e-6;
% % step_size_a = 0.05;
% % mb_size_a = min(50, length(YY_cell));

% for inner (fixed supports)
maxIter_a = optFS.maxIter;
tol_a = optFS.tol;
step_size_a = optFS.step_size;
mb_size_a = optFS.mb_size;

while iIter <= maxIter
 
    % optimize supports (Newton)
    tran_YT = zeros(1, kk);
    for ii = 1:length(YY_cell)
        YYII = YY_cell{ii};
        [~, ~, grad_T] = SortedOT_1D_L2S_Full(X, YYII, a_hat, bb_cell{ii});
        tran_YT = tran_YT + (YYII'*grad_T'); 
    end
    tran_YT = tran_YT / length(YY_cell);
    inv_a_hat = 1 ./ a_hat;
    X_tilde = (tran_YT*diag(inv_a_hat))';
    X_new = (1-theta)*X + theta*X_tilde;
    
    if (norm(X_new - X, Inf) < tol) && (iIter > 1)
        break;
    end
    
    if isnan(X_new)
        break;
    end
    X = X_new;
    % SORTED new X
    [X, id_sort_X] = sort(X);
    a_hat = a_hat(id_sort_X);
    
    % optimize a_hat
    a_hat_new = SortedOT_1D_Barycenter_FixedSupport(X, YY_cell, bb_cell, maxIter_a, tol_a, step_size_a, mb_size_a, a_hat);
    
    % stopping condition
    if (norm(a_hat_new - a_hat, Inf) < tol) && (iIter > 1)
        break;
    end
    
    if isnan(a_hat_new)
        break;
    end
    a_hat = a_hat_new;
    
    iIter = iIter + 1;
end


end


