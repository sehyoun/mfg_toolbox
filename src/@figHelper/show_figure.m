function show_figure(obj,key)
  % Bring focus to the figure
  %
  % Args:
  %   key (double or string): key to the figure
  %
  % Returns:
  %   : nothing
  %
  % Example:
  %   This example creates a random plot and pulls focus to it::
  %
  %     tmp = figHelper;
  %     tmp.fig_handle = tmp.set_current_figure(1);
  %     plot(randn(10,2));
  %     obj.show_figure(1);
  %
  %   However, for most uses, figHelper will be used as a \
  %   super-class using inheritance, so this example would not \
  %   be a typical use case. See <XXXXXX >.
  %
  % Note:
  %   The behavior should be the same as calling ``figure(n);``
  %

  if isa(key,'double')
    figure(obj.fig_handle(jsonencode(key)));
  else
    figure(obj.fig_handle(key));
  end
end
