% Define the variables related to the battery energy storage system (BESS) model
if ~isempty(BAT)
  % Maximum BESS physical power and energy
  if strcmp(case_constraint, 'REC-U') 
    % case of unconstrained REC and BESS
    max_phy_Pbt = Inf;
    max_phy_Ebt = Inf;
  
  else 
    % case of constrained REC and BESS
    max_phy_Pbt = BAT.Pch_max;
    max_phy_Ebt = BAT.E_max;
  end
  
  % x_ESS = [num_ESS]
  x_ESS_E  = optimvar('x_ESS_E', [num_BESS,1], 'lowerBound', zeros(num_BESS, 1), 'UpperBound', max_phy_Ebt/BAT.C_storage_u, 'Type', 'integer');
        
  % x_ESS_P = [Pbt_max]
  x_ESS_P = optimvar('x_ESS_P', [num_BESS,1], 'lowerBound', [0], 'UpperBound', max_phy_Pbt/BAT.C_power_u, 'Type', 'continuous');
  
  % Initial state of charge of the battery
  E0      = optimvar('E0', 1, 'lowerBound', [0], 'UpperBound', max_phy_Ebt, 'Type', 'continuous');
  
  % Battery energy 
  Ebt     = optimvar('Ebt', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Ebt, 'Type', 'continuous');
  
  % Battery charging and discharging power
  Pch     = optimvar('Pch', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');
  Pdc     = optimvar('Pdc', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');
  
  % Battery charging and discharging indicators
  Uch     = optimvar('Uch', [T, W], 'lowerBound', [0],'upperBound', [1], 'Type', 'integer');
  Udc     = optimvar('Udc', [T, W], 'lowerBound', [0],'upperBound', [1], 'Type', 'integer');
  
  % Battery charging and discharging nonlinear variable
  PchUch  = optimvar('PchUch', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');
  PdcUdc  = optimvar('PdcUdc', [T, W], 'lowerBound', [0], 'UpperBound', max_phy_Pbt, 'Type', 'continuous');
  
  % battery SOC soft constraint 
  epsilon_bat = optimvar('epsilon_bat', 1, 'LowerBound', [0], 'UpperBound', max_phy_Ebt, 'Type', 'continuous'); 
  
  % Define the initial condition for the solver
  switch case_constraint
    case {'DG-PV-WT'}
      x0.x_ESS_E     = 5;
      x0.x_ESS_P    = 10;
      x0.E0           = 0.5*BAT.C_storage_u*x0.x_ESS_E;
      x0.Ebt          = x0.E0*ones([T, W]);
      x0.Pch          = zeros([T, W]);
      x0.Pdc          = zeros([T, W]);
      x0.Uch          = zeros([T, W]);
      x0.Udc          = zeros([T, W]);
      x0.PchUch       = zeros([T, W]);
      x0.PdcUdc       = zeros([T, W]);
  
      
    case {'DG30-PV-WT'}
      x0.x_ESS_E     = 7;
      x0.x_ESS_P    = 3;
      x0.E0           = 2.3;
      x0.Ebt          = x0.E0*ones([T, W]);
      x0.Pch          = zeros([T, W]);
      x0.Pdc          = zeros([T, W]);
      x0.Uch          = zeros([T, W]);
      x0.Udc          = zeros([T, W]);
      x0.PchUch       = zeros([T, W]);
      x0.PdcUdc       = zeros([T, W]);
  
        
    case {'DG-PV-WT-HS'}
      x0.x_ESS_E     = 17;
      x0.x_ESS_P    = 7.7;
      x0.E0           = 3.2;
      x0.Ebt          = x0.E0*ones([T, W]);
      x0.Pch          = zeros([T, W]);
      x0.Pdc          = zeros([T, W]);
      x0.Uch          = zeros([T, W]);
      x0.Udc          = zeros([T, W]);
      x0.PchUch       = zeros([T, W]);
      x0.PdcUdc       = zeros([T, W]);
  
  
    otherwise
      x0.x_ESS_E     = ones([num_BESS,1]);
      x0.x_ESS_P    = ones([num_BESS,1]);
      x0.E0           = 0.5*x0.x_ESS_E;
      x0.Ebt          = x0.E0*ones([T, W]);
      x0.Pch          = zeros([T, W]);
      x0.Pdc          = zeros([T, W]);
      x0.Uch          = zeros([T, W]);
      x0.Udc          = zeros([T, W]);
      x0.PchUch       = zeros([T, W]);
      x0.PdcUdc       = zeros([T, W]);
  
  
  end
end