function [G0, G1, psi, pi] = get_gensys_form(obj)
  % Convert the equations into the GENSYS form
  %
  % Args:
  %   eqns (in class): :attr:`eqns <ADHelper.eqns>`
  %
  % Returns:
  %   : [G0, G1, psi, pi]
  %
  %   .. math::
  %
  %     G0\cdot y_{t+1} = G1\cdot y_t + psi \cdot \eta_t + pi \cdot \varepsilon_t
  %
  %   Hence, the standard variable names for GENSYS.
  %

  n_dy = obj.n_choice + obj.n_pred;
  G0 = -obj.eqns(:, obj.n_vars+1 : obj.n_vars+n_dy);
  G1 = obj.eqns(:, 1:n_dy);
  pi = obj.eqns(:, n_dy+1:obj.n_vars);
  psi = spdiags(ones(obj.n_choice,1), 0, n_dy, obj.n_choice);
end
