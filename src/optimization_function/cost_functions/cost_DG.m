function [cTx, qTy_w] = cost_DG(DG_obj, case_constraint, AF, n_DG, P_DG, x_DG, u_DG, alpha_pla, y_help_DG, T, W)
  % cost related to the Diesel generators
  if n_DG > 1
    error('More than one DG is not implemented yet')
  end

  % 1st stage variable cost
  c = zeros(n_DG, 1);

  for r = 1:n_DG
    c(r) = (AF.CRF*DG_obj{r}.C_I_unitary + AF.YtD*DG_obj{r}.OPEX)*DG_obj{r}.PowRated;
  end
  
  % 2nd stage variable cost

  % linear model
  for g = 1:n_DG
    qTg = [DG_obj{g}.C_per_watt*ones(T, 1); DG_obj{g}.C_on*ones(T, 1)]';
    y_G(1,1:W,g)  = qTg*[P_DG(:,:,g);u_DG(:,:,g)];
  end

  % % Piecewise linear approximation
  % for r = 1:n_DG
  %   qTg = repmat(reshape(DG_obj{r}.C_F*DG_obj{r}.PwrCostF', 1, 1, []), T, W, 1);
  %   y_G = sum(alpha_pla.*qTg , 1);
  % end


  cTx = c'*x_DG;
  % qTy_w = sum(y_G(:, :, 2:end), 3) + sum(y_help_DG, 1); 
  qTy_w = sum(y_G, 3); 
end
