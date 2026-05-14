function prob = GT_P_minmax(prob, name, n_GT, T, W, P_GT, x_GT, GT_obj, u_GT, z_help)
  % GT/DG power output constraints

  % for g=1:n_GT
  %   PowRated = GT_obj{g}.PowRated;
  %   GT_gamma = GT_obj{g}.gamma;
  %   P_GT_max = PowRated.*x_GT(g); 
  %   GT_power_max(1:T,1:W,g)   = P_GT(1:T,1:W,g) <= P_GT_max; % maximum power output of the GT
  %   GT_power_min(1:T,1:W,g)   = P_GT(1:T,1:W,g) >= P_GT_max*GT_gamma; % minimum power output of the GT
  % end
  % prob.Constraints.GT_power_max = GT_power_max;
  % prob.Constraints.GT_power_min = GT_power_min;

  for g=1:n_GT
    PowRated = GT_obj{g}.PowRated;
    GT_gamma = GT_obj{g}.gamma;
    P_GT_max = PowRated.*z_help(1:T,1:W,g); 
    GT_power_max(1:T,1:W,g)   = P_GT(1:T,1:W,g) <= P_GT_max; % maximum power output of the GT
    % GT_power_max(1:T,1:W,g)   = P_GT(1:T,1:W,g) <= PowRated; % maximum power output of the GT
    GT_power_min(1:T,1:W,g)   = P_GT(1:T,1:W,g) >= P_GT_max*GT_gamma; % minimum power output of the GT
  end
  prob.Constraints.([name, '_max']) = GT_power_max;
  prob.Constraints.([name, '_min']) = GT_power_min;


 
  for g=1:n_GT
    M = GT_obj{g}.PowMax/GT_obj{g}.PowRated;
    z_help_cnstr(1:T,1:W,g)   = z_help(1:T,1:W,g) >= x_GT(g) - M*(1 - u_GT(1:T,1:W,g) );
    z_help_cnstr_1(1:T,1:W,g) = z_help(1:T,1:W,g) <= x_GT(g);
    z_help_cnstr_2(1:T,1:W,g) = z_help(1:T,1:W,g) <= M*u_GT(1:T,1:W,g);
  end
  prob.Constraints.([name, '_help_cstr'])   = z_help_cnstr;
  prob.Constraints.([name, '_help_cstr_1']) = z_help_cnstr_1;
  prob.Constraints.([name, '_help_cstr_2']) = z_help_cnstr_2;

  % for g=1:n_GT
  %   prob = lin_ContBin(prob, ['z_help_DG_', num2str(g)], z_help(:,:,g), x_GT(g), u_GT(:,:,g), 1, 0);
  % end

  


end