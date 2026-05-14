function prob = BESS_SOC_minmax(prob, name, Ebt, x_ESS_E, BAT, epsilon_bat)
  if ~isa(x_ESS_E, 'double')
    prob.Constraints.([name, '_max'])     = Ebt  <= x_ESS_E*BAT.C_storage_u*BAT.SOC_max;
    prob.Constraints.([name, '_min'])     = Ebt  >= x_ESS_E*BAT.C_storage_u*BAT.SOC_min - epsilon_bat;
  end
end