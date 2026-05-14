% This function computes the consumed amount of fuel and the CO2 emitted

% Initialize variables to zero
CO2_emitted_DG = 0;
CO2_emitted_GT = 0;
fuel_consumption_DG = 0;
fuel_consumption_GT = 0;

if isfield(values_vector, 'P_DG') 
  [CO2_emitted_DG, fuel_consumption_DG] = CO2_emission(DG_obj, values_vector.P_DG,  values_vector.u_DG); % emission from all the DGs [kg] 

elseif isfield(values_vector, 'P_GT') 
  [CO2_emitted_GT, fuel_consumption_GT] = CO2_emission(GT_obj, values_vector.P_GT,  values_vector.u_GT); % emission from all the GTs [kg] 

end

CO2_emitted = CO2_emitted_DG + CO2_emitted_GT;
values_solution.CO2_emitted = CO2_emitted;
values_solution.CO2_emitted_DG = CO2_emitted_DG; 
values_solution.CO2_emitted_GT = CO2_emitted_GT; 

fuel_consumption = fuel_consumption_DG + fuel_consumption_GT;
values_solution.fuel_consumption = fuel_consumption;
values_solution.fuel_consumption_DG = fuel_consumption_DG;
values_solution.fuel_consumption_GT = fuel_consumption_GT;
