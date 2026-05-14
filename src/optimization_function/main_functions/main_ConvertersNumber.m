close all;
clear;
clc;

figure_enable = 0;

parameters % load parameters related to simulation and converters

if enable_parallel_computing == 1 && isempty(gcp('nocreate'))
  num_core = feature('numcores');
  parpool('Processes', num_core);
end

%    ____                          _                
%   / ___|___  _ ____   _____ _ __| |_ ___ _ __ ___ 
%  | |   / _ \| '_ \ \ / / _ \ '__| __/ _ \ '__/ __|
%  | |__| (_) | | | \ V /  __/ |  | ||  __/ |  \__ \
%   \____\___/|_| |_|\_/ \___|_|   \__\___|_|  |___/

define_converters % define the converters and their parameters

%   ____        _                 _       
%  |  _ \  __ _| |_ __ _ ___  ___| |_ ___ 
%  | | | |/ _` | __/ _` / __|/ _ \ __/ __|
%  | |_| | (_| | || (_| \__ \  __/ |_\__ \
%  |____/ \__,_|\__\__,_|___/\___|\__|___/

import_datasets_norway % load the datasets of the different resources

%   ____                            _             
%  / ___|  ___ ___ _ __   __ _ _ __(_) ___  ___   
%  \___ \ / __/ _ \ '_ \ / _` | '__| |/ _ \/ __|  
%   ___) | (_|  __/ | | | (_| | |  | | (_) \__ \  
%  |____/ \___\___|_| |_|\__,_|_|  |_|\___/|___/  

if use_generate_dataseries == 1 % generate the data series
  [cellScenGenSetRes, scenGenSetLoad] = generate_data_series(scenario, scenGenSetLoad, LoadA, wind, irradiance, SWH, W_period, enable_parallel_computing);

elseif use_generate_dataseries == 0 % use the original loaded data series
  load_scenarios.iniVec = LoadA.iniVec;
  prob_scens = [];

elseif use_generate_dataseries == 2 % use pre-generated data series
  load(name_dataseries, 'cellScenGenSetRes', 'scenGenSetLoad');

else
  error('Unknown option for use_generate_dataseries')

end

%    ____             __ _                    _   
%   / ___|___  _ __  / _(_) __ _     ___  ___| |  
%  | |   / _ \| '_ \| |_| |/ _` |   / __|/ _ \ |  
%  | |__| (_) | | | |  _| | (_| |_  \__ \  __/ |_ 
%   \____\___/|_| |_|_| |_|\__, (_) |___/\___|_(_)
%                          |___/                  
%%
REC     = RECX();
REC.WT  = WT; 
REC.PV  = PV;
REC.WEC = WEC;
REC.GT.GT_obj   = GT_obj;
REC.GT.n_NREC   = n_GT;
REC.DG.DG_obj   = DG_obj;
REC.DG.n_NREC   = n_DG;
REC.DGs.DG_obj  = DGs_obj;
REC.DGs.n_NREC  = n_DGs;
% GT24         -> GT only 
% GT365        -> GT only w/o scenario
% 1GT+WT+DG    -> 1 GT + BESS + WT + DG 
% 2GT+WT+DG    -> 2 GT + BESS + WT + DG
% 1GT+REC+DG   -> 1 GT + BESS + WT+PV+WEC + DG
% 2GT+REC+DG   -> 2 GT + BESS + WT+PV+WEC + DG 
% GT+REC+DG    -> GT + BESS + WT+PV+WEC + DG 
% WT+DG        -> WT + BESS + DG
% REC-U        -> WT+PV+WEC (uncstr.) + BESS 
% REC-U+DG     -> WT+PV+WEC (uncstr.) + BESS + DG
% REC-C+DG24   -> WT+PV+WEC (cstr.) + BESS + DG w/ scenario
% REC-C+DG365  -> WT+PV+WEC (cstr.) + BESS + DG w/o scenario
% DG+REC24     -> WT+PV+WEC (cstr.) + BESS + DIESEL w/ scenario
% DG+REC365    -> WT+PV+WEC (cstr.) + BESS + DIESEL w/o scenario

% case_sim_vec = {'WT+DG'};
case_sim_vec  = {'GT24', 'GT365', '1GT+WT+DG', '2GT+WT+DG', '1GT+REC+DG', '2GT+REC+DG', 'GT+REC+DG', 'WT+DG', 'REC-U', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365', 'DG+REC24', 'DG+REC365'};
case_sim_vec  = {'1GT+REC+DG'}; %  {'GT24'}; 
num_sim       = length(case_sim_vec);


%   ____                                    _   
%  / ___|_      _____  ___ _ __    ___  ___| |  
%  \___ \ \ /\ / / _ \/ _ \ '_ \  / __|/ _ \ |  
%   ___) \ V  V /  __/  __/ |_) | \__ \  __/ |_ 
%  |____/ \_/\_/ \___|\___| .__/  |___/\___|_(_)
%                         |_|                   

% Decide which type of sweep to perform in the loop 1
% None          -> No sweep, only 1 simulation
% alpha         -> Change the CVaR control parameter
% scenario_num  -> Change the number of scenarios
loop_type_1  = 'scenario_num';
switch loop_type_1
  case 'None'
    loop_vec_1 = 0; % dummy value
  case 'alpha'
    loop_vec_1  = 0.8;  
  case 'scenario_num'
   loop_vec_1 = [5:7:54,60:12:156];
  %  loop_vec_1 = [84,120,156];
  loop_vec_1 = [1:1:5];
  
  otherwise
    error('Unknown sweep type')
end

% Decide which type of sweep to perform in the loop 2
% None -> No sweep, only 1 simulation
% beta -> Change the CVaR control parameter
% LPSP -> Change the LPSP
% PS   -> Change the power of the PS
% Carbon_tax -> Change the carbon tax
% seed  -> Change the seed of the rng
loop_type_2  = 'seed';
switch loop_type_2
  case 'None'
    loop_vec_2 = 0;
  case 'beta'
    loop_vec_2 = [0:0.25:1];
  case 'LPSP'
    loop_vec_2 = [0:0.01:0.05];%[0, 0.1, 0.5, 0.9];
  case 'PS'
    loop_vec_2 = [0:0.025:0.1];
  case 'Carbon_tax'
    loop_vec_2 = [1,10,100,1000];
  case 'PVCost'
    loop_vec_2 = [1,0.7,0.5];
  case 'seed'
    loop_vec_2 = 1:1:28;
  otherwise
    error('Unknown sweep type')
end

size_loop_vec_1 = size(loop_vec_1, 2);
size_loop_vec_2 = size(loop_vec_2, 2);

if use_generate_dataseries == 2
  load(name_dataseries, 'size_loop_vec_1', 'size_loop_vec_2', 'loop_vec_1', 'loop_vec_2');
end

%%
% if performing only the 2nd stage, import the data series and store the previous results in a structure
if scenario.simulation_type == 2
  load(simulation_first_stage_results, 'loop_vec_1', 'loop_vec_2', 'values_solution', 'values_vector', 'values_minvalue', 'REC','opt_parameters');
  values_solution_1st = values_solution;
  values_vector_1st   = values_vector;
  values_minvalue_1st = values_minvalue;
  % CO2_emitted_1st     = CO2_emitted;
  use_generate_dataseries = 0;
  opt_parameters_1st = opt_parameters;

elseif scenario.simulation_type == 1
  values_solution_1st = cell(size_loop_vec_1, size_loop_vec_2, num_sim);
  
end

clear REC_obj scenario_mat opt_parameters_vec
size_loop_vec_1 = size(loop_vec_1, 2);
size_loop_vec_2 = size(loop_vec_2, 2);
% load_scenarios.iniV   ec = [];
% Initialize variables to be modified          during the parallel simulation
REC_obj(1:size_loop_vec_1,1:size_loop_vec_2)      = REC;
scenario_mat(1:size_loop_vec_1,1:size_loop_vec_2) = scenario;
opt_parameters_vec(1:num_sim)                     = opt_parameters;
prob_scens                                        = cell(size_loop_vec_1, size_loop_vec_2);
res_scens                                         = cell(size_loop_vec_1, size_loop_vec_2);
load_scens                                        = cell(size_loop_vec_1, size_loop_vec_2);
REC_tmp                                           = cell(size_loop_vec_1, size_loop_vec_2);
LselScens_N                                       = cell(size_loop_vec_1, size_loop_vec_2);
time_sim                                          = cell(size_loop_vec_1, size_loop_vec_2, num_sim);
seed_increment                                    = zeros(size_loop_vec_2);
values_solution                                   = cell(size_loop_vec_1, size_loop_vec_2, num_sim);
values_vector                                     = cell(size_loop_vec_1, size_loop_vec_2, num_sim);
values_minvalue                                   = cell(size_loop_vec_1, size_loop_vec_2, num_sim);
CO2_emitted                                       = cell(size_loop_vec_1, size_loop_vec_2, num_sim);
converged                                         = false(size_loop_vec_1, size_loop_vec_2, num_sim);
retry_count                                       = zeros(size_loop_vec_1, size_loop_vec_2); 
incremental_seed                                  = repmat(loop_vec_2,[maxRetries,1]) + [0:1:maxRetries-1]'.*max(loop_vec_2);

if use_generate_dataseries == 2
  load(name_dataseries, 'res_scens', 'load_scens', 'prob_scens');
end

% size_loop_vec_2 = 28;
% size_loop_vec_1 = 7;
% size_loop_vec_1 = 7;

parfor b = 1:size_loop_vec_2
    converged_a = false(size_loop_vec_1,1);
  for a = 1:size_loop_vec_1
       retryCount = 0;
    while  ~all(converged_a) && retryCount < maxRetries
      retryCount = retryCount + 1;

      % If looping over seeds, set it
      if strcmp(loop_type_1, 'scenario_num')
        scenario_mat(a, b).InScenNum  = loop_vec_1(a);   % number of scenarios to generate
      else
        scenario_mat(a, b).InScenNum = scenario.InScenNum_fix; % use a fix number of scenarios 
      end

      % Do the scenario reduction
      current_seed = rngSeed + incremental_seed(retryCount, b);
      if  use_generate_dataseries == 0
        res_scens{a,b}{1}  = wind.iniVec;
        res_scens{a,b}{2}  = irradiance.iniVec;
        res_scens{a,b}{3}  = reshape(met_data_swh, [], 1);
        res_scens{a,b}{4}  = reshape(met_data_mwp, [], 1);
        load_scens{a,b}    = load_scenarios;
        prob_scens{a,b}    = [];
        
      elseif use_generate_dataseries == 1 
        % display(current_seed)
        [res_scens{a,b}, load_scens{a,b}, prob_scens{a,b}] = generate_scenarios(cellScenGenSetRes, scenGenSetLoad, load_scenarios, scenario_mat(a,b), current_seed, enable_parallel_computing);
      
      elseif use_generate_dataseries == 2
        % data already loaded before

      end
      
      [REC_tmp{a,b}] = do_power(REC_obj(a,b), res_scens{a,b});
      
      for i=1:num_sim
        if converged_a(a)
          continue; % Skip if already converged from previous retry
        end

        tic;
        case_sim = case_sim_vec{i};
        
        % Optimization setup
        [REC_el, load_scenarios_el, opt_parameters_el, scenario_tmp] = optimization_setup(loop_type_1, loop_vec_1, loop_type_2, loop_vec_2, a, b, REC_tmp{a,b}, load_scens{a,b}, scenario_mat(a, b), opt_parameters_vec(i), use_generate_dataseries, case_sim);
        
        % Run optimization
        [values_solution{a,b,i}, values_vector{a,b,i}, values_minvalue{a,b,i}, CO2_emitted{a,b,i}] = CASE_optimization(prob_scens{a,b}, REC_el, ESS, DL, load_scenarios_el, opt_parameters_el, scenario_tmp, case_sim, values_solution_1st{a,b,i});

        % Track time and convergence
        time_sim{a,b,i} = toc;
        fprintf('Simulation, case=%s, a=%4d, b=%3d, retry=%2d, seed=%3d, time=%5.f [s], stop due to %s\n, convergence=%5.2f\n', case_sim, loop_vec_1(a), loop_vec_2(b), retryCount, current_seed, time_sim{a,b,i}, values_solution{a,b,i}.min_info.message,values_solution{a,b,i}.min_info.relativegap);

        % Check convergence flag from optimizer message or criteria
        if strcmp(values_solution{a,b,i}.min_info.message, 'OPTIMAL') || values_solution{a,b,i}.min_info.relativegap <= 1 % opt_parameters_el.rel_gap_tol*100
          converged_a(a) = true;
        end
      end
    end
  end
end

%%
%   ____  _       _   
%  |  _ \| | ___ | |_ 
%  | |_) | |/ _ \| __|
%  |  __/| | (_) | |_ 
%  |_|   |_|\___/ \__|

idx_include         = logical(zeros(size_loop_vec_1, size_loop_vec_2, num_sim));
values_minvalue_mat = zeros(size_loop_vec_1, size_loop_vec_2, num_sim);
time_mat            = zeros(size_loop_vec_1, size_loop_vec_2, num_sim);
for a=1:size_loop_vec_1
  for b=1:size_loop_vec_2
    for i=1:num_sim
      if ~isempty(values_minvalue{a,b,i})
        values_minvalue_mat(a,b,i) = values_minvalue{a,b,i};
        time_mat(a,b,i) = time_sim{a,b,i};
        % if strcmp(values_solution{a,b,i}.min_info.message, 'OPTIMAL')
        % if values_solution{a,b,i}.min_info.relativegap <= opt_parameters.rel_gap_tol*100
        % if values_minvalue{a,b,i} <= 5.5e5 && strcmp(values_solution{a,b,i}.min_info.message, 'OPTIMAL')
        % if values_minvalue{a,b,i} > 6.5e5 && strcmp(values_solution{a,b,i}.min_info.message, 'OPTIMAL')
        if values_solution{a,b,i}.min_info.relativegap <= 2
          idx_include(a,b,i) = 1;
        end
      end
    end
  end
end
   
% write_on_file.flag = 0;
% write_on_file.name = '../report/figure/vectorial/results_2024_10_24.txt';
% for a=1:size_loop_vec_1
%   for b=1:size_loop_vec_2
%     for i=1:num_sim
%       display_results(min_values{a,b},values_minvalue{a,b},PV,WT,WEC, i, j, write_on_file);
%     end
%   end
% end

statistics = cell(num_sim, 1);
for i=1:num_sim
  for a=1:size_loop_vec_1
    vals = values_minvalue_mat(a,:, i);
    inc = idx_include(a,:,i);
    sel_val = vals(inc);
    statistics{i}.mean_F(a)        = mean(sel_val, 2); % mean of the cost function
    statistics{i}.std_F(a)         = std(sel_val, 0, 2); % standard deviation of the cost function
    statistics{i}.median_F(a)      = median(sel_val, 2); % median of the cost function
    statistics{i}.iqr_F(a)         = iqr(sel_val, 2); % interquartile range of the cost function
    statistics{i}.range_F(a)       = range(sel_val, 2); % range of the cost function
    statistics{i}.percentile_F(a,:)  = prctile(sel_val, [95, 90], 2); % percentile 
  end
end
% close all;
if scenario.simulation_type == 1
  plot_ISS
elseif scenario.simulation_type == 2
  plot_OSS
end
% plot_decarbonization

%%
%   ____                 _ _                    __ _ _      
%  |  _ \ ___  ___ _   _| | |_    ___  _ __    / _(_) | ___ 
%  | |_) / _ \/ __| | | | | __|  / _ \| '_ \  | |_| | |/ _ \
%  |  _ <  __/\__ \ |_| | | |_  | (_) | | | | |  _| | |  __/
%  |_| \_\___||___/\__,_|_|\__|  \___/|_| |_| |_| |_|_|\___|
                                                          
% for i=1:num_sim
%   cost = values_minvalue{i};  
%   CO2 = CO2_emitted{i};
%   fprintf('The cost of the simulation %s is %.2f [M$], CO2 emitted %.2f \n',case_sim_vec{i}, cost/1e6, CO2);
% end

%   _____                 _   _             
%  |  ___|   _ _ __   ___| |_(_) ___  _ __  
%  | |_ | | | | '_ \ / __| __| |/ _ \| '_ \ 
%  |  _|| |_| | | | | (__| |_| | (_) | | | |
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|
                                          