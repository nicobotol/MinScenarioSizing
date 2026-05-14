% % Generate the scenarios

% if enable_parallel_computing == 0
%   [coords_N,points_N,ResselScens_N,LselScens_N,LscensProbVec_N,MapData_N]=KantorMapND(cellScenGenSetRes, scenGenSetLoad, scenario.InScenNum, rngSeed + seedIncremet);
  
% elseif enable_parallel_computing == 1
%   % start the parallel pool if not already started
%   [coords_N,points_N,ResselScens_N,LselScens_N,LscensProbVec_N,MapData_N]=KantorMapND_par(cellScenGenSetRes, scenGenSetLoad, scenario.InScenNum, rngSeed + seedIncremet);
  
% end


% % if sum(all(WT.Power < 1e1, 1)) > 0
% %   WT.Power(:, all(WT.Power < 1e1, 1)) = 1e1*ones(scenario.T, sum(all(WT.Power < 1e1, 1)));
% % end


% load_scenarios.iniVec = LselScens_N;
% load_scenarios.iniVec(load_scenarios.iniVec <= load_scenarios.NS_fraction*load_scenarios.P_rated) = load_scenarios.NS_fraction*load_scenarios.P_rated; 


function [ResselScens_N, load_copy, LscensProbVec_N] = generate_scenarios(cellScenGenSetRes, scenGenSetLoad, load_scenarios, scenario, rngSeed, enable_parallel_computing)

  % Generate the scenarios
  if enable_parallel_computing == 0
    [coords_N,points_N,ResselScens_N,LselScens_N,LscensProbVec_N,MapData_N]=KantorMapND(cellScenGenSetRes, scenGenSetLoad, scenario.InScenNum, rngSeed);
    
  elseif enable_parallel_computing == 1
    % start the parallel pool if not already started
    [coords_N,points_N,ResselScens_N,LselScens_N,LscensProbVec_N,MapData_N]=KantorMapND_par(cellScenGenSetRes, scenGenSetLoad, scenario.InScenNum, rngSeed);
    
  end

  % if sum(all(WT.Power < 1e1, 1)) > 0
  %   WT.Power(:, all(WT.Power < 1e1, 1)) = 1e1*ones(scenario.T, sum(all(WT.Power < 1e1, 1)));
  % end
    
  load_copy = copy(load_scenarios);
  load_copy.iniVec = LselScens_N;
  load_copy.iniVec(load_copy.iniVec <= load_copy.NS_fraction*load_copy.P_rated) = load_copy.NS_fraction*load_copy.P_rated; 

end

