function [cTx, qTy_w] = cost_BESS(BAT, AF, x_IV, x_NIV, W)
  if ~isempty(BAT)
    % cost related to the BESS
  
    % 1st stage variable cost
    CAPEX_IV  = (BAT.C_CAPEX_E)*BAT.C_storage_u;
    OPEX_IV   = (BAT.C_OPEX_E)*BAT.C_storage_u;
    CAPEX_NIV = BAT.C_CAPEX_P*BAT.C_power_u;
    OPEX_NIV  = BAT.C_OPEX_P*BAT.C_power_u;
  
    cTx_IV_CAPEX  = CAPEX_IV * x_IV;
    cTx_NIV_CAPEX = CAPEX_NIV * x_NIV;
    cTx_IV_OPEX   = OPEX_IV * x_IV;
    cTx_NIV_OPEX  = OPEX_NIV * x_NIV;
    cTx_CAPEX = cTx_IV_CAPEX + cTx_NIV_CAPEX;
    cTx_OPEX  = cTx_IV_OPEX + cTx_NIV_OPEX;
  
    cTx = AF.CRF*cTx_CAPEX + AF.YtD*cTx_OPEX;
    
    % 2nd stage variable cost
    qTy_w = zeros(1, W);
  else
    cTx = 0;
    qTy_w = zeros(1, W);
  end
end