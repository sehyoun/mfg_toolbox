function collect_choice_reductions(obj)
  % INTERNAL FUNCTION
  %

  if isa(obj.choice_reductions,'cell')
    i_del_total = [];
    j_del_total = [];
    for i = 1:length(obj.choice_reductions)
      if isa(obj.choice_reductions{i},'function_handle')
        obj.choice_reductions{i}();
      elseif isa(obj.choice_reductions{i},'struct')

        if isempty(obj.reduction)
          obj.reduction = speye(size(obj.G1,1));
          obj.inv_reduction = speye(size(obj.G1,1));
        end
        red = obj.choice_reductions{i};
        n_red = size(red.mat,2);

        [ii,j,~] = find(obj.inv_reduction(obj.var2loc.(red.pos),:));
        blowup = obj.inv_reduction(:, j)*red.mat;
        j_keep = j(1:n_red);
        j_del = j(n_red+1:end);
        % obj.inv_reduction(:,j_del) = [];
        obj.inv_reduction(:,j_keep) = blowup;
        j_del_total = [j_del_total; j_del];

        [ii,j,~] = find(obj.reduction(:,obj.var2loc.(red.pos)));
        shrink = red.mat'*obj.reduction(ii,:);
        i_keep = ii(1:n_red);
        i_del = ii(n_red+1:end);
        % obj.reduction(i_del,:) = [];
        % obj.reduction(i_keep,j) = red.mat';
        obj.reduction(i_keep,:) = shrink;
        i_del_total = [i_del_total; i_del];

        % if i == 1
        %   obj.n_choice_red = obj.n_choice - size(red.mat,1) + n_red;
        % else
        %   obj.n_choice_red = obj.n_choice_red - size(red.mat,1) + n_red;
        % end
      end
    end

    if length(i_del_total) > 0
      obj.reduction(i_del_total, :) = [];
      obj.inv_reduction(:, j_del_total) = [];
      obj.n_choice_red = obj.n_choice - length(i_del_total);
    end
  end
end
