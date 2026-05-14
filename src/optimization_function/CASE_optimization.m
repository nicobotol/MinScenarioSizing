function [values_solution, values_vector, values_minvalue, CO2_emitted] = CASE_optimization(LscensProbVec_N, REC, ESS, DL, Pload_obj, opt_parameters, scenario, case_constraint, values_solution_1st, loop_type_1)
  % This function solves the optimization assuming that the data of load and renewable energy sources are given in objectives form
  
  % Probability related variables
  cvar_alpha = opt_parameters.alpha;
  cvar_beta = opt_parameters.beta;
  rel_gap_tol = opt_parameters.rel_gap_tol;
  max_time = opt_parameters.max_time;

  % Set variable for check the model feasibility
  model_infeasible = 0;

  % Choice of the BESS model
  BESS_NL_model = opt_parameters.BESS_NL_model;
  
  % Extract the physical parameters from device structure
  PV      = []; % Photovoltaic panel
  WT      = []; % Wind turbine
  WEC     = []; % Wind turbine
  BAT     = []; % Battery
  HSS     = []; % Hydrogen storage system
  DG_obj  = []; % Diesel generator
  DGs_obj  = []; % supplementary Diesel generator
  
  % define the devices used in the different cases
  switch case_constraint
    case 'GT24' % Only GT
      GT_obj  = REC.GT.GT_obj;
      Pload   = Pload_obj.iniVec; % Load data

    case 'GT365' % Only GT w/o days
      GT_obj  = REC.GT.GT_obj;
      Pload   = Pload_obj.iniVec; % Load data

    case '1GT+WT+DG' % 1 GT + WT + BESS
      GT_obj  = REC.GT.GT_obj;
      REC.GT.n_NREC = 1;
      WT      = REC.WT;           % Wind turbine
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data
      DG_obj  = REC.DG.DG_obj;    % Diesel generator
    
    case '2GT+WT+DG' % 2 GT + WT + BESS
      GT_obj  = REC.GT.GT_obj;
      REC.GT.n_NREC    = 2;
      WT      = REC.WT;           % Wind turbine
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data
      DG_obj  = REC.DG.DG_obj;    % Diesel generator

    case '1GT+REC+DG' % 1 GT + WT + PV + WEC + BESS
      GT_obj  = REC.GT.GT_obj;
      REC.GT.n_NREC = 1;
      WT      = REC.WT;           % Wind turbine
      PV      = REC.PV;           % PV
      WEC     = REC.WEC;          % WEC
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data
      DG_obj  = REC.DG.DG_obj;    % Diesel generator
    
    case '2GT+REC+DG' % 2 GT + WT + PV + WEC + BESS
      GT_obj  = REC.GT.GT_obj;
      REC.GT.n_NREC  = 2;
      WT      = REC.WT;           % Wind turbine
      PV      = REC.PV;           % PV
      WEC     = REC.WEC;          % WEC
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data
      DG_obj  = REC.DG.DG_obj;    % Diesel generator
    
    case 'GT+REC+DG' % GT + WT + PV + WEC + BESS
      GT_obj  = REC.GT.GT_obj;
      WT      = REC.WT;           % Wind turbine
      PV      = REC.PV;           % PV
      WEC     = REC.WEC;          % WEC
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data
      DG_obj  = REC.DG.DG_obj;    % Diesel generator

    case 'WT+DG' % only WT + BESS
      WT      = REC.WT;           % Wind turbine
      BAT     = ESS.BAT;          % Battery
      Pload   = Pload_obj.iniVec; % Load data
      DG_obj  = REC.DG.DG_obj;    % Diesel generator

    case {'REC-U'}
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      Pload = Pload_obj.iniVec; % Load data

    case {'REC-U+DG', 'REC-C+DG24'} % REC + BESS
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      Pload = Pload_obj.iniVec; % Load data
      DG_obj  = REC.DG.DG_obj;  % Diesel generator

    case {'REC-C+DG365'}
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      Pload = Pload_obj.iniVec; % Load data
      DG_obj= REC.DG.DG_obj;    % Diesel generator

    case 'DG+REC24' % REC + BESS + DIESEL
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      DG_obj= REC.DG.DG_obj;    % Diesel generator
      Pload = Pload_obj.iniVec; % Load data
   
    case 'DG+REC365' % REC + BESS + DIESEL
      PV    = REC.PV;           % Photovoltaic panel
      WT    = REC.WT;           % Wind turbine
      WEC   = REC.WEC;          % WEC turbine
      BAT   = ESS.BAT;          % Battery
      DG_obj= REC.DG.DG_obj;    % Diesel generator
      Pload = Pload_obj.iniVec; % Load data

    otherwise
      error('Case name not implemented yet\n');
  end

  if isempty(LscensProbVec_N)
    LscensProbVec_N = 1/scenario.W*ones(scenario.W, 1);
  elseif scenario.W == 1
    LscensProbVec_N = 1;
  end

  switch scenario.simulation_type
    case 1

    case {2, 3}
      DGs_obj = REC.DGs.DG_obj;

    otherwise
      error('Case not implemented yet!')
  end

  % Annualization-related variables
  r = opt_parameters.r; % daily interest rate
  L = opt_parameters.L; % investment lifetime
  p = (365*24)*L/scenario.h_star; % recoupling period  
  T = scenario.T;   % number of data in each scenario 
  W = scenario.W;   % number of scenarios (e.g. days)
  AF.CRF    = (r*(1 + r)^p)/((1 + r)^p - 1);  % capital recovery factor (daily value of fixed cost)
  AF.gamma  = scenario.h_star/scenario.h;     % rescale the scenario to cost to daily values
  AF.YtD    = scenario.d_o;                   % rescale from yearly to daily cost

  % Identify how many REC are present
  if ~isempty(PV); num_PV = 1; else; num_PV = 0; end
  if ~isempty(WT); num_WT = 1; else; num_WT = 0; end
  if ~isempty(WEC); num_WEC = 1; else; num_WEC = 0; end
  if ~isempty(BAT); num_BESS = 1; else; num_BESS = 0; end
  if ~isempty(HSS); num_HSS = 1; else; num_HSS = 0; end
  if ~isempty(DL); num_DL = 1; else; num_DL = 0; end
  if ~isempty(DG_obj); num_DG = 1; else; num_DG = 0; end
  num_REC = num_PV + num_WT + num_WEC; % Number of devices

  %  __     __         _       _     _           
  %  \ \   / /_ _ _ __(_) __ _| |__ | | ___  ___ 
  %   \ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
  %    \ V / (_| | |  | | (_| | |_) | |  __/\__ \
  %     \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
  
  Pch   = 0; % charging power of the battery
  Pdc   = 0; % discharging power of the battery
  Pel   = 0; % power of the electrolyzer
  Pfc   = 0; % power of the fuel cell 
  prob  = optimproblem; 
  cvar_zeta = 0; % CVaR constraint
  cvar_s = zeros([W, 1]); % CVaR constraint
  P_REC_max = 0;
  P_GT  = 0;
  Pbt   = 0;
  Pns   = 0;
  P_DG  = 0;
  P_DGs = 0;
  alpha_pla = 0;
  y_help_DG = 0;
  alpha_plas = 0;
  y_help_DGs = 0;

  switch case_constraint
    case {'GT24','GT365'} % Only GT
      variable_def_GT;            
      
    case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'} % 1/2 GT + REC + BESS
      variable_def_GT;
      x_GT = ones(REC.GT.n_NREC, 1); % impose the number of GTs
      variable_def_REC;        
      if BESS_NL_model == 1
        variable_def_BESS_NL_model;
      else
        variable_def_BESS;
      end
      variable_def_DG;

    case {'GT+REC+DG'} % GT + REC + BESS
      variable_def_GT;
      variable_def_REC;        
      if BESS_NL_model == 1
        variable_def_BESS_NL_model;
      else
        variable_def_BESS;
      end
      variable_def_DG;
      
    case {'REC-U'}
      variable_def_REC;
      if BESS_NL_model == 1
        variable_def_BESS_NL_model;
      else
        variable_def_BESS;
      end

    case {'WT+DG', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365'} % REC + BESS
      variable_def_REC;
      if BESS_NL_model == 1
        variable_def_BESS_NL_model;
      else
        variable_def_BESS;
      end
      variable_def_DG;

    case {'DG+REC24', 'DG+REC365'} % REC + BESS + DIESEL
      variable_def_REC;
      variable_def_DG;
      if BESS_NL_model == 1
        variable_def_BESS_NL_model;
      else
        variable_def_BESS;
      end
      
    otherwise
      error('Case name not implemented yet\n');
        
  end
    
  variable_def_DR;
  variable_def_risk_related;
  variable_def_Pns_Pct;

  switch scenario.simulation_type
    case 1

    case 2
      % Overwrite first stage variables to the values obtained before
      x_DG      = gen_var(values_solution_1st, 'x_DG');
      x_GT      = gen_var(values_solution_1st, 'x_GT');
      x_REC     = gen_var(values_solution_1st, 'x_REC');
      x_ESS_E   = gen_var(values_solution_1st, 'x_ESS_E');
      x_ESS_P   = gen_var(values_solution_1st, 'x_ESS_P');
      E0        = gen_var(values_solution_1st, 'E0');

      switch case_constraint
        case {'GT24', 'GT365'}
          x_DG    = [];
          x_REC   = [];
          x_ESS_E = [];
          x_ESS_P = [];
          E0      = [];

        case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'}
          x_GT = ones(REC.GT.n_NREC,1);

        case {'REC-U', 'WT+DG', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365', 'DG+REC24', 'DG+REC365'}
          x_GT = [];

        case {'GT+REC+DG'}

        otherwise
          error('Case not defined yet')
      end

      % variable related to the additional DG to be installed
      variable_def_DG_supplement;

    case 3
      %  Overwrite first stage variables to the values obtained before
      x_DG      = gen_var(values_solution_1st, 'x_DG');
      x_GT      = gen_var(values_solution_1st, 'x_GT');
      % x_REC     = gen_var(values_solution_1st, 'x_REC');

      switch case_constraint
        case {'GT24', 'GT365'}
          x_DG    = [];
          x_REC   = [];
          x_ESS_E = [];
          x_ESS_P = [];
          E0      = [];

        case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG'}
          x_GT = ones(REC.GT.n_NREC,1);

        case {'REC-U', 'WT+DG', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365', 'DG+REC24', 'DG+REC365'}
          x_GT = [];

        case {'GT+REC+DG'}

        otherwise
          error('Case not defined yet')
      end

      % variable related to the additional DG to be installed
      variable_def_DG_supplement;

    otherwise
      error('Case not implemented yet')
  end

  %    ____          _   
  %   / ___|___  ___| |_ 
  %  | |   / _ \/ __| __|
  %  | |__| (_) \__ \ |_ 
  %   \____\___/|___/\__|
  
  cTx_BESS  = 0;
  cTx_GT    = 0;
  cTx_REC   = 0;
  cTx_DG    = 0;
  cTx_DGs   = 0;
  cTx_Pv    = 0;
  qTy_w_GT  = 0;
  qTy_w_BESS= 0;
  qTy_w_DG  = 0;
  qTy_w_DGs = 0;
  qTy_w_DR  = 0;
  qTy_w_Pv  = 0;
  wTz       = 0;
  Pres_vec = zeros(T, W); % vector power of the RECs
  switch case_constraint
    case {'GT24', 'GT365'} % Only GT
      [cTx_GT, qTy_w_GT] = cost_GT(GT_obj, AF, REC.GT.n_NREC, P_GT, u_GT, z_GT, RR, x_GT, T, W, scenario.tau); % cost related to the GTs
      [~, Pload] = reshape_REC_power([], Pload, T, W);
      Pbt = zeros(T,W);
      
    case {'1GT+WT+DG', '2GT+WT+DG'} % 1/2 GT + WT + BESS
      [cTx_GT, qTy_w_GT] = cost_GT(GT_obj, AF, REC.GT.n_NREC, P_GT, u_GT, z_GT, RR, x_GT, T, W, scenario.tau); % cost related to the GTs
      REC_obj = {WT};
      [REC_obj, Pload] = reshape_REC_power(REC_obj, Pload, T, W);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, num_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]  = cost_BESS(BAT, AF, x_ESS_E, x_ESS_P, W);
      [cTx_DG, qTy_w_DG] = cost_DG(DG_obj, case_constraint, AF, REC.DG.n_NREC, P_DG, x_DG, u_DG, alpha_pla, y_help_DG, T, W);

    case {'1GT+REC+DG', '2GT+REC+DG', 'GT+REC+DG'} % 1/2 GT + REC + BESS
      [cTx_GT, qTy_w_GT] = cost_GT(GT_obj, AF, REC.GT.n_NREC, P_GT, u_GT, z_GT, RR, x_GT, T, W, scenario.tau); % cost related to the GTs
      REC_obj = {PV, WT, WEC};
      [REC_obj, Pload] = reshape_REC_power(REC_obj, Pload, T, W);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, num_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]  = cost_BESS(BAT, AF, x_ESS_E, x_ESS_P, W);
      [cTx_DG, qTy_w_DG] = cost_DG(DG_obj, case_constraint, AF, REC.DG.n_NREC, P_DG, x_DG, u_DG, alpha_pla, y_help_DG, T, W);
    
    case 'WT+DG' % only WT + BESS
      REC_obj = {WT};
      [REC_obj, Pload] = reshape_REC_power(REC_obj, Pload, T, W);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, num_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]  = cost_BESS(BAT, AF, x_ESS_E, x_ESS_P, W);
      [cTx_DG, qTy_w_DG] = cost_DG(DG_obj, case_constraint, AF, REC.DG.n_NREC, P_DG, x_DG, u_DG, alpha_pla, y_help_DG, T, W);
      
    case {'REC-U'}
      REC_obj = {PV, WT, WEC};
      [REC_obj, Pload] = reshape_REC_power(REC_obj, Pload, T, W);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, num_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]          = cost_BESS(BAT, AF, x_ESS_E, x_ESS_P, W);

    case {'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365'} % REC + BESS
      REC_obj = {PV, WT, WEC};
      [REC_obj, Pload] = reshape_REC_power(REC_obj, Pload, T, W);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, num_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]          = cost_BESS(BAT, AF, x_ESS_E, x_ESS_P, W);
      [cTx_DG, qTy_w_DG] = cost_DG(DG_obj, case_constraint, AF, REC.DG.n_NREC, P_DG, x_DG, u_DG, alpha_pla, y_help_DG, T, W);
              
    case {'DG+REC24', 'DG+REC365'} % REC + BESS + DIESEL
      REC_obj = {PV, WT, WEC};
      [REC_obj, Pload] = reshape_REC_power(REC_obj, Pload, T, W);
      [cTx_REC, P_REC_max, Pres_vec]  = cost_REC(REC_obj, AF, num_REC, x_REC);
      [cTx_BESS, qTy_w_BESS]  = cost_BESS(BAT, AF, x_ESS_E, x_ESS_P, W);
      [cTx_DG, qTy_w_DG] = cost_DG(DG_obj, case_constraint, AF, REC.DG.n_NREC, P_DG, x_DG, u_DG, alpha_pla, y_help_DG, T, W);

    otherwise
      error('Case name not implemented yet');

  end

  switch scenario.simulation_type 
    case 1
    case {2, 3}
      [cTx_DGs, qTy_w_DGs] = cost_DG(DG_obj, case_constraint, AF, REC.DGs.n_NREC, P_DGs, x_DGs, u_DGs, alpha_plas, y_help_DGs, T, W);
    otherwise
      error('Case not implemented yet')
  end

  cTx   = cTx_GT + cTx_BESS + cTx_REC + cTx_DG + cTx_DGs;          % Total 1st stage cost
  qTy_w = qTy_w_GT + qTy_w_BESS + qTy_w_DG + qTy_w_DR + qTy_w_DGs; % Total 2nd stage cost

  f     = cTx + AF.gamma*qTy_w*LscensProbVec_N;
  if num_BESS > 0
    [wTz] = cost_soft_constraint(BAT, AF, epsilon_bat);
    f     = f + wTz; % add soft constraint in case of presence of the BESS
  end

  cvar  = cvar_zeta + (1/(1 - cvar_alpha))*sum(LscensProbVec_N.*cvar_s)*scenario.tau;
  F     = (1 - cvar_beta)*f + cvar_beta*cvar;
  prob.Objective  = F;
  
  %    ____                _             _       _       
  %   / ___|___  _ __  ___| |_ _ __ __ _(_)_ __ | |_ ___ 
  %  | |   / _ \| '_ \/ __| __| '__/ _` | | '_ \| __/ __|
  %  | |__| (_) | | | \__ \ |_| | | (_| | | | | | |_\__ \
  %   \____\___/|_| |_|___/\__|_|  \__,_|_|_| |_|\__|___/
  
  Pload_PS = load_PS(Pload, Pps_rem, Pps_add);
 
  switch case_constraint
    case {'GT24','GT365'} % Only GT
      P_gen_tot = sum(P_GT, 3);
      prob = GT_constraints(prob, REC.GT.n_NREC, T, W, GT_obj, u_GT, z_GT, x_GT, P_GT, RR, z_help_GT, case_constraint);

    case {'1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG', 'GT+REC+DG'} % GT + REC + BESS
      % GT
      P_gen_tot = P_res + sum(P_GT, 3) + P_DG;
      prob = GT_constraints(prob, REC.GT.n_NREC, T, W, GT_obj, u_GT, z_GT, x_GT, P_GT, RR, z_help_GT, case_constraint); 
      
      % REC
      prob = REC_constraints(prob, P_res, P_REC_max, num_REC, REC_obj, x_REC);
      
      % BESS
      prob = BESS_constraints(prob, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_E, x_ESS_P, epsilon_bat);

      % DG
      prob = GT_P_minmax(prob, 'DG', REC.DG.n_NREC, T, W, P_DG, x_DG, DG_obj, u_DG, z_help_DG); % maxi/min output power of the DG

    case {'WT+DG', 'REC-C+DG24', 'REC-C+DG365'}  % G -> WT + BESS
                            % I -> REC + BESS
      % REC
      P_gen_tot = P_res + P_DG;
      prob = REC_constraints(prob, P_res, P_REC_max, num_REC, REC_obj, x_REC);

      % BESS
      prob = BESS_constraints(prob, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_E, x_ESS_P, epsilon_bat);

      % DG
      prob = GT_P_minmax(prob, 'DG', REC.DG.n_NREC, T, W, P_DG, x_DG, DG_obj, u_DG, z_help_DG); % maxi/min output power of the DG

    case {'REC-U+DG'} % REC + BESS w/o plant size constraints and possibility to use Pv
      % REC
      P_gen_tot = P_res + P_DG;
      prob = max_power(prob, 'REC_max_power', P_res, P_REC_max); % Maximum power produced by the REC
      
      % BESS
      prob = BESS_constraints(prob, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_E, x_ESS_P, epsilon_bat);

      % DG
      prob = GT_P_minmax(prob, 'DG', REC.DG.n_NREC, T, W, P_DG, x_DG, DG_obj, u_DG, z_help_DG); % maxi/min output power of the DG
    
    case {'REC-U'} % REC + BESS w/o plant size constraints
      % REC
      P_gen_tot = P_res;
      prob = max_power(prob, 'REC_max_power', P_res, P_REC_max); % Maximum power produced by the REC
      
      % BESS
      prob = BESS_constraints(prob, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_E, x_ESS_P, epsilon_bat);
      
    case {'DG+REC24', 'DG+REC365'} % REC + BESS + DIESEL
      % Total generated power
      P_gen_tot = P_res + sum(P_DG, 3);
  
      % DG
      prob = GT_P_minmax(prob, 'DG', REC.DG.n_NREC, T, W, P_DG, x_DG, DG_obj, u_DG, z_help_DG); % maxi/min output power of the DG
  
      % REC
      prob = REC_constraints(prob, P_res, P_REC_max, num_REC, REC_obj, x_REC);
  
      % BESS
      prob = BESS_constraints(prob, BESS_NL_model, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_E, x_ESS_P, epsilon_bat);

    otherwise
      error('Case name not implemented yet\n');
      
  end

  % Power balance
  if BESS_NL_model == 1
    P_storage_ch = Pch + Pel; % total power charging the storages
    P_storage_dc = Pdc + Pfc; % total power discharging the storages
    P_gen_tot = P_gen_tot + P_DGs;
    prob = power_balance_NL_model(prob, P_gen_tot, P_storage_ch, P_storage_dc, Pct, Pload_PS);
  else
    prob = power_balance(prob, P_gen_tot, Pbt, Pns, Pct, P_DGv, Pload_PS);
  end

  % Peak shaving power
  prob = load_PS_energy(prob, Pps_add, Pps_rem);
  prob = load_PS_minmax(prob, Pload_PS, Pload_obj);
  prob = load_PS_power_minmax(prob, Pps_add, Pps_rem, Pload_obj);

  % Maximum dumped power 
  prob = max_power(prob, 'Pct_max_power', Pct, DL.Pct_max); 

  % LPSP
  prob = LPSP_target(prob, Pns, Pload_PS, Pload_obj);

  % CVaR
  prob = CVaR_constraint(prob, cvar_zeta, cvar_s, cTx, qTy_w, AF.gamma, wTz);

  switch scenario.simulation_type 
    case 1
    case {2, 3}
      % supplementary DG
      prob = GT_P_minmax(prob, 'DGs', REC.DGs.n_NREC, T, W, P_DGs, x_DGs, DGs_obj, u_DGs, z_help_DGs); % maxi/min output power of the DG
    otherwise
      error('Case not implemented yet')
  end

  %   ____        _       _   _             
  %  / ___|  ___ | |_   _| |_(_) ___  _ __  
  %  \___ \ / _ \| | | | | __| |/ _ \| '_ \ 
  %   ___) | (_) | | |_| | |_| | (_) | | | |
  %  |____/ \___/|_|\__,_|\__|_|\___/|_| |_|

  % compute the number of variable in the model (before presolving it)
  [n_cont, n_int, n_bin] = compute_variable_number(prob);

  fprintf('Start solution\n')
  % opt = optimoptions('intlinprog', 'Display', 'none', 'RelativeGapTolerance', rel_gap_tol, 'MaxTime', 600);
  opt = optimoptions('intlinprog', 'Display', 'none', 'RelativeGapTolerance', rel_gap_tol, 'MaxTime', max_time);
  prob.ObjectiveSense = 'minimize';
  [values_solution, values_minvalue, tmp, min_info] = solve(prob, 'Options', opt);
  if strcmp(min_info.message, 'INFEASIBLE') || strcmp(min_info.message, 'UNBOUNDED')  
    warning('Model infeasible')
    model_infeasible = 1;
  end

  values_solution.min_info = min_info;
  values_solution.min_info.var_numbers.n_cont = n_cont;
  values_solution.min_info.var_numbers.n_int = n_int;
  values_solution.min_info.var_numbers.n_bin = n_bin;
  
  values_solution.values_minvalue = values_minvalue;
  if model_infeasible == 0 
    switch scenario.simulation_type 
      case 1

      case 2 
        values_solution.values_minvalue_with_Pv = values_minvalue;
        values_solution = copy_var(values_solution, values_solution_1st, 'x_GT');
        values_solution = copy_var(values_solution, values_solution_1st, 'x_DG');
        values_solution = copy_var(values_solution, values_solution_1st, 'x_REC');
        values_solution = copy_var(values_solution, values_solution_1st, 'x_ESS_E');
        values_solution = copy_var(values_solution, values_solution_1st, 'x_ESS_P');
        values_solution = copy_var(values_solution, values_solution_1st, 'E0');
      case 3 
        values_solution.values_minvalue_with_Pv = values_minvalue;
        values_solution = copy_var(values_solution, values_solution_1st, 'x_GT');
        values_solution = copy_var(values_solution, values_solution_1st, 'x_DG');
        % values_solution = copy_var(values_solution, values_solution_1st, 'x_REC');
      otherwise
        error('Case not implemented yet')
    end
  end

  fprintf('Solution ended\n')

  %   ____           _                                       _             
  %  |  _ \ ___  ___| |_   _ __  _ __ ___   ___ ___  ___ ___(_)_ __   __ _ 
  %  | |_) / _ \/ __| __| | '_ \| '__/ _ \ / __/ _ \/ __/ __| | '_ \ / _` |
  %  |  __/ (_) \__ \ |_  | |_) | | | (_) | (_|  __/\__ \__ \ | | | | (_| |
  %  |_|   \___/|___/\__| | .__/|_|  \___/ \___\___||___/___/_|_| |_|\__, |
  %                       |_|                                        |___/ 
  
  % Check that the battery does not charge and discharge at the same time
  if isfield(values_solution, 'Pch') 
    switch scenario.simulation_type
      case {1, 3}
        check_charging(values_solution, values_solution.x_ESS_P);

      case 2
        check_charging(values_solution, values_solution_1st.x_ESS_P);
    
      otherwise
        error('Case not implemented yet')
    end

  end

  if model_infeasible == 0
    % Reshape values in a vector
    values.num_REC = num_REC;
    [values_vector, values_solution] = reshape_data(values_solution, Pload, Pres_vec, BAT);
    values_vector.P_res_vec = Pres_vec;

    % % Compute the capacity factors
    % values_vector = capacity_factor(values_vector, values_vector, PV, WT, WEC, BAT, W, T);

    % Compute the emitted CO2
    compute_CO2

    % compute the installed power
    compute_installed_power;
        
    % Evaluate the costs 
    compute_final_costs;  

    % evaluate the LCOE
    % compute_LCOE_polysystem;
    
    % Compute the CVaR
    values_solution.CVaR = values_solution.cvar_zeta + (1/(1 - cvar_alpha))*LscensProbVec_N'*values_solution.cvar_s;

    % % Effective LPSP
    % values_solution.LPSP_eff = sum(values_vector.Pns)/sum(Pload, 'all');
   
  elseif model_infeasible == 1
    values_vector   = [];
    CO2_emitted     = [];
    values_minvalue = [];
  end

end


%    __                  _   _             
%   / _|_   _ _ __   ___| |_(_) ___  _ __  
%  | |_| | | | '_ \ / __| __| |/ _ \| '_ \ 
%  |  _| |_| | | | | (__| |_| | (_) | | | |
%  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|
                                         
% check whether the BESS is charging e discharging at the same time
function check_charging(values_solution, x_ESS_P)
  % This function check that the battery does not charge and discharge at the same time
  if sum(any(values_solution.Pch/x_ESS_P > 5e-4 & values_solution.Pdc/x_ESS_P > 5e-4))
    tmp = (values_solution.Pch > 1e-4) & (values_solution.Pdc > 1e-4);
    idx = 1:1:size(values_solution.Pch, 1) * size(values_solution.Pch, 2);
    
    figure(); hold on;
    plot(reshape(values_solution.Pch, [], 1), 'b', 'DisplayName', 'Pbt\_ch');
    plot(reshape(values_solution.Pdc, [], 1), 'r', 'DisplayName', 'Pbt\_dc');
    
    % Find first occurrence of the condition
    condition_idx = find(tmp, 1);
    
    if ~isempty(condition_idx)
      % Plot vertical line at the condition index
      xline(condition_idx, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Violation');
      legend;
      error('The battery is charging and discharging at the same time');
    end
  end
end

% sum(sol.Pch - sol.Pdc) == 0% constant of the power exchange
% sol.Ebt(T:T:T*W) = sol.E0 % final energy of the batter

function var = gen_var(structure, var_name)
  if isfield(structure, var_name)
    var = structure.(var_name);
  else
    var = 0;
  end
end

function new_structure = copy_var(new_structure, old_structure, var_name)
  if isfield(old_structure, var_name)
    new_structure.(var_name) = old_structure.(var_name);
  else
    new_structure.(var_name) = [];
  end
end