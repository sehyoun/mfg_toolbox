function set_current_figure(obj, key)
  % A helper function to prevent MATLAB <figure> function from \
  % pulling focus.
  %
  % Args:
  %   key (double or string): key to the figure
  %
  % Returns:
  %   : nothing
  %
  % Example:
  %   This makes a random plot::
  %
  %     tmp = figHelper;
  %     tmp.fig_handle = tmp.set_current_figure(1);
  %     plot(randn(10,2));
  %
  %   However, for most uses, figHelper will be used as a \
  %   super-class using inheritance, so this example would not \
  %   be a typical use case.
  %
  % References:
  %   Via `answer on stackoverflow <https://stackoverflow.com/a/8489836>`_ \
  %   updated to use <`containers.Map <https://www.mathworks.com/help/matlab/ref/containers.map-class.html>`_>.
  %
  % Warning:
  %   Unfortunately, this function does not prevent <subplot> \
  %   function from pulling the focus. For subplot function, one \
  %   can call::
  %
  %     fig = gcf;
  %     set(fig,'CurrentAxes',fig.Children(i));
  %
  %   where :math:`i` is the proper location of the subplot in the \
  %   Children object of a figure. This crashes MATLAB rather \
  %   frequently and sporadically on my build, so I recommend \
  %   using multiple figures instead of using subplot command. \
  %   This function is only intended for diagnostic plots.
  %

  if isa(key,'double')
    if isKey(obj.fig_handle,jsonencode(key))
      try
        set(0,'CurrentFigure',obj.fig_handle(jsonencode(key)));
      catch
        obj.fig_handle(jsonencode(key)) = figure(key);
        obj.reset_loc(obj.fig_handle(jsonencode(key)), obj.fig_pos(jsonencode(key)));
      end
    else
      obj.fig_handle(jsonencode(key)) = figure(key);
      obj.fig_pos(jsonencode(key)) = obj.internal_counter;
      obj.internal_counter = obj.internal_counter+1;
      obj.reset_loc(obj.fig_handle(jsonencode(key)), obj.fig_pos(jsonencode(key)));
    end
  else
    if isKey(obj.fig_handle,key)
      try
        set(0,'CurrentFigure',obj.fig_handle(key));
      catch
        obj.fig_handle(key) = figure;
        obj.reset_loc(obj.fig_handle(key), obj.fig_pos(key));
      end
    else
      obj.fig_handle(key) = figure;
      obj.fig_pos(key) = obj.internal_counter;
      obj.internal_counter = obj.internal_counter+1;
      obj.reset_loc(obj.fig_handle(key), obj.fig_pos(key));
    end
  end
end
