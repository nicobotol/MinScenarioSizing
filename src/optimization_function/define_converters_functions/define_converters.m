%% This script defines the different converters and their parameters

% Dump load
DL = DumpLoadX();
DL.C_OeM = 1e3; % [$/MW]
DL.Pct_max = 1; % [W]

% Parameters related to the grid
GRID = GridX();

%  __        _______ 
%  \ \      / /_   _|
%   \ \ /\ / /  | |  
%    \ V  V /   | |  
%     \_/\_/    |_|  
                   
% WT_filename             = 'converters_models/2023NREL_Bespoke_3MW_127.csv'; % 3 [MW] wind turbine
WT_filename             = 'converters_models/2020ATB_NREL_Reference_8MW_180.csv'; % 7 [MW] wind turbine
WT_coefficient          = 1e-3; % coefficient to convert the power curve in [W]
WT                      = WindTurbineX([], WT_filename, WT_coefficient);
WT.C_CAPEX              = 3.2*1e6;  % CAPEX [$/MW]
WT.C_OPEX               = 0.11*1e6; % OPEX [$/MWyr]
WT.C_DECOM              = 0;    % decommissioning [$/W]
WT.hub_height           = 112;  % hub height of the 7 [MW] wind turbine [m]
WT.WS_measure_height    = WT.hub_height; % height at which the WS was measured [m] N.B. Since the wind speed in the dataset already accounts for the shear law this parameters is not considered here
WT.WS_alpha             = 0.11; % coefficient for the wind shear
WT.V_in                 = 4; % cut-in wind speed [m/s]
WT.V_out                = 25; % cut-out wind speed [m/s]
WT.V_rated              = 12; % rated wind speed [m/s]
WT.max_installed_power  = 50; % maximum power of the wind farm [MW]
WT.PowRated             = max(WT.PC_power*1e-3); % rated power of the wind turbine [MW]

%   ______     __
%  |  _ \ \   / /
%  | |_) \ \ / / 
%  |  __/ \ V /  
%  |_|     \_/   
               
PV                      = PhotoVoltaicX([]);
PV.A_eff                = 1.663; % [m^2] effective area of the PV panel
PV.eta_c                = 14.4/100; % conversion efficiency in STC
PV.eta_AC               = 0.95; % Conversion efficiency DC to AC
PV.C_CAPEX              = 1.1*2*1e6;    % CAPEX [$/MW]
PV.C_OPEX               = 1.1*0.3*1e6;  % OPEX [$/MW]
PV.C_DECOM              = 1.1*1.0e6; % decommissioning [$/MW]
PV.PowRated             = 240*1e-6; % [MW] rated power
PV.max_area             = 5e4; % maximum area of the PV field [m^2]
PV.max_installed_power  = 1; % maximum power of the PV field [W]
PV.power_coefficient    = 1e-6; % coefficient for rescaling the power in different units
PV_CAPEX_ref            = PV.C_CAPEX;
PV_OPEX_ref             = PV.C_OPEX;

%  __        _______ ____ 
%  \ \      / / ____/ ___|
%   \ \ /\ / /|  _|| |    
%    \ V  V / | |__| |___ 
%     \_/\_/  |_____\____|
                        
WEC                     = WECX([]);
WEC.C_CAPEX             = 1.1*5*1e6;   % CAPEX [$/MW]
WEC.C_OPEX              = 0.28*1e6;    % OPEX [$/MW]
WEC.PowRated            = 0.400;       % rated power [MW]
pelamis_filename        = 'converters_models/corpower_power_matrix.csv';
pelamis_axes_filename   = 'converters_models/corpower_power_matrix_axes.csv';
dataLines_PM            = [1, inf];
dataLines_axes          = [4, inf];
WEC.import_powermatrix_corpower(pelamis_filename, dataLines_PM, pelamis_axes_filename, dataLines_axes);
WEC.WEC_coefficient     = 1e-3; % coefficient to rescale the power matrix 
WEC.max_installed_power = 5; % maximum tot WEC installed power [MW]

