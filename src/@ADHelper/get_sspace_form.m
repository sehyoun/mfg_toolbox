function get_sspace_form(obj)
  % From derivatives, get the state-space representation
  %
  % Args:
  %   eqns (in class): :attr:`eqns <ADHelper.eqns>` derivative values from dynamics equations
  %
  % Returns:
  %   : [G1, psi, pi]
  %
  %   * :attr:`G1 <ADHelper.G1>`
  %   * :attr:`psi <ADHelper.psi>`
  %   * :attr:`pi <ADHelper.pi>`
  %
  % Note:
  %   Intuitively, it "inverts" G0 matrix. For usages, it does not hurt to treat it as a black-box, and most instances, one would not need to call this function directly.
  %
  % See also:
  %   - :func:`solve_perturbation <src.@ADHelper.solve_perturbation>`
  %   - :ref:`tutorial_pert_helper`
  %

  n_dy = obj.n_choice + obj.n_pred;
  G0 = -obj.eqns(:, obj.n_vars+1 : obj.n_vars+n_dy);
  G1 = obj.eqns(:, 1:n_dy);
  psi = obj.eqns(:, n_dy+1:obj.n_vars);
  % pi = spdiags(ones(obj.n_choice,1), 0, n_dy, obj.n_choice);

  [i, j, val] = find(G0);
  [permuter,~,permuter_vec] = obj.create_perm(j,n_dy);

  G0 = G0*permuter';
  G1 = G1*permuter';

  fields = fieldnames(obj.var2loc);
  for i = 1:numel(fields)
    if ~isfield(obj.var2isshock,fields{i}) || ~obj.var2isshock.(fields{i})
      obj.var2loc.(fields{i}) = permuter_vec(obj.var2loc.(fields{i}));
    end
  end

  [i, j, val] = find(G0);
  [permuter,n_dy] = obj.create_perm(i,n_dy);

  G0 = permuter*G0;
  G1 = permuter*G1;
  % pi = permuter*pi;
  psi = permuter*psi;

  % Build Inverse Matrix
  ix = (n_dy+1:obj.n_pred+obj.n_choice)';
  valx = ones(obj.n_pred+obj.n_choice-n_dy,1);
  [i,j,val] = find(G0);
  i = [i; ix];
  j = [j; ix];
  val = [val; valx];
  G0 = sparse(i,j,val);

  % Build State Space Form
  obj.G1 = G0\G1;
  obj.pi = spdiags(ones(obj.n_choice,1), 0, size(G0,1), obj.n_choice); % pi;
  obj.psi = G0\psi;

  obj.n_g = n_dy - obj.n_choice;
  obj.n_p = size(G0,1) - n_dy;
  obj.n_vars = obj.n_choice + obj.n_pred;
  clear obj.var2advars;
end
