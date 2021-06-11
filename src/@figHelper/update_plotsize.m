function update_plotsize(obj)
  % Update width and height of plots
  %
  % Args:
  %   end_col (int): :attr:`end_col <figHelper.end_col>`
  %   start_col (int): :attr:`start_col <figHelper.start_col>`
  %   start_row (int): :attr:`start_row <figHelper.start_row>`
  %   end_row (int): :attr:`end_row <figHelper.end_row>`
  %   n_col (int): :attr:`n_col <figHelper.n_col>`
  %   n_row (int): :attr:`n_row <figHelper.n_row>`
  %

  obj.plot_width = floor((obj.end_col - obj.start_col + 1)/obj.n_col);
  obj.plot_height = floor((obj.end_row - obj.start_row + 1)/obj.n_row);
end