%   _                    _ 
%  | |    ___   __ _  __| |
%  | |   / _ \ / _` |/ _` |
%  | |__| (_) | (_| | (_| |
%  |_____\___/ \__,_|\__,_|
                         
load_scenarios                = LoadX([]);
load_scenarios.delta_load     = 0.1; % percentage of the load generating power imbalance
load_scenarios.NS_cost        = 1e3; % cost of not served energy [$/MWh]
load_scenarios.Pv_cost        = 1e4;%load_scenarios.NS_cost*1e1; % cost of not served energy [$/MWh]
load_scenarios.CT_cost        = 5e-3*1e6; % cost of curtailed energy [$/MWh]
load_scenarios.Pct_max        = 1; % max curtailing power [MW]
load_scenarios.LPSP_target    = 0.0;
load_scenarios.NS_fraction    = 0.10; % fraction of the load that can be not served
load_scenarios.P_rated        = 50; % rated power of the load [MW]
load_scenarios.P_shaved_frac  = 0.0; % fraction of rated power that can be re-allocated within the time horizon
load_scenarios.P_shaved_overpower = 1.1; % factor of increase of load power w.r.t. the rated power when doing peak shaving
load_scenarios.Pps_add_cost    = 1e-5*1e6; % cost of adding power to the load [$/MW] (not used)
load_scenarios.Pps_rem_cost    = 1e-5*1e6; % cost of removing power to the load [$/MW] (not used)

%   ____    _  _____ 
%  | __ )  / \|_   _|
%  |  _ \ / _ \ | |  
%  | |_) / ___ \| |  
%  |____/_/   \_\_|  
                   
% Define the battery
BAT = BatteryX();
BAT.C_storage_u = 10; % Capacity of 1 battery module [MWh]
BAT.C_power_u   = 1; % power of 1 battery module [MW]
BAT.C_CAPEX_E   = 0.250*1e6; % BESS cost+installation [$/MWh]
BAT.C_CAPEX_P   = 0.200*1e6; % BESS cost+installation [$/MW]
BAT.C_OPEX_E    = 0.05*BAT.C_CAPEX_E; % OPEX [$/Wh]
BAT.C_OPEX_P    = 0.05*BAT.C_CAPEX_P; % OPEX [$/W]
BAT.C_DECOM     = 0.0; % decommissioning [$/W]
BAT.C_charge    = 5e-4;
BAT.C_discharge = 5e-4;
BAT.eta_ch      = 1; % charging efficiency
BAT.eta_dc      = 1; % discharging efficiency
BAT.constraint_weight=1e-3; % cost of violating the soft constraint
BAT.SOC_min     = 0.1; % fraction minimum energy stored
BAT.E_max       = 60; % maximum energy stored [MWh]
BAT.Pch_max     = 15; % maximum charging power [MW]
BAT.Pdc_max     = BAT.Pch_max; % maximum discharging power [W]
ESS             = ESSX();
ESS.BAT         = BAT;

%    ____ _____ 
%   / ___|_   _|
%  | |  _  | |  
%  | |_| | | |  
%   \____| |_|             

GT_C_F      = 1.2*1.1*0.24; % fuel sale value [$/m^3]
GT_rho      = 0.77; % density of the fuel [kg/m^3]
GT_mu       = 2.682; % ideal combustion coefficient of gas
GT_C_CO2    = 0.071; % tax per kg of CO2 [$/kg]
GT_alpha_g  = 172.50; % coeff for estimating modeling fuel consumption [kg/MW]
GT_beta_g   = 729.20; % coeff for estimating modeling fuel consumption [kg/h]
GT_C_OeM    = 1.1*5.53; % operation and maintenance [$/MW]
GT_C_start  = 1.1*1217; % Cost of starting the GT [$/start]
GT_C_I_unitary = 820e3; % GT cost [$/MW]
GT_gamma    = 0.40;
GT_Toff     = 1;
GT_C_RR     = 5e-1;

