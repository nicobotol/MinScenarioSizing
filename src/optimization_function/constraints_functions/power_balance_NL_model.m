function prob = power_balance_NL_model(prob, P_generators, Pch, Pdc, Pct, Pload_PS)
  % power balance
  prob.Constraints.pwr_bln    = P_generators + Pdc == Pload_PS + Pch + Pct;
end