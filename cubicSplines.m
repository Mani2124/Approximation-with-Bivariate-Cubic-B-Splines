function A = cubicSplines(x)
    A = zeros(size(x));
    indices1 = x >= -2 & x < -1;
    indices2 = x >= -1 & x < 0;
    indices3 = x >= 0 & x < 1;
    indices4 = x >= 1 & x < 2;

    A(indices1) = (1/6) * (x(indices1) + 2).^3;
    A(indices2) = (1/6) * (x(indices2) + 2).^3 - (4/6) * (x(indices2) + 1).^3;
    A(indices3) = (1/6) * (-x(indices3) + 2).^3 - (4/6) * (-x(indices3) + 1).^3;
    A(indices4) = (1/6) * (-x(indices4) + 2).^3;
end