% define the GT
GT_1              = GasTurbineX();
GT_1.C_F          = GT_C_F;     % fuel sale value [$/m^3]
GT_1.rho          = GT_rho;     % density of the fuel [kg/m^3]
GT_1.mu           = GT_mu;      % ideal combustion coefficient of gas
GT_1.C_CO2        = GT_C_CO2;   % tax per kg of CO2 [$/kg]
GT_1.alpha_g      = GT_alpha_g; % coeff for estimating modeling fuel consumption [kg/MW]
GT_1.beta_g       = GT_beta_g;  % coeff for estimating modeling fuel consumption [kg/h]
GT_1.C_OeM        = GT_C_OeM;   % [$/MW]
GT_1.C_start      = GT_C_start; % Cost of starting the GT [$/start]
GT_1.C_I_unitary  = GT_C_I_unitary;% [$/MW]
GT_1.gamma        = GT_gamma;   % minimum technical operational ratio
GT_1.PowRated     = 20;         % Rated power of the GT module [MW]
GT_1.PowMax       = 20;
GT_1.R            = 20;         % Ramping rate [MW/h]
GT_1.Toff         = GT_Toff;    % Time between two start ups of the turbine [h]
GT_1.C_RR         = GT_C_RR;    % Cost of the ramping rate [$/MW]
GT_1.ComputeCosts();

GT_2              = GasTurbineX();
GT_2.C_F          = GT_C_F;     % fuel sale value [$/m^3]
GT_2.rho          = GT_rho;     % density of the fuel [kg/m^3]
GT_2.mu           = GT_mu;      % ideal combustion coefficient of gas
GT_2.C_CO2        = GT_C_CO2;   % tax per kg of CO2 [$/kg]
GT_2.alpha_g      = GT_alpha_g; % coeff for estimating modeling fuel consumption [kg/MW]
GT_2.beta_g       = GT_beta_g;  % coeff for estimating modeling fuel consumption [kg/h]
GT_2.C_OeM        = GT_C_OeM;   % [$/MW]
GT_2.C_start      = GT_C_start; % Cost of starting the GT [$/start]
GT_2.C_I_unitary  = GT_C_I_unitary;   % [$/MW]
GT_2.gamma        = GT_gamma;   % minimum technical operational ratio
GT_2.PowRated     = 5;          % Rated power of the GT module [MW]
GT_2.PowMax       = 5;
GT_2.R            = 5;          % Ramping rate [MW/h]
GT_2.Toff         = GT_Toff;    % Time between two start ups of the turbine [h]
GT_2.C_RR         = GT_C_RR;    % Cost of the ramping rate [$/MW]
GT_2.ComputeCosts();

GT_3              = GasTurbineX();
GT_3.C_F          = GT_C_F;     % fuel sale value [$/m^3]
GT_3.rho          = GT_rho;     % density of the fuel [kg/m^3]
GT_3.mu           = GT_mu;      % ideal combustion coefficient of gas
GT_3.C_CO2        = GT_C_CO2;   % tax per kg of CO2 [$/kg]
GT_3.alpha_g      = GT_alpha_g; % coeff for estimating modeling fuel consumption [kg/MW]
GT_3.beta_g       = GT_beta_g;  % coeff for estimating modeling fuel consumption [kg/h]
GT_3.C_OeM        = GT_C_OeM;   % [$/MW]
GT_3.C_start      = GT_C_start; % Cost of starting the GT [$/start]
GT_3.C_I_unitary  = GT_C_I_unitary;   % [$/MW]
GT_3.gamma        = GT_gamma;   % minimum technical operational ratio
GT_3.PowRated     = 25;         % Rated power of the GT module [MW]
GT_3.PowMax       = 25;
GT_3.R            = 25;         % Ramping rate [MW/h]
GT_3.Toff         = GT_Toff;    % Time between two start ups of the turbine [h]
GT_3.C_RR         = GT_C_RR;    % Cost of the ramping rate [$/MW]
GT_3.ComputeCosts();

