function set_var2loc(obj)
  % INTERNAL FUNCTION: Given the vector of positions, assign it locations
  %
  % Args:
  %   var2ss (in class): :attr:`var2ss <ADHelper.var2ss>`
  %
  % Returns:
  %   : (in class)
  %
  %   - :attr:`var2loc <ADHelper.var2loc>`
  %
  % Note:
  %   This function puts variables in a nice order so that less reorganization is required, but users can just consider this as a blackbox.
  %

  fields = fieldnames(obj.var2ss);
  obj.var2loc = struct();
  n_choice = 0;
  n_pred = 0;
  n_shock = 0;
  for i = 1:numel(fields)
    fieldname = fields{i};
    if isfield(obj.var2ischoice,fieldname) && obj.var2ischoice.(fieldname)
      n_choice_old = n_choice + 1;
      n_choice = n_choice + length(getfield(obj.var2ss,fieldname));
      obj.var2loc.(fieldname) = n_choice_old:n_choice;
    elseif ~isfield(obj.var2isshock,fieldname) || ~obj.var2isshock.(fieldname)
      n_pred_old = n_pred + 1;
      n_pred = n_pred + length(getfield(obj.var2ss,fieldname));
      obj.var2loc.(fieldname) = n_pred_old:n_pred;
    else
      n_shock_old = n_shock + 1;
      n_shock = n_shock + length(getfield(obj.var2ss,fieldname));
      obj.var2loc.(fieldname) = n_shock_old:n_shock;
      obj.shock2loc.(fieldname) = n_shock_old:n_shock;
    end
  end
  obj.n_choice = n_choice;
  obj.n_pred = n_pred;
  obj.n_vars = n_choice + n_pred + n_shock;
  for i = 1:numel(fields)
    fieldname = fields{i};
    if isfield(obj.var2isshock,fieldname) && obj.var2isshock.(fieldname)
      obj.var2loc.(fieldname) = obj.var2loc.(fieldname) + n_choice + n_pred;
    elseif ~isfield(obj.var2ischoice,fieldname) || ~obj.var2ischoice.(fieldname)
      obj.var2loc.(fieldname) = obj.var2loc.(fieldname) + n_choice;
    end
  end

  % fields = fieldnames(obj.var2loc);
  % obj.loc2var = cell(obj.n_vars, 1);
  % for iter = 1:length(fields)
  %   field = fields{iter};
  %   iterable = obj.var2loc.(field);
  %   if length(iterable) > 1
  %     for inner_iter = 1:length(iterable)
  %       obj.loc2var{inner_iter} = field;
  %     end
  %   else
  %     obj.loc2var{iterable} = field;
  %   end
  % end
end
