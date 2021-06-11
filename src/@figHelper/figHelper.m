classdef figHelper < handle
  % By default, matlab's figure command pulls the focus to the newly called \
  % figure. This makes working with diagnostic plots without locking down \
  % the computer impossible. This function is made so that creating \
  % diagnotic plots are possible without stealing focus away.
  %

  % by SeHyoun Ahn, Dec 2017
  %
  % License:
  %  Copyright 2017-2019 SeHyoun Ahn
  %  BSD 2-clause see <https://github.com/sehyoun/MFG_solver>
  %
  properties
    fig_handle = containers.Map  % containers.Map for figure handles
    fig_pos = containers.Map  % containers.Map for figure locations

    n_row = 4  % number of rows
    n_col = 4  % number of columns
    screensize  % screensize

    internal_counter = 1;  % location counter to be incremented

    start_col = 1;  % left end of plotting space
    end_col = 2;  % right end of plotting space
    start_row = 1;  % lower end of plotting space
    end_row = 2;  % upper end of plotting space
    plot_width = 1;  % width of figures
    plot_height = 1;  % height of figures
  end

  methods
    function obj = figHelper()
      % Default Constructor
      %

      obj.screensize = get(0, 'ScreenSize');
      obj.start_col = floor(obj.screensize(3)/2);
      obj.end_col = obj.screensize(3);
      obj.start_row = 1;
      obj.end_row = obj.screensize(4);
      obj.update_plotsize();
    end
  end
end
