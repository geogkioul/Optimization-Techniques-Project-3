%% THIS SECTION SHOULD RUN FIRST BEFORE ANY OTHER FUNCTION OR SECTION
% Clear the workspace and command window
clear; clc;

% Define the objective function and its derivatives symbolically
syms x y;

% Objective function
f_sym=1/3*x^2 + 3*y^2;

% Gradient of objective
grad_sym=gradient(f_sym);

% Convert the symbolic expressions to function handles to they can be
% passed to methods as arguments
f=matlabFunction(f_sym,'Vars',{[x;y]});
grad_f=matlabFunction(grad_sym,'Vars',{[x;y]});

% Maximum iterations limit for following methods
max_iter = 100;

%% Graph the function to get an intuition of its image
grapher(f,40,40,100, 'surf');



%% Task 1: Run steepest descent for different step sizes, random starting point

% Define a starting point
x0 = [-1;1];

% Define tolerance parameter
tolerance = 1e-3;

% The step sizes we will use
step_sizes = [0.1, 0.3, 3, 5];

for i=1:length(step_sizes)
    step = step_sizes(i);
    [xmin, history] = steepest_descent(grad_f, x0, max_iter, tolerance, step);

    % F values at each iteration
    f_evals = arrayfun(@(i) f(history(i, :)'), 1:size(history, 1));

    figure;
    hold on;
    plot(1:length(f_evals), f_evals,'-x', 'LineWidth', 1,'MarkerSize',5,'Color','r', 'DisplayName','Function values at each iteration');
    plot(length(f_evals), f_evals(end), 'Marker', 'diamond', 'LineWidth', 1.5, 'MarkerSize', 5, 'Color', 'b',  'DisplayName', 'Function value at point of termination');
    xlabel('Iteration');
    ylabel('Function Value - Logarithmic Scale');
    if(step > 1/3)
        yscale('log');
    end;
    title('Function Values at Each Iteration - Steepest Descent');
    subtitle("Step size: " + step + newline + 'Starting point: (' + x0(1) + ', ' + x0(2) + ')');
    legend show; 
    grid on;

    % Now do the contour plots
    grapher(f,10,10,100,'contour');
    hold on;
    legend show;
    title('Trajectory of optimization point to termination during Steepest Descent');
    subtitle("Step size: " + step + newline + 'Number of iterations until termination: ' + size(history,1) + newline + 'Point of termination: ('+ xmin(1) + ', ' + xmin(2) + ')' + newline + 'Value of f at point of termination: ' + f(xmin));
    % Extract the coordinates of the points during descent
    history_x = history(:, 1);
    history_y = history(:, 2);
    history_z = arrayfun(@(i) f([history_x(i); history_y(i)]), 1:size(history,1));

    % History_z is row vector, transpose it to make it a column vector
    history_z = history_z';

    % Plot the descent trajectory
    plot3(history_x, history_y, history_z, '-x', 'LineWidth',1,'MarkerSize',8,'Color','r', 'DisplayName','Trajectory of optimization');

    % Mark especially the initial and the final point of termination
    plot3(history_x(1),history_y(1),history_z(1), 'Marker', 'diamond', 'MarkerSize', 10, 'LineWidth', 2, 'Color','g','DisplayName','Initial Point');
    plot3(history_x(end),history_y(end),history_z(end), 'Marker', 'diamond', 'MarkerSize', 10, 'LineWidth', 2, 'Color','b','DisplayName','Point of termination');
end

%% This section should be run prior to Tasks 2-4
% Now consider the constraints -10 <= x <= 5 and -8 <= y <=12
x_constraints = [-10, 5];
y_constraints = [-8, 12];

% We will use the Steepest Descent with Projection method
tolerance = 1e-2;

%% Task 2: Initial point (5,-5) s=5, g=0.5
x0 = [5;-5];
step=5;
gamma=0.5;

[xmin, history] = steepest_descent_proj(grad_f, x0, max_iter, tolerance, step, gamma, x_constraints, y_constraints);

% F values at each iteration
f_evals = arrayfun(@(i) f(history(i, :)'), 1:size(history, 1));

figure;
hold on;
plot(1:length(f_evals), f_evals,'-x', 'LineWidth', 1,'MarkerSize',3,'Color','r', 'DisplayName','Function values at each iteration');
plot(length(f_evals), f_evals(end), 'Marker', 'diamond', 'LineWidth', 1.5, 'MarkerSize', 5, 'Color', 'b',  'DisplayName', 'Function value at point of termination');
xlabel('Iteration');
ylabel('Function Value');
xlim([0,length(f_evals)+1]);
title('Function Values at Each Iteration - Steepest Descent with Projection');
subtitle("Starting point: (" + x0(1) + ", " + x0(2) + ")" + ", s=" + step + ", g=" + gamma);
legend show; 
grid on;

% Now do the contour plots
grapher(f,20,20,100,'contour');
hold on;

% Define the rectangle constraint points
points = [-10, -8; -10, 12; 5, 12; 5, -8]; % The rectangle corners

% Close the rectangle by repeating the first point
points = [points; points(1,:)];

% Plot the rectangle
plot(points(:,1), points(:,2), 'b-', 'LineWidth', 2, 'DisplayName', 'Constraint rectangle'); % Constraint rectangle

hold on;
legend show;
title('Trajectory of optimization point to termination during Steepest Descent with Projection');
subtitle("Number of iterations until termination: " + size(history,1) + newline + "Point of termination: ("+ xmin(1) + ", " + xmin(2) + ")" + newline + "Value of f at point of termination: " + f(xmin));
% Extract the coordinates of the points during descent
history_x = history(:, 1);
history_y = history(:, 2);
history_z = arrayfun(@(i) f([history_x(i); history_y(i)]), 1:size(history,1));

% History_z is row vector, transpose it to make it a column vector
history_z = history_z';

% Plot the descent trajectory
plot3(history_x, history_y, history_z, '-x', 'LineWidth',1,'MarkerSize',8,'Color','r', 'DisplayName','Trajectory of optimization');

% Mark especially the initial and the final point of termination
plot3(history_x(1),history_y(1),history_z(1), 'Marker', 'diamond', 'MarkerSize', 10, 'LineWidth', 2, 'Color','g','DisplayName','Initial Point');
plot3(history_x(end),history_y(end),history_z(end), 'Marker', 'diamond', 'MarkerSize', 10, 'LineWidth', 2, 'Color','b','DisplayName','Point of termination');

%% Task 3: Initial point (-5,10) s=15, g=0.1
x0 = [-5;10];
step=15;
gamma=0.1;

[xmin, history] = steepest_descent_proj(grad_f, x0, max_iter, tolerance, step, gamma, x_constraints, y_constraints);

% F values at each iteration
f_evals = arrayfun(@(i) f(history(i, :)'), 1:size(history, 1));

figure;
hold on;
plot(1:length(f_evals), f_evals,'-x', 'LineWidth', 1,'MarkerSize',3,'Color','r', 'DisplayName','Function values at each iteration');
plot(length(f_evals), f_evals(end), 'Marker', 'diamond', 'LineWidth', 1.5, 'MarkerSize', 5, 'Color', 'b',  'DisplayName', 'Function value at point of termination');
xlabel('Iteration');
ylabel('Function Value');
xlim([0,length(f_evals)+1]);
title('Function Values at Each Iteration - Steepest Descent with Projection');
subtitle("Starting point: (" + x0(1) + ", " + x0(2) + ")" + ", s=" + step + ", g=" + gamma);
legend show; 
grid on;

% Now do the contour plots
grapher(f,20,20,100,'contour');
hold on;

% Define the rectangle constraint points
points = [-10, -8; -10, 12; 5, 12; 5, -8]; % The rectangle corners

% Close the rectangle by repeating the first point
points = [points; points(1,:)];

% Plot the rectangle
plot(points(:,1), points(:,2), 'b-', 'LineWidth', 2, 'DisplayName', 'Constraint rectangle'); % Constraint rectangle

hold on;
legend show;
title('Trajectory of optimization point to termination during Steepest Descent with Projection');
subtitle("Number of iterations until termination: " + size(history,1) + newline + "Point of termination: ("+ xmin(1) + ", " + xmin(2) + ")" + newline + "Value of f at point of termination: " + f(xmin));
% Extract the coordinates of the points during descent
history_x = history(:, 1);
history_y = history(:, 2);
history_z = arrayfun(@(i) f([history_x(i); history_y(i)]), 1:size(history,1));

% History_z is row vector, transpose it to make it a column vector
history_z = history_z';

% Plot the descent trajectory
plot3(history_x, history_y, history_z, '-x', 'LineWidth',1,'MarkerSize',8,'Color','r', 'DisplayName','Trajectory of optimization');

% Mark especially the initial and the final point of termination
plot3(history_x(1),history_y(1),history_z(1), 'Marker', 'diamond', 'MarkerSize', 10, 'LineWidth', 2, 'Color','g','DisplayName','Initial Point');
plot3(history_x(end),history_y(end),history_z(end), 'Marker', 'diamond', 'MarkerSize', 10, 'LineWidth', 2, 'Color','b','DisplayName','Point of termination');

%% Task 4: Initial point (8,-10) s=0.1, g=0.2
x0 = [8;-10];
step=0.1;
gamma=0.2;
max_iter=300;

[xmin, history] = steepest_descent_proj(grad_f, x0, max_iter, tolerance, step, gamma, x_constraints, y_constraints);

% F values at each iteration
f_evals = arrayfun(@(i) f(history(i, :)'), 1:size(history, 1));

figure;
hold on;
plot(1:length(f_evals), f_evals,'-x', 'LineWidth', 1,'MarkerSize',3,'Color','r', 'DisplayName','Function values at each iteration');
plot(length(f_evals), f_evals(end), 'Marker', 'diamond', 'LineWidth', 1.5, 'MarkerSize', 5, 'Color', 'b',  'DisplayName', 'Function value at point of termination');
xlabel('Iteration');
ylabel('Function Value');
xlim([0,length(f_evals)+1]);
title('Function Values at Each Iteration - Steepest Descent with Projection');
subtitle("Starting point: (" + x0(1) + ", " + x0(2) + ")" + ", s=" + step + ", g=" + gamma);
legend show; 
grid on;

% Now do the contour plots
grapher(f,20,20,100,'contour');
hold on;

% Define the rectangle constraint points
points = [-10, -8; -10, 12; 5, 12; 5, -8]; % The rectangle corners

% Close the rectangle by repeating the first point
points = [points; points(1,:)];

% Plot the rectangle
plot(points(:,1), points(:,2), 'b-', 'LineWidth', 2, 'DisplayName', 'Constraint rectangle'); % Constraint rectangle

hold on;
legend show;
title('Trajectory of optimization point to termination during Steepest Descent with Projection');
subtitle("Number of iterations until termination: " + size(history,1) + newline + "Point of termination: ("+ xmin(1) + ", " + xmin(2) + ")" + newline + "Value of f at point of termination: " + f(xmin));
% Extract the coordinates of the points during descent
history_x = history(:, 1);
history_y = history(:, 2);
history_z = arrayfun(@(i) f([history_x(i); history_y(i)]), 1:size(history,1));

% History_z is row vector, transpose it to make it a column vector
history_z = history_z';

% Plot the descent trajectory
plot3(history_x, history_y, history_z, '-x', 'LineWidth',1,'MarkerSize',8,'Color','r', 'DisplayName','Trajectory of optimization');

% Mark especially the initial and the final point of termination
plot3(history_x(1),history_y(1),history_z(1), 'Marker', 'diamond', 'MarkerSize', 10, 'LineWidth', 2, 'Color','g','DisplayName','Initial Point');
plot3(history_x(end),history_y(end),history_z(end), 'Marker', 'diamond', 'MarkerSize', 10, 'LineWidth', 2, 'Color','b','DisplayName','Point of termination');
