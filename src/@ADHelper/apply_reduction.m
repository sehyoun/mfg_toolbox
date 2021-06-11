function apply_reduction(obj)
  % INTERNAL FUNCTION
  %

  obj.cache_equations();

  obj.prep_reduction();

  obj.n_choice = obj.n_choice_red;
  obj.n_g = obj.n_g_red;
  obj.G1 = obj.reduction*(obj.G1*obj.inv_reduction);
  % obj.pi = obj.reduction*obj.pi;
  ind = find(max(abs(obj.reduction*obj.pi), [], 2) > 0);
  obj.pi = sparse(ind, ...
                  (1:length(ind))', ...
                  ones(length(ind),1), ...
                  size(obj.reduction,1), ...
                  length(ind));
  obj.psi = obj.reduction*obj.psi;
end
