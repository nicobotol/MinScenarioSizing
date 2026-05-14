% Define the variables for the DG model
% First stage variables and helper for the first stage non-linearity
for i=1:REC.DG.n_NREC
  M(i) = floor(REC.DG.DG_obj{i}.PowMax ./ REC.DG.DG_obj{i}.PowRated);
end

% x = [n_DG]
if REC.DG.n_NREC > 1
  error('More than one DG is not implemented yet')
end

x_DG        = optimvar('x_DG', [REC.DG.n_NREC, 1], 'lowerBound', zeros(1, REC.DG.n_NREC), 'UpperBound',  max(M), 'Type', 'integer'); % integer variable indicating how many generators of a  givnen size are installed
z_help_DG   = optimvar('z_help_DG', [T, W, REC.DG.n_NREC], 'LowerBound', 0, 'UpperBound', max(M), 'Type', 'continuous'); % helper variable for removing the nonlinearity

% % Second stage variables and helper for the second stage piecewise linear approximation
% int_points  = size(REC.DG.DG_obj{1}.PwrCostX, 1); % number of point for the interpolation cost function
% alpha_pla   = optimvar('alpha_pla', [T, W, int_points], 'LowerBound', 0, 'UpperBound', 1, 'Type', 'continuous'); % alpha for piecewise linear approximation
% h_pla       = optimvar('h_pla', [T, W, int_points+1], 'LowerBound', 0, 'UpperBound', 1, 'Type', 'integer'); % h for piecewise linear approximation
% y_help_DG   = optimvar('y_help_DG', [T, W, 1], 'Type', 'continuous', 'LowerBound', 0, 'UpperBound', 1); % helper variable for the piecewise linear approximation

% DG variables
P_DG  = optimvar('P_DG', [T, W, REC.DG.n_NREC], 'LowerBound', 0, 'Type', 'continuous', 'UpperBound', REC.DG.DG_obj{1}.PowMax); % power output of the DG
u_DG  = optimvar('u_DG', [T, W, REC.DG.n_NREC], 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1); % ON/OFF status of the DG


switch case_constraint
  case {'DG-PV-WT', 'DG30-PV-WT'}
    x0.x_DG = 3;
    x0.u_DG = ones([T, W, REC.DG.n_NREC]);
    x0.P_DG = 0.7*ones(T, W);
    x0.z_help = zeros([T, W, REC.DG.n_NREC]);
      
  case {'DG-PV-WT-HS'}
    x0.x_DG = ones([REC.DG.n_NREC, 1]);
    x0.u_DG = zeros([T, W, REC.DG.n_NREC]);
    x0.P_DG = zeros([T, W, REC.DG.n_NREC]);
    x0.z_help = zeros([T, W, REC.DG.n_NREC]);

  otherwise
    x0.x_DG = ones([REC.DG.n_NREC, 1]);
    x0.u_DG = zeros([T, W, REC.DG.n_NREC]);
    x0.P_DG = zeros([T, W, REC.DG.n_NREC]);
    x0.z_help = zeros([T, W, REC.DG.n_NREC]);

end
 