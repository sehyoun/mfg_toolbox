function read_from_cache(obj)
  % EXPERIMENTAL
  %

  obj.n_choice = obj.n_choice_cached;
  obj.n_g = obj.n_g_cached;
  obj.G1 = obj.G1_cached;
  obj.psi = obj.psi_cached;
  obj.pi = obj.pi_cached;
end
