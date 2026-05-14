function prob = BESS_constraints(prob, BESS_type, E0, Ebt, Pch, Pdc, Pbt, Uch, Udc, PchUch, PdcUdc, BAT, x_ESS_E, x_ESS_P, epsilon_bat)
% BESS_type == 1 => non linear model
% BESS_type == 0 => linear model

  eta_ch = BAT.eta_ch; % battery cherging efficiency  
  eta_dc = BAT.eta_dc; % battery discharging efficiency

  if ~isempty(BAT)
    if BESS_type == 1
      prob = BESS_SOC_stationarity_NL_model(prob, 'Ebt', E0, Ebt, Pch*eta_ch, Pdc/eta_dc);
      prob = max_power(prob, 'PchUch_max', Pch, PchUch);
      prob = max_power(prob, 'PdcUdc_max', Pdc, PdcUdc);
      prob = max_power(prob, 'Pch_max', Pch, x_ESS_P*BAT.C_power_u);
      prob = max_power(prob, 'Pdc_max', Pdc, x_ESS_P*BAT.C_power_u);
      prob = lin_ContBin(prob, 'lin_NL_PchUch', PchUch, Pch, Uch, BAT.Pch_max, 0);
      prob = lin_ContBin(prob, 'lin_NL_PdcUdc', PdcUdc, Pdc, Udc, BAT.Pch_max, 0);
      prob = BESS_UchUdc(prob, 'UchUdc', Uch, Udc);
    else
      prob = BESS_SOC_stationarity(prob, E0, Ebt, Pbt);
      prob = BESS_P_minmax(prob, Pbt, x_ESS_P);
      prob = max_power(prob, 'Pch_max', Pch, x_ESS_P);
      prob = max_power(prob, 'Pdc_max', Pdc, x_ESS_P);
    end
    prob = BESS_SOC_minmax(prob, 'E0', E0, x_ESS_E, BAT, 0);   % initial energy
    prob = BESS_SOC_minmax(prob, 'Ebt', Ebt, x_ESS_E, BAT, 0);  % general energy
  else 
  end

end