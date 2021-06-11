function reset_loc(obj, fig_handle, pos)
  % INTERNAL FUNCTION: reset figure location
  %
  % Args:
  %   - fig_handle (figure handle): figure to relocate
  %   - pos (int): position number of the figure
  %

  pos = mod(pos-1, obj.n_col*obj.n_row) + 1;
  set(gcf, ...
    'outerposition',[obj.start_col + (mod(pos-1,obj.n_col))*obj.plot_width + 1, ...
        obj.start_row - 1 + (obj.n_row-1-floor((pos-1)/obj.n_col))*obj.plot_height+1, ...
        obj.plot_width, ...
        obj.plot_height]); %, ...
    % );
    % 'MenuBar', 'None');
end