% GT_obj            = {GT_1, GT_2, GT_1};
% GT_obj            = {GT_1, GT_2};
GT_obj            = {GT_3, GT_2};
n_GT              = size(GT_obj, 2);        % Maximum number of gas turbines to install

%   ____   ____ 
%  |  _ \ / ___|
%  | | | | |  _ 
%  | |_| | |_| |
%  |____/ \____|
              
cost_diesel_fuel  = 1.8;
cost_C_I_unitary  = 500*1e3; % [$/MW]
cost_diesel_OPEX  = 26;
diesel_gamma      = 0.10; % minimum technical operational ratio
diesel_mu         = 3.17; % ideal combustion coefficient of diesel
alpha_g           = 0.240*1e3;
beta_g            = 0*0.200*1e3;
C_CO2             = GT_C_CO2; % tax per kg of CO2 [$/kg]
rho_DG            = 1;
PwrCostX          = [0.0, 1e-3, 7.5, 30]';
PwrCostF          = [0.5, 0.5, 2.2, 7.4]';
% PwrCostX          = [0,   1e-3, 7.5, 15, 22.5, 30]';
% PwrCostF          = [0.5, 0.5, 2.2, 3.8, 5.6, 7.4]';

% define the Diesel Generator
DG              = DieselGeneratorX();
DG.C_F          = cost_diesel_fuel; %  fuel sale value [$/l]
DG.OPEX         = cost_diesel_OPEX; % annual maintenance [$/KWyr] 
DG.C_I_unitary  = cost_C_I_unitary; % [$/kW]
DG.gamma        = diesel_gamma;     % minimum technical operational ratio
DG.PowRated     = 2;                % Rated power of the GT [kW]
DG.PowMax       = 80;                % Maximum size of the GT [kW]
DG.Ton          = 0; % time that the DG has to be on after it has start up
DG.mu           = diesel_mu; % ideal combustion coefficient of diesel
DG.alpha_g      = alpha_g; % cost of the fuel [$/l]
DG.beta_g       = beta_g; % cost of the fuel [$/l]
DG.C_CO2        = C_CO2; % tax per kg of CO2 [$/kg]
DG.rho          = rho_DG; % density of the fuel [kg/m^3]
DG.ComputeCosts();
% DG_n.base_power   = DG_3.PowRated; % rated power of the DG [W]
DG.PwrCostX     = PwrCostX;
DG.PwrCostF     = PwrCostF; % fuel consumption [l/h]

DG_obj          = {DG};
n_DG            = size(DG_obj, 2);        % Maximum number of gas turbines to install

% define the Supplementary Diesel Generator
DGs              = DieselGeneratorX();
DGs.C_F          = cost_diesel_fuel;    %  fuel sale value [/l]
DGs.OPEX         = cost_diesel_OPEX;       % annual maintenance [/KWyr] 
DGs.C_I_unitary  = 2*cost_C_I_unitary;      % [$/kW]
DGs.gamma        = 0*diesel_gamma;      % minimum technical operational ratio
DGs.PowRated     = 1;         % Rated power of the GT [kW]
DGs.PowMax       = 30;        % Maximum size of the GT [kW]
DGs.Ton          = 0; % time that the DG has to be on after it has start up
DGs.mu           = diesel_mu; % ideal combustion coefficient of diesel
DGs.alpha_g      = 1.1*alpha_g; % cost of the fuel [$/l]
DGs.beta_g       = 1.1*beta_g; % cost of the fuel [$/l]
DGs.C_CO2        = C_CO2; % tax per kg of CO2 [$/kg]
DGs.rho          = rho_DG; % density of the fuel [kg/m^3]
DGs.ComputeCosts();
% DG_n.base_power   = DG_3.PowRated; % rated power of the DG [W]
DGs.PwrCostX     = PwrCostX;
DGs.PwrCostF     = PwrCostF; % fuel consumption [l/h]

DGs_obj          = {DGs};
n_DGs            = size(DGs_obj, 2);        % Maximum number of gas turbines to install

base_CO2_tax = GT_1.C_CO2; % tax per kg of CO2 [$/kg]