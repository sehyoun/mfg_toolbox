function krylov_reduction(obj, varargin)
  % Reduces the dimensionality of the state space using Krylov subspace method
  %
  % Args:
  %   G1 (in class): :attr:`G1 <ADHelper.G1>`
  %   n_choice (in class): :attr:`n_choice <ADHelper.n_choice>`
  %   n_g (in class): :attr:`n_g <ADHelper.n_g>`
  %   n_p (in class): :attr:`n_p <ADHelper.n_p>`
  %   n_arnoldi (in class): :attr:`n_arnoldi <ADHelper.n_arnoldi>`
  %
  % Returns:
  %   : (in class)
  %
  %   - :attr:`reduction <ADHelper.reduction>`
  %   - :attr:`inv_reduction <ADHelper.inv_reduction>`
  %   - :attr:`n_g_red <ADHelper.n_g_red>`
  %   - :attr:`n_choice_red <ADHelper.n_choice_red>`
  %
  % Note:
  %   This helper is written so that one would not have to worry about the consistency of the inputs for complex functions. Check out other functions and tutorials.
  %
  % See also:
  %   - :func:`solve_perturbation <src.@ADHelper.solve_perturbation>`
  %   - :ref:`tutorial_pert_helper`
  %
  % References:
  %  * :cite:`ahn2017inequality`
  %

  % .. by SeHyoun Ahn, Sept 2016
  % .. updated by SeHyoun Ahn, Nov 2017
  %
  % .. LICENSE:
  %
  % ..   This adjusts the function/code available at `github <https://github.com/gregkaplan/phact>`_ licensed under BSD 2-clause:
  % ..   Copyright (c) 2017 SeHyoun Ahn, Greg Kaplan, Benjamin Moll, Thomas Winberry, and Christian Wolf.
  %
  % ..   This edited file is available as BSD 2 clause
  % ..   Copyright (c) 2017 SeHyoun Ahn
  %

  switch nargin
    case 1
      observable = [];
      F = [];
      prebase = [];
    case 2
      observable = varargin{1};
      F = [];
      prebase = [];
    case 3
      observable = varargin{1};
      F = varargin{2};
      prebase = [];
    case 4
      observable = varargin{1};
      F = varargin{2};
      prebase = varargin{3};
    otherwise
      error('Not supported: check that function is called properly')
  end

  n_v = obj.n_choice;
  n_g = obj.n_g;
  n_p = obj.n_p;
  n_total = n_v + n_g;
  n_Z = 0;

  B_pv = -obj.G1(n_total+1:n_total+n_p,n_total+1:n_total+n_p)\obj.G1(n_total+1:n_total+n_p,1:n_v);
  B_pg = -obj.G1(n_total+1:n_total+n_p,n_total+1:n_total+n_p)\obj.G1(n_total+1:n_total+n_p,n_v+1:n_v+n_g);
  B_pZ = -obj.G1(n_total+1:n_total+n_p,n_total+1:n_total+n_p)\obj.G1(n_total+1:n_total+n_p,n_v+n_g+1:n_v+n_g+n_Z);
  B_gg = obj.G1(n_v+1:n_v+n_g,n_v+1:n_v+n_g);
  B_gv = obj.G1(n_v+1:n_v+n_g,1:n_v);
  B_gp = obj.G1(n_v+1:n_v+n_g,n_total+1:n_total+n_p);
  B_vp = obj.G1(1:n_v,n_total+1:n_total+n_p);

  if isa(F,'function_handle')
    B_pg_obs = F(B_pv')' + B_pg;
  elseif F
    B_pg_obs = B_pv*F + B_pg;
  else
    B_pg_obs = B_pg;
  end
  obs = [B_pg_obs;observable];

  % % V_g = mgs(obs'); % XXX
  % [V_g, ~] = qr(obs', 0); % XXX

  % Compute Krylov Subspace
  if isa(F,'function_handle')
    A = @(x) F(B_gv'*x + B_pv'*(B_gp'*x))+B_gg'*x + B_pg'*(B_gp'*x);
  elseif F
    A = @(x) F'*(B_gv'*x + B_pv'*(B_gp'*x))+B_gg'*x + B_pg'*(B_gp'*x);
  else
    A = @(x) B_gg'*x + B_pg'*(B_gp'*x);
  end

  % [V_g,~] = deflated_block_arnoldi(A,V_g,obj.n_arnoldi, [], V_g); % XXX
  % n_g_red = size(V_g,2);

  if isempty(prebase)
    % V_g = mgs(obs');
    % [V_g, ~] = qr(obs', 0);
    tmp = zeros(3, size(obs, 2));
    tmp(1, end) = 1;
    tmp(2, end-1) = 1;
    tmp(3, end-2) = 1;
    obs = [tmp; obs];
    V_g = obs';

    [V_g,~] = deflated_block_arnoldi(A,V_g,obj.n_arnoldi, [], V_g);
  else
    V_g = obs';
    n_pre = size(prebase, 2);
    bases = mgs([prebase, V_g]);
    if size(bases, 2) < n_pre
      V_g = bases;
    else
      V_g = bases(:, n_pre+1:end);
      [V_g,~] = deflated_block_arnoldi(A,V_g,obj.n_arnoldi, bases(:, 1:n_pre), V_g);
    end
  end
  n_g_red = size(V_g,2);
  obj.krylov_bases_old = V_g;

  % Build State-Space Reduction transform
  state_red = sparse(n_v+n_g_red,n_total+n_p);
  state_red(1:n_v,1:n_v) = speye(n_v);
  state_red(n_v+1:n_v+n_g_red,n_v+1:n_v+n_g) = V_g';
  state_red(n_v+n_g_red+1:n_v+n_g_red+n_Z,n_v+n_g+1:n_v+n_g+n_Z) = speye(n_Z);
  %state_red(:,n_total+1:n_total+n_p) = 0;

  % Build inverse transform
  inv_state_red = sparse(n_total+n_p,n_v+n_g_red);
  inv_state_red(1:n_v,1:n_v) = speye(n_v);
  inv_state_red(n_v+1:n_v+n_g,n_v+1:n_g_red+n_v) = V_g;
  inv_state_red(n_total+1:n_total+n_p,1:n_v) = B_pv;
  inv_state_red(n_total+1:n_total+n_p,n_v+1:n_v+n_g_red) = B_pg*V_g;
  inv_state_red(n_total+1:n_total+n_p,n_v+n_g_red+1:n_v+n_g_red+n_Z) = B_pZ;
  inv_state_red(n_v+n_g+1:n_total,n_v+n_g_red+1:n_v+n_g_red+n_Z) = speye(n_Z);

  if isempty(obj.reduction)
    obj.reduction = state_red;
    obj.inv_reduction = inv_state_red;
  else
    obj.reduction = state_red*obj.reduction;
    obj.inv_reduction = obj.inv_reduction*inv_state_red;
  end
  obj.n_g_red = n_g_red;
  obj.n_choice_red = obj.n_choice;
end
