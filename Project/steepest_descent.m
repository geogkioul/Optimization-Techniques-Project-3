function [xmin, history] = steepest_descent(grad_f, x0, max_iter, tolerance, step)
    % Steepest descent method
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
    xmin = x0;                % Starting point
    history = x0';         % Store points for plotting
    
    % Start iteration
    for iter = 1:max_iter-1
        grad = grad_f(xmin);       % Compute the gradient
        grad_norm = norm(grad); % Norm of the gradient
        
        % Check stopping criteria
        if grad_norm < tolerance
            break;
        end
        
        % Determine descent direction (negative gradient)
        d = -grad;
        
        % Update the solution
        xmin = xmin + step * d;
        
        % Store the new point in history
        history = [history; xmin'];        
    end
end