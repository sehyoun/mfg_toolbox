function [permuter_mat,n,permuter_vec] = create_perm(obj,j,n)
  % INTERNAL FUNCTION: Creates a permutation matrix reordering matrix
  %

  loc_dy = sort(unique(j));

  aux = ones(n, 1);
  aux(loc_dy) = 0;
  loc_ndy = find(aux);

  if length(loc_ndy) > 0
    permuter_mat = sparse(1:n, [loc_dy;loc_ndy], ones(n,1));

    if nargout == 3
      permuter_vec = zeros(n,1);
      permuter_vec([loc_dy;loc_ndy]) = (1:n)';
    end

    n = length(loc_dy);
  else
    permuter_mat = speye(n);
    permuter_vec = (1:n)';
  end
end
