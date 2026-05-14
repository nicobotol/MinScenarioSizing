% Upper bound of the number of REC
switch case_constraint
  case {'GT24', 'GT365'}
    
  case {'1GT+WT+DG', '2GT+WT+DG', 'WT+DG'}
    M(1) = floor(REC.WT.max_installed_power / REC.WT.PowRated);
    
  case {'1GT+REC+DG', '2GT+REC+DG', 'GT+REC+DG', 'REC-U', 'REC-U+DG', 'REC-C+DG24', 'REC-C+DG365', 'DG+REC24', 'DG+REC365'}
    M(1) = floor(REC.PV.max_installed_power / REC.PV.PowRated);
    M(2) = floor(REC.WT.max_installed_power / REC.WT.PowRated);
    M(3) = floor(REC.WEC.max_installed_power / REC.WEC.PowRated);
   
  otherwise
    error('Case not defined yet')
end

% x = [N_PV, N_WT, N_WEC]
x_REC = optimvar('x_REC', [num_REC,1], 'lowerBound', zeros(num_REC, 1), 'Type', 'integer', 'UpperBound', M);
      
P_res = optimvar('P_res', [T, W], 'lowerBound', [0], 'Type', 'continuous');

switch case_constraint
  case {'DG-PV-WT'}
    % x0.x_REC = [25,1]';
    x0.x_REC = [floor(REC.PV.max_installed_power/REC.PV.PowRated);
                floor(REC.WT.max_installed_power/REC.WT.PowRated)];
    x0.P_res = zeros([T, W]);
    
  case {'DG30-PV-WT'}
    % x0.x_REC =  [27,1]';
    % x0.P_res = zeros([T, W]);

  case {'PV-WT-HY-HS'}
    x0.x_REC = [4, 0, 1]';
    x0.P_res = zeros([T, W]);

  case {'DG-PV-WT-HS'}
    x0.x_REC = [26, 0, 0]';
    x0.P_res = zeros([T, W]);
      
  otherwise
    x0.x_REC = ones([num_REC,1]);
    x0.P_res = zeros([T, W]);

end




