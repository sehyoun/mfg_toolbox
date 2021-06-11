function set_var2advars_dvars(obj)
  % INTERNAL FUNCTION: Initialize automatic differentiation
  %
  % Args:
  %   var2ss (in class): :attr:`var2ss <ADHelper.var2ss>`
  %   var2loc (in class): :attr:`var2loc <ADHelper.var2loc>`
  %
  % Returns:
  %   : (set in class)
  %
  %   - :attr:`var2advars <ADHelper.var2advars>`
  %
  % See also:
  %   - :func:`set_var2loc <src.@ADHelper.set_var2loc>`
  %   - `https://github.com/sehyoun/MATLABAutoDiff <https://github.com/sehyoun/MATLABAutoDiff>`_
  %
  % References:
  %  * :cite:`autodiffblog`
  %

  obj.set_var2loc();
  aux = zeros(2*obj.n_vars,1);
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
    obj.var2advars.(strcat('d',fieldname)) = vars(obj.n_vars+loc,1);
  end
  % obj.advars = vars;
end
