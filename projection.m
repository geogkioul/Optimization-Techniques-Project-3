function [xproj] = projection(xobj, x_constraints, y_constraints)
    % A function that calculates the projection of a vector in a closed
    % convex set
    
    %
    % Inputs:
    %   xobj               - The vector x that will be objected to projection to
    %   the set 
    %   x_constraints      - The x constraints of the set
    %   y_constraints      - The y constraints of the set 

    % Outputs:
    %   xproj              - The projection of xobj to the set
    
    % For X
    if(xobj(1) <= x_constraints(1))
        x = x_constraints(1);
    elseif(xobj(1) >= x_constraints(2))
        x = x_constraints(2);
    else
        x = xobj(1);
    end
    % For Y
    if(xobj(2) <= y_constraints(1))
        y = y_constraints(1);
    elseif(xobj(2) >= y_constraints(2))
        y = y_constraints(2);
    else
        y = xobj(2);
    end

    xproj = [x; y];
end