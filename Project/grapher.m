function grapher(f, x_vals, y_vals, resolution, mode)
% A script that will take as input a 3d function and graph it
% 
% Inputs:
% f             - Function handle for the function to graph
% x_vals        - The x values for which the function will be graphed
% (-x_vals, x_vals)
% y_vals        - The y values for which the function will be graphed
% (-y_vals, y_vals)
% resolution    - The number of points the in each dimension
% mode          - 'surf', 'mesh', 'contour': The kind of graph the method will produce

% Create a grid of x, y values
x = linspace(-x_vals, x_vals, resolution);
y = linspace(-y_vals, y_vals, resolution);
[X, Y] = meshgrid(x, y);

% Evaluate the function at the grid points
Z = arrayfun(@(x, y) f([x; y]), X, Y);

% Plot the function

figure; % Create a figure
switch mode % Decide the kind of the plot depending on mode
    case 'surf'
        surf(X, Y, Z, DisplayName='Surface of function');
        title('3D Surface Plot of f');
    case 'mesh'
        mesh(X, Y, Z, DisplayName='Mesh Grid of function');
        title('3D Mesh Plot of f');
    case 'contour'
        contour(X, Y, Z, 40, DisplayName='Contour Lines of function');
        colorbar;
        colormap jet;
        title('2D Contour Plot of f');
    otherwise
        error('Invalid mode. Choose ''surf'', ''mesh'', or ''contour''.');
end

xlabel('x');
ylabel('y');
zlabel('f(x, y)');
