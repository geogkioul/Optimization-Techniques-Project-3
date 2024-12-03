function [xmin, history] = steepest_descent_proj(grad_f, x0, max_iter, tolerance, step, gamma, x_constraints, y_constraints)
    % Steepest descent method with projection
    % the vector is constrained between the x,y constraints
    
    %
    % Inputs:
    %   grad_f     - Function handle for the gradient of f, given for
    %   simplicity
    %   x0         - Initial point (vector).
    %   max_iter   - Maximum number of iterations allowed
    %   tolerance  - Tolerance for stopping criteria (norm of gradient).
    %   step       - The size of step in 'fixed' mode

    % Outputs:
    %   xmin       - Approximate solution.
    %   history    - History of points visited during optimization.
    
    % Initialization
    xmin = x0;
    history = x0';

    % Start iteration
    for iter = 1:max_iter
        grad = grad_f(xmin); % Compute the gradient
        xobj = xmin - step * grad; % The vector that will be projected to the set
        xproj = projection(xobj, x_constraints, y_constraints); % Compute the projection
        % Break condition xproj = xobj
        if(xobj == xproj)
            break;
        end
        xmin = xmin + gamma*(xproj-xmin); % Compute the next xk vector
        % Store the new point in history
        history = [history; xmin'];
        
    end
end