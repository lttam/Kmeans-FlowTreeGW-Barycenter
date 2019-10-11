function [dd, grad_a, grad_T] = OT_1D_L2S_Full(X, Y, a, b)

% for 1D-OT
% compute distance (dd), gradient w.r.t weight (grad_a), and gradient
% w.r.t. distance matrix (M_{XY})
% where M_{XY}_ij = |X_i - Y_j|_2^2

% X, Y: column vector in R^n_+, R^m_+ respectively
% a, b: column vector in the simplex S_{n-1}, S_{m-1} respectively

constEPS = 1e-50;

[sort_X, id_X] = sort(X);
[sort_Y, id_Y] = sort(Y);

sort_a = a(id_X);
sort_b = b(id_Y);

dd = 0;
grad_a = zeros(length(a), 1);
grad_T = zeros(length(a), length(b));

id_a = 1;
id_b = 1;

while ((id_a <= length(a)) && (id_b <= length(b)))

    val = (sort_X(id_a) - sort_Y(id_b))^2;
    
    % grad w.r.t a
    grad_a(id_X(id_a)) = grad_a(id_X(id_a)) + val;
    
    if sort_a(id_a) <= sort_b(id_b)
        
        % grad w.r.t. T
        grad_T(id_X(id_a), id_Y(id_b)) = grad_T(id_X(id_a), id_Y(id_b)) + sort_a(id_a);
        
        dd = dd + sort_a(id_a)*val;
        id_a = id_a + 1;
        sort_b(id_b) = sort_b(id_b) - sort_a(id_a);
        if sort_b(id_b) <= constEPS
            id_b = id_b + 1;
        end
        
    else % sort_b(id_b) < sort_a(id_a)
    
        % grad w.r.t. T
        grad_T(id_X(id_a), id_Y(id_b)) = grad_T(id_X(id_a), id_Y(id_b)) + sort_b(id_b); 
        
        dd = dd + sort_b(id_b)*val;
        id_b = id_b + 1;
        sort_a(id_a) = sort_a(id_a) - sort_b(id_b);
        if sort_a(id_a) <= constEPS
            id_a = id_a + 1;
        end
    
    end
    
end






