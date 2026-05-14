function [n_cont, n_int, n_bin] = compute_variable_number(prob)

  var_names = fieldnames(prob.Variables);
  var_num = length(var_names);
  n_int = 0;
  n_bin = 0;
  n_cont = 0;

  for i=1:var_num
  
    [n_row, n_col] = size(prob.Variables.(var_names{i}));
    n_var = n_row*n_col;

    switch prob.Variables.(var_names{i}).Type 
      case 'continuous'
        n_cont = n_cont + n_var;
      case 'integer'
        if any(~ prob.Variables.(var_names{i}).LowerBound, 'all') && any(~ (prob.Variables.(var_names{i}).UpperBound - 1), 'all')
          n_bin = n_bin + n_var;
        else
          n_int = n_int + n_var;
        end
      otherwise
        error('Variable type not defined yet')
    end
  
  end

  % presolve the model ()
  % 
  % m = prob2struct(prob);
  % 
  % model.A = sparse([m.Aineq; m.Aeq]);
  % model.obj = m.f;
  % 
  % model.rhs = [m.bineq; m.beq];
  % 
  % model.sense = [repmat('<',size(m.Aineq,1),1);
  %                repmat('=',size(m.Aeq,1),1)];
  % 
  % model.lb = m.lb;
  % model.ub = m.ub;
  % 
  % prob_presolved = gurobi_presolve(model);
  % 
  % n_cont_p = sum(prob_presolved.vtype=='C'); 
  % n_int_p = sum(prob_presolved.vtype=='I');
  % n_bin_p = sum(prob_presolved.vtype=='B');


end
