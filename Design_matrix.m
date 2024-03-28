function [A] = Design_matrix(p, xnodes, lon)
    num_obser = length(lon);
    A = zeros(num_obser, p);
    dx = xnodes(2) - xnodes(1);
    
    for i = 1:num_obser
        j = 1;
        for n = 1:length(xnodes)
            x_dash = coordinateTransform(lon,i, xnodes, n - 2, dx);   
            A(i, j) = cubicSplines(x_dash);
            j = j + 1;
        end
    end
end
