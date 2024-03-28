clear all;
clear variables;

%% Load the data
  load('MDT_Altimetrie.mat');
%  load('MDT_Argo.mat');

lon = MDT(:, 1);
lat = MDT(:, 2);
data = MDT(:, 3);

%define lat and long for plot
lat_range=[20,60];
lon_range=[-60,-20];

% Set the number of intervals for the B-splines
p = 12; % Number of intervals in x-direction
q = 9; % Number of intervals in y-direction

% Define the nodes and calculate the spacing
xnodespace = linspace(min(lon), max(lon), p);
ynodespace = linspace(min(lat), max(lat), q);

% Calculate spacing in x and y directions
dx = (max(lon) - min(lon)) / (p - 1);
dy = (max(lat) - min(lat)) / (q - 1);

% Extend the xnodes and ynodes arrays
xnodes = [min(lon) - dx, xnodespace, max(lon) + dx];
ynodes = [min(lat) - dy, ynodespace, max(lat) + dy];


% % Function for coordinate transformation
% coordtrans = @(x, i, nodes, j, spacing) (x(i) - nodes(j + 2)) / spacing;

% Generate the design matrix
A = GenerateDesign_matrix(p, q, xnodes, ynodes, dx, dy, lat, lon);

%% Perform least squares adjustment
N = A' * A;
n = A' * data;
x_cap = pinv(N) * n;
l_cap = A * x_cap;
v_cap = l_cap - data;

%% Visualize the estimated function on a grid
lon_dense = linspace(min(lon), max(lon), 100)';
lat_dense = linspace(min(lat), max(lat), 100)';

% design matrices for the dense grid 
Ax = Design_matrix(p, xnodes, lon_dense);
Ay = Design_matrix(q, ynodes, lat_dense);
A_dense = kron(Ax, Ay);

% adjusted values for the dense grid
l_cap_dense = A_dense * x_cap;
l_cap_dense1 = reshape(l_cap_dense, size(lon_dense, 1), size(lat_dense, 1));
%% Visualize the Residual
figure(1);
ax = axesm('MapProjection', 'mercator');
worldmap(lat_range, lon_range);
geoshow('landareas.shp', 'FaceColor', [0.15 0.5 0.15]);
hold on
% Scatter plot of latitude and longitude
scatterm(lat, lon, 5, v_cap, 'filled');
% Colorbar
cb=colorbar;
cb.Label.String = 'Residuals Values';
% Adjust colorbar properties
set(cb, 'FontName', 'Arial', 'FontSize', 10, 'FontWeight', 'bold');
% Title and labels
title(['Residuals for P=', num2str(p), ' and Q=', num2str(q)]);
xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');
hold off



% Visualize the estimated function on a grid
figure(2);
plot3(lon, lat, data, 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'black');
hold on;
surf(lon_dense, lat_dense, l_cap_dense1);
title('Original observations and estimated surface using cubic B-splines');
xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');
zlabel('Mean Dynamic Topography (meter)');
cb=colorbar;
cb.Label.String = 'Estimated Values';
% Adjust colorbar properties
set(cb, 'FontName', 'Arial', 'FontSize', 10, 'FontWeight', 'bold');
% Add legend
legend('Original Observations', 'Estimated Surface','Location','northeast');
grid on;
box on;
daspect([7 7 1]);




