function [cellScenGenSetRes, scenGenSetLoad, ES] = generate_data_series(scenario, scenGenSetLoad, LoadA_input, wind_input, irradiance_input, SWH_input, W_period_input, enable_parallel_computing)
  %% This function generates data series statistically similar to the initial dataset 
  cellScenGenSetRes = cell(4, 1);         % Cell containing all the renewable resources

  LoadA = copy(LoadA_input);
  wind = copy(wind_input);
  irradiance = copy(irradiance_input);
  SWH = copy(SWH_input);
  W_period = copy(W_period_input);

  % rem_division_InScenNum = rem(max_hour_number, scenario.T_copula);
  rem_division = rem(length(reshape(LoadA.iniVec,[],1)), scenario.T_copula);
  if rem_division == 0
  else

    % reduce the number of samples
    LoadA.iniVec      = LoadA.iniVec(1:end-rem_division);
    wind.iniVec       = wind.iniVec(1:end-rem_division);
    irradiance.iniVec = irradiance.iniVec(1:end-rem_division);
    SWH.iniVec        = SWH.iniVec(1:end-rem_division);
    W_period.iniVec   = W_period.iniVec(1:end-rem_division);
  end


  uniqueSeed_1  = mod(now,10)*1e4;
  LoadA.iniVec  = LoadA.UnGroupSamples;
  LoadA.iniVec  = LoadA.GroupSamplesBy(scenario.T_copula);

  uniqueSeed_2  = mod(now,10)*1e4; 
  wind.iniVec   = wind.UnGroupSamples;
  wind.iniVec   = wind.GroupSamplesBy(scenario.T_copula);

  uniqueSeed_3      = mod(now,10)*1e4;
  irradiance.iniVec = irradiance.UnGroupSamples;
  irradiance.iniVec = irradiance.GroupSamplesBy(scenario.T_copula);

  uniqueSeed_4  = mod(now,10)*1e4;
  SWH.iniVec    = SWH.UnGroupSamples;
  SWH.iniVec    = SWH.GroupSamplesBy(scenario.T_copula);

  uniqueSeed_5    = mod(now,10)*1e4;
  W_period.iniVec = W_period.UnGroupSamples;
  W_period.iniVec = W_period.GroupSamplesBy(scenario.T_copula);

  if enable_parallel_computing == 0 
    [tmp_load, ~, ES_load_tmp, ~, KL_load_tmp] = LoadA.DoCopulaOptBW(scenario, uniqueSeed_1); % Find the optimal bw
    
    [tmp_wind, ~, ES_wind_tmp, ~, KL_wind_tmp] = wind.DoCopulaOptBW(scenario, uniqueSeed_2); % Find the optimal bw
    
    [tmp_irradiance, ~, ES_irradiance_tmp, ~, KL_irradiance_tmp] = irradiance.DoCopulaOptBW(scenario, uniqueSeed_3); % Find the optimal bw
    
    [tmp_SWH, ~, ES_SWH_tmp, ~, KL_SWH_tmp] = SWH.DoCopulaOptBW(scenario, uniqueSeed_4); % Find the optimal bw
    
    [tmp_W_period, ~, ES_W_period_tmp, ~, KL_W_period_tmp] = W_period.DoCopulaOptBW(scenario, uniqueSeed_5); % Find the optimal bw
    
  else 
    [tmp_load, ~, ES_load_tmp, ~, KL_load_tmp] = LoadA.DoCopulaOptBW_par(scenario, uniqueSeed_1); % Find the optimal bw
    
    [tmp_wind, ~, ES_wind_tmp, ~, KL_wind_tmp] = wind.DoCopulaOptBW_par(scenario, uniqueSeed_2); % Find the optimal bw
    
    [tmp_irradiance, ~, ES_irradiance_tmp, ~, KL_irradiance_tmp] = irradiance.DoCopulaOptBW_par(scenario, uniqueSeed_3); % Find the optimal bw
    
    [tmp_SWH, ~, ES_SWH_tmp, ~, KL_SWH_tmp] = SWH.DoCopulaOptBW_par(scenario, uniqueSeed_4); % Find the optimal bw
    
    [tmp_W_period, ~, ES_W_period_tmp, ~, KL_W_period_tmp] = W_period.DoCopulaOptBW_par(scenario, uniqueSeed_5); % Find the optimal bw
    
  end

  cellScenGenSetRes{1}  = DataX(tmp_wind);       % Wind 
  cellScenGenSetRes{2}  = DataX(tmp_irradiance); % Irradiance
  cellScenGenSetRes{3}  = DataX(tmp_SWH);        % Significant wave height
  cellScenGenSetRes{4}  = DataX(tmp_W_period);   % Wave period 
  scenGenSetLoad.iniVec = tmp_load;       


  ES.ES_load        = ES_load_tmp;
  ES.ES_wind        = ES_wind_tmp;
  ES.ES_irradiance  = ES_irradiance_tmp;
  ES.ES_SWH         = ES_SWH_tmp;
  ES.ES_W_period    = ES_W_period_tmp;
end