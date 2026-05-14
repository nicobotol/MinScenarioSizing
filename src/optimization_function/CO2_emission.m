function [CO2_emitted, fuel_consumption] = CO2_emission(objData, P, u)

  n_GT = size(objData, 1);
  
  for g = 1:n_GT
    mu = objData{g}.mu; % ideal combustion coefficient of fuel
    alpha_g = objData{g}.alpha_g; % coeff for estimating modeling fuel consumption [kg/W]
    beta_g = objData{g}.beta_g; % coeff for estimating modeling fuel consumption [kg/h]

    CO2_emitted_g(g) = mu*sum(alpha_g*P(:,:,g) + beta_g*u(:,:,g));

    FC_g(g) = sum((alpha_g*P(:,:,g) + beta_g*u(:,:,g))/objData{g}.rho); % fuel consumption [l]

  
    % x = objData{g}.PwrCostX; % [kW]
    % y = objData{g}.PwrCostF; % [l]
    % FC_g = sum(interp1(x, y, P(:,:,g)));
    % CO2_emitted_g(g) = mu*FC_g;
      
  end 

  CO2_emitted = sum(CO2_emitted_g);
  fuel_consumption = FC_g;
end