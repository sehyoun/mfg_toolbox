function set_var2advars(obj)
  % Set the location of derivative variables
  %

  obj.set_var2loc();
  aux = zeros(obj.n_vars,1);
  fields = fieldnames(obj.var2loc);
  for i = 1:numel(fields)
    aux(obj.var2loc.(fields{i}),1) = obj.var2ss.(fields{i});
  end
  vars = myAD(aux);
  obj.var2advars = struct();
  for i = 1:numel(fields)
    fieldname = fields{i};
    loc = obj.var2loc.(fieldname);
    obj.var2advars.(fieldname) = vars(loc,1);
  end
  % obj.advars = vars;
end
