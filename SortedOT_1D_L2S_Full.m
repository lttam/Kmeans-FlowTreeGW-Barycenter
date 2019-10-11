function [dd, grad_a, grad_T] = SortedOT_1D_L2S_Full(X, Y, a, b)

% For X, Y: already sorted!!!

% for 1D-OT
% compute distance (dd), gradient w.r.t weight (grad_a), and gradient
% w.r.t. distance matrix (M_{XY})
% where M_{XY}_ij = |X_i - Y_j|_2^2

% X, Y: column vector in R^n_+, R^m_+ respectively
% a, b: column vector in the simplex S_{n-1}, S_{m-1} respectively

constEPS = 1e-100;

dd = 0;
grad_a = zeros(length(a), 1);
grad_T = zeros(length(a), length(b));

id_a = 1;
id_b = 1;

while ( (id_a <= length(a)) && (id_b <= length(b)) )

    val = (X(id_a) - Y(id_b))^2;
    
    % grad w.r.t a
    grad_a(id_a) = grad_a(id_a) + val;
    
    if a(id_a) <= b(id_b)
        
        % grad w.r.t. T
        grad_T(id_a, id_b) = grad_T(id_a, id_b) + a(id_a);
        
        dd = dd + a(id_a)*val;
        b(id_b) = b(id_b) - a(id_a);
        % update
        id_a = id_a + 1;
        if b(id_b) <= constEPS
            id_b = id_b + 1;
        end
        
    else % b(id_b) < a(id_a)
    
        % grad w.r.t. T
        grad_T(id_a, id_b) = grad_T(id_a, id_b) + b(id_b); 
        
        dd = dd + b(id_b)*val;
        a(id_a) = a(id_a) - b(id_b);
        % update
        id_b = id_b + 1;
        if a(id_a) <= constEPS
            id_a = id_a + 1;
        end
    
    end
    
end






