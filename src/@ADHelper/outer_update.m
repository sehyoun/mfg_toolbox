function [output] = outer_update(obj, use_old_basis)
  % Outer loop idea on page 25 of :cite:`reiter2010approximate`.
  %
  % Warning:
  %   As noted by Reiter, there is no convergence proof of this idea. Use this function carefully.
  %
  % References:
  %   * :cite:`reiter2010approximate`
  %

  if nargin < 2
    use_old_basis = false;
  end

  aux = obj.reduction(obj.n_choice_red+1:end,obj.n_choice_red+1:obj.n_choice_red+obj.n_g_cached);
  aux3 = obj.reduction(1:obj.n_choice,1:obj.n_choice_cached);
  F = @(x) aux'*(obj.F'*(aux3*x));

  obj.read_from_cache();
  obj.reduction = [];
  obj.inv_reduction = [];
  if isempty(obj.krylov_bases_old) & use_old_basis
    obj.krylov_reduction([],F,obj.krylov_bases_old);
  else
    obj.krylov_reduction([],F);
  end

  aux1 = obj.reduction(obj.n_choice+1:end,obj.n_choice+1:obj.n_choice+obj.n_g_cached);
  aux2 = aux1' - aux'*(aux*aux1');
  output = sqrt(full(max(diag(aux2'*aux2))));

  obj.collect_choice_reductions();

  obj.apply_reduction();
  obj.schur_solver();
end
