function prob = max_power(prob, name, value, bound)

  if ~isa(value, 'double')
    % generic upper bound
    prob.Constraints.(name) = value <= bound;
  end
end