function [opt_parameters] = set_max_time(loop_type_1, opt_parameters, scenario)
  % This function sets the optimization tollerance based on the simulation case
  
  % switch case_sim
  %   case {'1GT+REC+DG'}
  %     opt_parameters.rel_gap_tol = 1.4e-2;
  %   case {'1GT+WT+DG'}
  %     opt_parameters.rel_gap_tol = 1.4e-2;
  %   otherwise
  %     opt_parameters.rel_gap_tol = 5e-3;
  % end

  W = scenario.W;

  % opt_parameters.rel_gap_tol = 5e-3;
  if  strcmp(loop_type_1, 'scenario_num')
    if W <= 50
      max_time =  70*60;
      % max_time =3 15;
    elseif W > 50 && W <= 70
      max_time = 80*60;
    elseif W > 70 && W <= 90
      max_time = 80*60;
    elseif W > 90 && W <= 130
      max_time = 80*60;
    else 
      max_time = 80*60;
    end

    max_time = 3*3600;
    
  elseif strcmp(loop_type_1, 'scenario_len')
    max_time = 3800;

  elseif strcmp(loop_type_1, 'None')
    max_time = 7*3600;

  else
    error('Case not defined yet')

  end

  opt_parameters.max_time = max_time;
end