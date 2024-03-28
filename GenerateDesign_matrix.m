function [A] = GenerateDesign_matrix(p, q, xnodes, ynodes, dx, dy, lat, lon)
    num_obser = length(lon);
    A = zeros(num_obser, p*q);
    
    for i = 1:num_obser
        j = 1;
        for n = 1:length(xnodes)
            x_dash = coordinateTransform(lon,i, xnodes, n-2, dx);
            Ax = cubicSplines(x_dash);
            for m = 1:length(ynodes)
                y_dash = coordinateTransform(lat,i, ynodes, m-2, dy);
                Ay = cubicSplines(y_dash);
                A(i, j) = Ax * Ay;
                j = j + 1;
            end
        end
    end
end
