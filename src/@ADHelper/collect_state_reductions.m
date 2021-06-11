function collect_state_reductions(obj)
  % INTERNAL FUNCTION
  %
  % Warning:
  %   You can not mix the struct-based reduction with krylov_reduction.
  %

  if isa(obj.state_reductions,'cell')
    i_del_total = [];
    j_del_total = [];
    for i = 1:length(obj.state_reductions)
      if isa(obj.state_reductions{i},'function_handle')
        obj.state_reductions{i}();
      elseif isa(obj.state_reductions{i},'struct')
        red = obj.state_reductions{i};
        n_red = size(red.mat,2);

        n_v = obj.n_choice;
        if isempty(obj.inv_reduction)
          obj.inv_reduction = speye(size(obj.G1,1));
          obj.reduction = speye(size(obj.G1,1));
        end

        [ii,j,~] = find(obj.inv_reduction(obj.var2loc.(red.pos),:));
        blowup = obj.inv_reduction(:, j)*red.mat;
        j_keep = j(1:n_red);
        j_del = j(n_red+1:end);
        % obj.inv_reduction(:,j_del) = [];
        % obj.inv_reduction(ii,j_keep) = red.mat;
        obj.inv_reduction(:,j_keep) = blowup;
        j_del_total = [j_del_total; j_del];

        [ii,j,~] = find(obj.reduction(:,obj.var2loc.(red.pos)));
        shrink = red.mat'*obj.reduction(ii, :);
        i_keep = ii(1:n_red);
        i_del = ii(n_red+1:end);
        % obj.reduction(i_del,:) = [];
        % obj.reduction(i_keep,j) = red.mat';

        obj.reduction(i_keep,:) = shrink;
        i_del_total = [i_del_total; i_del];

        % if i == 1
        %   obj.n_g_red = obj.n_g - size(red.mat,1) + n_red;
        % else
        %   obj.n_g_red = obj.n_g_red - size(red.mat,1) + n_red;
        % end
      end
    end
    if length(i_del_total) > 0
      obj.reduction(i_del_total, :) = [];
      obj.inv_reduction(:, j_del_total) = [];
      obj.n_g_red = obj.n_g - length(i_del_total);
    end
  end
end
