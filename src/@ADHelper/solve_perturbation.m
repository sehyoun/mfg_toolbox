function solve_perturbation(obj)
  % Solves perturbation solution
  %
  % Args:
  %   setup_eqns (in class): :attr:`setup_eqns <ADHelper.setup_eqns>`
  %   var2ss (in class): :attr:`var2ss <ADHelper.var2ss>`
  %   var2ischoice (in class): :attr:`var2ischoice <ADHelper.var2ischoice>`
  %   var2isshock (in class): :attr:`var2isshock <ADHelper.var2isshock>`
  %   state_reductions (in class): :attr:`state_reductions <ADHelper.state_reductions>`
  %   choice_reductions (in class): :attr:`choice_reductions <ADHelper.choice_reductions>`
  %
  % Returns:
  %   : (in class)
  %
  %   - :attr:`G1 <ADHelper.G1>`
  %   - :attr:`impact <ADHelper.impact>`
  %
  % Example:
  %   This function contains many things. Refer to the :ref:`tutorial_pert_helper` .
  %

  obj.set_var2loc();
  obj.set_var2advars_dvars();

  obj.setup_eqns();
  obj.get_sspace_form();
  obj.QR_cleanup();

  if isa(obj.state_reductions,'cell')
    disp('Applying State Reductions');
    if isa(obj.choice_reductions,'cell')
      obj.collect_choice_reductions();
    end
    obj.collect_state_reductions();
    obj.apply_reduction();
    disp('done..');
  elseif isa(obj.choice_reductions,'cell')
    disp('Applying Choice Reduction');
    obj.collect_choice_reductions();
    obj.apply_reduction();
    disp('done..')
  else
    obj.blank_reduction();
  end

  if obj.ind_sparse_solver
    disp('Solving linear system..')
    tic;
    [G1, impact, reduction] = sparse_solver(obj.G1,obj.psi,obj.n_choice,obj.n_g);
    toc;
    obj.G1 = real(G1);
    obj.impact = real(impact);
    obj.inv_reduction = obj.inv_reduction*real(reduction);
    disp('done..')
  else
    disp('Solving linear systems..')
    obj.schur_solver();
  end
end
