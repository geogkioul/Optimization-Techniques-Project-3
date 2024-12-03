function [xmin, history] = steepest_descent(f, grad_f, x0, max_iter, tolerance, mode, step)
    % Steepest descent method with different modes for step size selection
    %
    % Inputs:
    %   f          - Function handle of the objective function.
    %   grad_f     - Function handle for the gradient of f, given for
    %   simplicity
    %   x0         - Initial point (vector).
    %   max_iter   - Maximum number of iterations allowed
    %   tolerance  - Tolerance for stopping criteria (norm of gradient).
    %   mode       - 'fixed', 'linesearch' or 'armijo' depending on the
    %   way we select the step size
    %   step       - The size of step in 'fixed' mode

    % Outputs:
    %   x          - Approximate solution.
    %   history    - History of points visited during optimization.
    
    % Initialization
    xmin = x0;                % Starting point
    history = x0';         % Store points for plotting
    
    % Start iteration
    for iter = 1:max_iter
        grad = grad_f(xmin);       % Compute the gradient
        grad_norm = norm(grad); % Norm of the gradient
        
        % Check stopping criteria
        if grad_norm < tolerance
            break;
        end
        
        % Determine descent direction (negative gradient)
        d = -grad;
        
        % Find out the step selection mode
        switch mode
            case 'fixed'
                gamma = step;
            case 'linesearch'
                phi = @(gamma) f(xmin + gamma * d); % Line search objective function
                % Perform line search using golden section method
                [a_vals, b_vals,~] = golden_section(phi, 0, 5, 1e-4); % Search the minimum gamma in the -grad direction
                gamma = (a_vals(end) + b_vals(end))/2; % Take the middle point of the interval boundaries returned, as an approx of the min
            case 'armijo'
                % Armijo parameters
                beta = 0.5;     % Reduction factor (0 < beta < 1)
                alpha = 1e-4;   % Sufficient decrease parameter (0 < sigma < 1)
                gamma = 1;      % Initialize step size
                % Armijo condition: f(x + gamma * p) <= f(x) + gamma * alpha * g' * p
                while f(xmin + gamma * d) > f(xmin) + gamma * alpha * (d' * grad)
                    gamma = beta * gamma; % Reduce step
                end
            otherwise
                error('Invalid mode. Choose ''fixed'', ''linesearch'', or ''armijo''.');
        end
        
        % Update the solution
        xmin = xmin + gamma * d;
        
        % Store the new point in history
        history = [history; xmin'];        
    end
end