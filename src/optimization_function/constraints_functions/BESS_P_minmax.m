function prob = BESS_P_minmax(prob, Pbt, x_ESS_P)
  prob.Constraints.Pch_max = Pbt <= x_ESS_P;
  prob.Constraints.Pdc_max = Pbt >= -x_ESS_P;
end