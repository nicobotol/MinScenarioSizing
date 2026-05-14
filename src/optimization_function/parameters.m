%    ____                           _ 
%   / ___| ___ _ __   ___ _ __ __ _| |
%  | |  _ / _ \ '_ \ / _ \ '__/ _` | |
%  | |_| |  __/ | | |  __/ | | (_| | |
%   \____|\___|_| |_|\___|_|  \__,_|_|
        
warning('off', 'stats:ksdensity:NoConvergence');
rngSeed = 1;

%   ____                            _       
%  / ___|  ___ ___ _ __   __ _ _ __(_) ___  
%  \___ \ / __/ _ \ '_ \ / _` | '__| |/ _ \ 
%   ___) | (_|  __/ | | | (_| | |  | | (_) |
%  |____/ \___\___|_| |_|\__,_|_|  |_|\___/ 
                                          
scenario.hours_start  = 365*24+1; % Time when start to load data from the dataset
scenario.hours_stop   = 730*24;   % Time when start to load data from the dataset
scenario.InCopula     = 200;      % Number of data series to generate during the copula (greater than InScenNum)
scenario.InScenNum_fix= 4;        % Fix number of scenarios (to be used when not looping)
scenario.T_copula     = 24;       % Scenario length during the data series generation
scenario.InScenNum    = [];
scenario.W            = [];
% use_generate_dataseries   = 0;    
enable_parallel_computing = 1;    % 1 for parallel computing, 0 for sequential computing
maxRetries            = 2; % max number of attempts for generating the scenarios if not converged
% 1 for 1st+2nd stage;
% 2 for only 2nd
% 3 for fixing some 1st stage variables and optimizing others
% 4 for 1st+2nd stage but using generated dataseries from a previous simulation
scenario.simulation_type  = 1;    
% simulation_first_stage_results = 'results/scenario_num_1GTRECDG_2025_12_04.mat'; % filename form where to load the first stage results
simulation_first_stage_results = 'results/test.mat'; % filename form where to load the first stage results

if scenario.simulation_type == 2
  use_generate_dataseries = 0; % In case of only second stage, use the original load 
elseif scenario.simulation_type == 1
  use_generate_dataseries = 1; % In case of first and second stage, use the generated load 
elseif scenario.simulation_type == 3
  use_generate_dataseries = 1;
elseif scenario.simulation_type == 4
  % usa dataseries from a previous example
  use_generate_dataseries = 2;
  name_dataseries = 'results/scenario_num_1GTRECDG_2025_12_04.mat';
  scenario.simulation_type  = 1;
end 

%    ___        _   _           _          _   _             
%   / _ \ _ __ | |_(_)_ __ ___ (_)______ _| |_(_) ___  _ __  
%  | | | | '_ \| __| | '_ ` _ \| |_  / _` | __| |/ _ \| '_ \ 
%  | |_| | |_) | |_| | | | | | | |/ / (_| | |_| | (_) | | | |
%   \___/| .__/ \__|_|_| |_| |_|_/___\__,_|\__|_|\___/|_| |_|
%        |_|                                                 

opt_parameters.alpha    = 0.0;
opt_parameters.beta     = 0.0;
opt_parameters.r_annual = 0.07; % annual interest rate
opt_parameters.r        = opt_parameters.r_annual/365; % daily interest rate
opt_parameters.L        = 10; % investment lifetime
opt_parameters.BESS_NL_model = 1; % 1 -> nonlinear model, 0 -> linear model
opt_parameters.rev_FC   = 1; % 1 -> reversible fuel cell, 0 -> separated fuel cell and electrolyzer
opt_parameters.rel_gap_tol = 2e-2;
if scenario.simulation_type == 2
  opt_parameters.rel_gap_tol = 1e-2; % tight optimization tolerance
elseif scenario.simulation_type == 3
  opt_parameters.rel_gap_tol = 1e-2; % tight optimization tolerance
end

%   _                    _ 
%  | |    ___   __ _  __| |
%  | |   / _ \ / _` |/ _` |
%  | |__| (_) | (_| | (_| |
%  |_____\___/ \__,_|\__,_|                

%    ____      _     _ 
%   / ___|_ __(_) __| |
%  | |  _| '__| |/ _` |
%  | |_| | |  | | (_| |
%   \____|_|  |_|\__,_|

%   ______     __                         _ 
%  |  _ \ \   / /  _ __   __ _ _ __   ___| |
%  | |_) \ \ / /  | '_ \ / _` | '_ \ / _ \ |
%  |  __/ \ V /   | |_) | (_| | | | |  __/ |
%  |_|     \_/    | .__/ \__,_|_| |_|\___|_|
%                 |_|                       

%  __        ___           _   _              _     _            
%  \ \      / (_)_ __   __| | | |_ _   _ _ __| |__ (_)_ __   ___ 
%   \ \ /\ / /| | '_ \ / _` | | __| | | | '__| '_ \| | '_ \ / _ \
%    \ V  V / | | | | | (_| | | |_| |_| | |  | |_) | | | | |  __/
%     \_/\_/  |_|_| |_|\__,_|  \__|\__,_|_|  |_.__/|_|_| |_|\___|

%   ____        _   _                   
%  | __ )  __ _| |_| |_ ___ _ __ _   _  
%  |  _ \ / _` | __| __/ _ \ '__| | | | 
%  | |_) | (_| | |_| ||  __/ |  | |_| | 
%  |____/ \__,_|\__|\__\___|_|   \__, | 
%                                |___/  

% decide which kind of BESS model to use
% 0 -> linear model
% 1 -> Nonlinear model
BESS_NL_model = 1;

%   ____                        
%  |  _ \ _   _ _ __ ___  _ __  
%  | | | | | | | '_ ` _ \| '_ \ 
%  | |_| | |_| | | | | | | |_) |
%  |____/ \__,_|_| |_| |_| .__/ 
%                        |_|    

%   ____  _       _   
%  |  _ \| | ___ | |_ 
%  | |_) | |/ _ \| __|
%  |  __/| | (_) | |_ 
%  |_|   |_|\___/ \__|
                    
plot_param.font_size = 12;
plot_param.line_width = 1.5;
plot_param.print_figure = 0;
marker_vec = {'x', 'o', 'd'};

% % Create custom colormap
% n = 256; % Number of colors in the colormap
% rgb_red = color(2);
% whiteToRed = [linspace(1, rgb_red(1), n)', linspace(1, rgb_red(2), n)', linspace(1, rgb_red(3), n)']; % White to red gradient
% % Insert blue for zero value
% customColormap = [color(1); whiteToRed];

set(0,'DefaultFigureWindowStyle','docked');
beep off;

%   ____       _   _     
%  |  _ \ __ _| |_| |__  
%  | |_) / _` | __| '_ \ 
%  |  __/ (_| | |_| | | |
%  |_|   \__,_|\__|_| |_|
                       
addpath(genpath('meteo_data_import'));
addpath(genpath(['converters_models']));
addpath(genpath(['load_data']));
addpath(genpath(['optimization_function']));
addpath(genpath(['plot_function']));
addpath(genpath('main_function'));

% If running on IEL farm add the path to gurobi
hostname = getenv('COMPUTERNAME');
if ~isempty(regexp(hostname, '^IT-ELFARM\d+$', 'once'))
    % Folder that can't be saved in path permanently
    addpath('C:\programs\gurobi911\win64\matlab\html');
    addpath('C:\programs\gurobi911\win64\matlab');
    addpath('C:\programs\gurobi911\win64\examples\matlab');

end