function schur_solver(obj)
  % Solver based on Schur decomposition.
  %
  % .. note::
  %
  %   This is based on Sims's gensys, but uses pre-clean+ `Schur decomposition <https://en.wikipedia.org/wiki/Schur_decomposition>`_ rather than taking the `QZ-decomposition <https://en.wikipedia.org/wiki/Schur_decomposition#Generalized_Schur_decomposition>`_  directly. QZ-decomposition scales worse with dimensionality of the problem.
  %
  % Args:
  %   G1 (in class): :attr:`G1 <ADHelper.G1>`
  %   psi (in class): :attr:`psi <ADHelper.psi>`
  %   pi (in class): :attr:`pi <ADHelper.pi>`
  %   n_choie (in class): :attr:`n_choice <ADHelper.n_choice>`
  %
  % Returns:
  %   : (in class)
  %
  %   - :attr:`G1 <ADHelper.G1>`
  %   - :attr:`impact <ADHelper.impact>`
  %   - :attr:`F <ADHelper.F>`
  %
  % Warning:
  %   This class is written because users do not have to worry about setting the inputs to this function. Hence, make sure to check other functions (or :ref:`tutorial_pert_helper` ).
  %

  % .. by SeHyoun Ahn, Dec 2016
  % .. updated by SeHyoun Ahn, Nov 2017
  %
  % .. LICENSE:
  % ..  Copyright (c) 2017 SeHyoun Ahn
  % ..  BSD 2-clause: see <https://github.com/sehyoun/Mean_Field_Games_Toolbox>
  %
  % ..   This adjusts the function/code available `here <https://github.com/gregkaplan/phact>`_ licensed under BSD 2-clause:
  % ..   Copyright (c) 2017 SeHyoun Ahn, Greg Kaplan, Benjamin Moll, Thomas Winberry, and Christian Wolf.
  %

  g1 = obj.G1;
  fprintf('problem size %d %d\n',size(g1));
  realsmall = sqrt(eps)*10;
  obj.eu = [-5;-5];
  n = size(g1,1);
  n_v = obj.n_choice;
  psi = obj.psi;
  pi = obj.pi;

  %% Schur Decomposition
  [U,T] = schur(full(g1),'real');
  if obj.is_cont_time
    g_eigs = real(ordeig(T));
    nunstab = sum(g_eigs>0);
    [aux,ind] = sort(g_eigs,'descend');
    locs = ones(n,1);
    locs(ind(1:n_v)) = 0;
    [U,T] = ordschur(U,T,locs);
    if nunstab > n_v
      warning('<schur_solver>: There are more than n_v number of positive eigenvalues with smallest values:');
      disp(aux(n_v+1:nunstab));
    elseif nunstab < n_v
        warning('<schur_solver>: There are less than n_v number of positive eigenvalues:');
        disp(aux(nunstab+1:n_v));
    end
    nunstab = n_v;
  else
    g_eigs = abs(ordeig(T));
    nunstab = sum(g_eigs>1);
    [aux,ind] = sort(g_eigs,'descend');
    locs = ones(n,1);
    locs(ind(1:n_v)) = 0;
    [U,T] = ordschur(U,T,locs);
    if nunstab > n_v
      warning('<schur_solver>: There are more than n_v number of positive eigenvalues with smallest values:');
      disp(aux(n_v+1:nunstab));
    elseif nunstab < n_v
      warning('<schur_solver>: There are less than n_v number of positive eigenvalues:');
      disp(aux(nunstab+1:n_v));
    end
    nunstab = n_v;
  end

  u1 = U(:,1:n-nunstab)';
  u2 = U(:,n-nunstab+1:n)';

  etawt = u2*pi;
  [ueta,deta,veta] = svd(etawt,'econ');
  md = min(size(deta));
  bigev = find(diag(deta(1:md,1:md))>realsmall);
  ueta = ueta(:,bigev);
  veta = veta(:,bigev);
  deta = deta(bigev,bigev);

  zwt = u2*psi;
  [uz,dz,vz] = svd(zwt,'econ');
  md = min(size(dz));
  bigev = find(diag(dz(1:md,1:md))>realsmall);
  uz = uz(:,bigev);
  vz = vz(:,bigev);
  dz = dz(bigev,bigev);

  if isempty(bigev)
    obj.eu(1) = 1;
  else
    obj.eu(1) = (norm(uz-ueta*ueta'*uz,'fro') < realsmall*n);
  end
  impact = real(-pi*veta*(deta\ueta')*uz*dz*vz'+psi);

  G1 = U*T*spdiags([ones(n-nunstab,1);zeros(nunstab,1)],0,n,n)*U';
  obj.G1 = real(G1);

  [~,deta1,veta1] = svd(u1*pi);
  md = min(size(deta1));
  bigev = find(diag(deta1(1:md,1:md))>realsmall);
  veta1 = veta1(:,bigev);
  if isempty(veta1)
    obj.eu(2) = 1;
  else
    obj.eu(2) = norm(veta1-veta*veta'*veta1,'fro') < realsmall*n;
  end
  obj.F = u1(:,1:nunstab)'*inv(u1(:,nunstab+1:end)');
  obj.impact = impact;
  % obj.impact = [obj.F*psi(nunstab+1:end,:);psi(nunstab+1:end,:)];
end