function x_dash = coordinateTransform(x,i, node, j, spacing)
    x_dash = (x(i) - node(j+2)) / spacing;
end
