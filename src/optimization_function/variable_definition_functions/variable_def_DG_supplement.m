% Define the variables for the supplementary DG model
% First stage variables and helper for the first stage non-linearity
for i=1:REC.DGs.n_NREC
  M(i) = floor(REC.DGs.DG_obj{i}.PowMax ./ REC.DGs.DG_obj{i}.PowRated);
end

% x = [n_DGs]
if REC.DGs.n_NREC > 1
  error('More than one DGs is not implemented yet')
end

x_DGs        = optimvar('x_DGs', [REC.DGs.n_NREC, 1], 'lowerBound', zeros(1, REC.DGs.n_NREC), 'UpperBound',  max(M), 'Type', 'integer'); % integer variable indicating how many generators of a  givnen size are installed
z_help_DGs   = optimvar('z_help_DGs', [T, W, REC.DGs.n_NREC], 'LowerBound', 0, 'UpperBound', max(M), 'Type', 'continuous'); % helper variable for removing the nonlinearity

% % Second stage variables and helper for the second stage piecewise linear approximation
% int_points  = size(REC.DGs.DG_obj{1}.PwrCostX, 1); % number of point for the interpolation cost function
% alpha_pla   = optimvar('alpha_pla', [T, W, int_points], 'LowerBound', 0, 'UpperBound', 1, 'Type', 'continuous'); % alpha for piecewise linear approximation
% h_pla       = optimvar('h_pla', [T, W, int_points+1], 'LowerBound', 0, 'UpperBound', 1, 'Type', 'integer'); % h for piecewise linear approximation
% y_help_DGs   = optimvar('y_help_DGs', [T, W, 1], 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', 1); % helper variable for the piecewise linear approximation

% DGs variables
P_DGs  = optimvar('P_DGs', [T, W, REC.DGs.n_NREC], 'LowerBound', 0, 'Type', 'continuous', 'UpperBound', REC.DGs.DG_obj{1}.PowMax); % power output of the DGs
u_DGs  = optimvar('u_DGs', [T, W, REC.DGs.n_NREC], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % ON/OFF status of the DGs