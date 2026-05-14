% Define the variables related to the battery energy storage system (BESS) model


%   _ _   _   _  ___ _____   _   _ ____  _____ ____    _ _ 
%  | | | | \ | |/ _ \_   _| | | | / ___|| ____|  _ \  | | |
%  | | | |  \| | | | || |   | | | \___ \|  _| | | | | | | |
%  |_|_| | |\  | |_| || |   | |_| |___) | |___| |_| | |_|_|
%  (_|_) |_| \_|\___/ |_|    \___/|____/|_____|____/  (_|_)
                                                         


switch case_constraint
  case {'DG-PV-WT', 'PV-WT-HY-HS', 'DG-PV-WT-HS'}
    % x_ESS = [num_ESS]
    x_ESS_E  = optimvar('x_ESS_E', [num_BESS,1], 'lowerBound', zeros(num_BESS, 1), 'Type', 'integer');
          
    % x_ESS_P = [Pbt_max]
    x_ESS_P = optimvar('x_ESS_P', [num_BESS,1], 'lowerBound', [0], 'Type', 'integer');

  case {'DG30-PV-WT'}
    % x_ESS = [num_ESS]
    x_ESS_E  = floor(BAT.E_max/BAT.C_storage_u); 
          
    % x_ESS_P = [Pbt_max]
    x_ESS_P = BAT.Pch_max; 
  otherwise
    error('Case not implemented yet')
end

% Initial state of charge of the battery
E0 = optimvar('E0', 1, 'lowerBound', [0], 'Type', 'continuous');

% Battery energy 
Ebt = optimvar('Ebt', [T, W], 'lowerBound', [0], 'Type', 'continuous');

% Battery charging/discharging power
Pbt = optimvar('Pbt', [T, W], 'Type', 'continuous');

% battery SOC soft constraint 
% epsilon_bat = optimvar('epsilon_bat', 1, 'Type', 'continuous', 'LowerBound', 0); 
epsilon_bat = 0;


% Define the initial condition for the solver
x0.x_ESS_E = 1e6*ones([num_BESS,1]);
x0.x_ESS_P = 1e6*ones([num_BESS,1]);
x0.E0 = 0.5*x0.x_ESS_E;
x0.Ebt = x0.E0*ones([T, W]);
x0.Pbt = zeros([T, W]);
x0.epsilon_bat = 0;
x0.delta_ESS_Pmax = zeros([T, W, num_BESS]);