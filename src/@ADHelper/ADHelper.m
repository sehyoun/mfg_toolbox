classdef ADHelper < param_interface
  % Perturbation Helper
  %
  % Documentation is available at <https://sehyoun.com/Mean_Field_Games_Toolbox>
  %
  % by SeHyoun Ahn, Sept 2017
  %

  % LICENSE:
  %  Copyright 2017-2019 SeHyoun Ahn
  %  BSD 2-clause see <https://github.com/sehyoun/Mean_Field_Games_Toolbox>
  %

  properties
    var2ss = struct()
    var2ischoice = struct()
    var2isshock = struct()
    var2loc = struct()
    var2ss_aux = struct()

    var2advars = struct()
    shock2loc = struct()
    eqns

    n_vars
    n_choice
    n_choice_cached
    n_choice_red
    n_g
    n_g_cached
    n_g_red
    n_p
    n_pred

    n_obs = 0
    pade_freq = 0;

    arnoldi_cached_v = struct()
    arnoldi_cached_g = struct()

    n_arnoldi = 10;
    n_arnoldi_v = 10;

    is_cont_time = true

    state_reductions = []
    choice_reductions = []
    reduction_cell

    G1
    psi
    pi
    G1_cached
    psi_cached
    pi_cached

    impact
    eu
    F
    F_old
    ind_sparse_solver = false;

    krylov_bases_old

    reduction
    inv_reduction

    verbose = false;
  end
end
